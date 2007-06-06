Return-Path: <linux-kernel-owner+w=401wt.eu-S935576AbXFFTWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935576AbXFFTWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935235AbXFFTUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:20:07 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37889 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935068AbXFFTUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:20:04 -0400
Date: Wed, 6 Jun 2007 21:21:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>, rth@twiddle.net, ink@jurassic.park.msu.ru
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: alpha modpost warnings
Message-ID: <20070606192102.GA6828@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0706041308560.7370@math> <20070605053502.GB21745@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605053502.GB21745@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 07:35:02AM +0200, Sam Ravnborg wrote:
> > WARNING: drivers/built-in.o(.data.rel+0x1a80): Section mismatch: reference to .init.text:serial8250_console_setup (between 'serial8250_console' and '__param_arr_probe_rsa')

I wondered why this one showed up on alpha but nowhere else.
We already whitelist (do not warn about) references to .init.text from
variables named *_console IFF the variable is placed in section .data

But from the above we can see that serial8250_console is placed in .data.rel
Now I wonder why the alpha toolchain suddenly uses a .data.rel section.
The exact commandline to build the .c file is:

alpha-unknown-linux-gnu-gcc -Wp,-MD,drivers/serial/.8250.o.d  -nostdinc -isystem /opt/crosstool/gcc-4.1.0-glibc-2.3.6/alpha-unknown-linux-gnu/lib/gcc/alpha-unknown-linux-gnu/4.1.0/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/sam/kernel/kbuild.git/include -include include/linux/autoconf.h -I/home/sam/kernel/kbuild.git/drivers/serial -Idrivers/serial -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -O2 -pipe -mno-fp-regs -ffixed-8 -msmall-data -mcpu=ev6 -Wa,-mev6 -fomit-frame-pointer -fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(8250)"  -D"KBUILD_MODNAME=KBUILD_STR(8250)" -c -o drivers/serial/8250.o /home/sam/kernel/kbuild.git/drivers/serial/8250.c

No use of -PIC or somethign like that.

Then I tried to reproduce it here - no luck.
I do not see the warning from serial/8250.o here?

I thought that I had all warnings reproduced but in the noise I must have
missed that I did not reproduce the 8250.o warning.

I will consider my patch for 8250.c bad and will drop it.
The others I will forward to akpm.

Anyone that can explain why alpha uses .data.rel in the above case -
but not with my toolchain?

$> gcc --version
alpha-unknown-linux-gnu-gcc (GCC) 4.1.0
Copyright (C) 2006 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	Sam

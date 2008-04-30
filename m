Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYEAF1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYEAF1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 01:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYEAF1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 01:27:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37758 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYEAF1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 01:27:36 -0400
Date: Wed, 30 Apr 2008 00:27:27 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: WARNING: at kernel/panic.c:375
 __stack_chk_test+0x50/0x54()
Message-ID: <20080430002727.00db8e63@linux.intel.com>
In-Reply-To: <48190DBB.9020102@gmail.com>
References: <4819078C.9080405@gmail.com>
	<48190844.5080804@linux.intel.com>
	<48190DBB.9020102@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 21:24:27 -0300
Kevin Winchester <kjwinchester@gmail.com> wrote:

> Arjan van de Ven wrote:
> > Kevin Winchester wrote:
> >> Hi Arjan,
> >>
> >> There doesn't seem to be an entry in MAINTAINERS for stack
> >> protector, but your signoff was on the last stack protector
> >> related commit I could find, so it's probably a good bet.
> >>
> >> I get the following in my dmesg after testing linux-next with the
> >> stack protector turned on.  This is an x86-64 UP box if that
> >> helps.  It appears to be related to the test for the feature (or
> >> perhaps that is supposed to happen when the feature is tested, I'm
> >> not sure...).  Config below.
> >>
> > 
> > the important question is: exactly what gcc are you using? (and if
> > you use a distro gcc, which distro)
> > 
> > second question would be, what does the following command give?
> > 
> > echo "int foo(void) { char X[200]; return 3; }" | $1 -S -xc -c -O0
> > -mcmodel=kernel -fstack-protector - -o -
> > 
> > (this is the command from scripts/gcc-x86_64-has-stack-protector.sh
> > that the kernel uses to test at compiletime if you have stack
> > protector support)
> 
> Ubuntu Hardy Heron
> 
> kevin@alekhine:~$ gcc --version
> gcc (GCC) 4.2.3 (Ubuntu 4.2.3-2ubuntu7)
> Copyright (C) 2007 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There
> is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
> PARTICULAR PURPOSE.
> 
> 
> kevin@alekhine:~$ echo "int foo(void) { char X[200]; return 3; }" |
> $1 -S -xc -c -O0 -mcmodel=kernel -fstack-protector - -o - bash: -S:
> command not found
> 
> I assume that $1 was supposed to be gcc, so how about:

eh woops yes

> 
> kevin@alekhine:~/linux/linux-2.6/scripts$ sh
> gcc-x86_64-has-stack-protector.sh gcc something something
> 
> So I would assume that means I pass...


I would rather really like to see the assembly output this thing spits; to see if your compiler behaves sanely.
(Some distros tend to badly patch their gcc unfortunately and this may break the stack protector feature)

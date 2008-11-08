Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYKHX3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYKHX3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 18:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYKHX3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 18:29:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51043 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYKHX3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 18:29:24 -0500
Date: Sat, 8 Nov 2008 23:28:57 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Pavel Machek <pavel@suse.cz>,
       Eric Miao <eric.y.miao@gmail.com>, Cyril Hrubis <metan@ucw.cz>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, thommycheck@gmail.com
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Message-ID: <20081108232857.GE14351@flint.arm.linux.org.uk>
References: <20081106080416.GA1531@ucw.cz> <20081106191424.GA2273@atrey.karlin.mff.cuni.cz> <f17812d70811070523k59a57d49tac1ab1e5b78d1db4@mail.gmail.com> <20081107142923.GA1616@ucw.cz> <bc64b4640811070657p668dcaedrfd442b0d439b3c78@mail.gmail.com> <20081107182311.GA28600@flint.arm.linux.org.uk> <1226155540.5379.5.camel@dax.rpnet.com> <bc64b4640811081512ta8bfd90m921760839bdf8ffa@mail.gmail.com> <20081108232111.GD14351@flint.arm.linux.org.uk> <bc64b4640811081525o66e51fffy4729008f8e6a0017@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640811081525o66e51fffy4729008f8e6a0017@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 02:25:35AM +0300, Dmitry wrote:
> 2008/11/9 Russell King <rmk+lkml@arm.linux.org.uk>:
> > On Sun, Nov 09, 2008 at 02:12:47AM +0300, Dmitry wrote:
> >> 2008/11/8 Richard Purdie <rpurdie@rpsys.net>:
> >> > Firstly, I don't think that patch should ever make it into a mainline
> >> > kernel. I can perhaps give some clues why its required though. I think
> >> > the bootloader on the zaurus truncates the image when writing the kernel
> >> > into flash using the standard flashing process. By having that much
> >> > extra padding on the end of the kernel, nothing important is lost.
> > ...
> >>
> >> I did rewrote your patch in a bit cleaner way (to apply the hack to
> >> vmlinux.lds.in
> >> in a cleaner way and only on PXA_SHARPSL), however I'm not submitting it
> >> till I find what's the real reason for this problem.
> >
> > Even if the reason is found, I don't think it's something that should
> > concern the kernel, especially as there is a script which writes the
> > kernel image into the flash.  If it's a case that the boot loader needs
> > an extra 4K tacked on the end of the kernel image, that should be easy
> > enough for this 'updater.sh' shell script to do.
> 
> Actually on my tosa builds it's like 40k of zeroes (.bss is before .stack
> and so is also present in the zImage). It seems that just 4k of padding
> isn't enough (I tried that).

That doesn't change my view - it's something that the kernel shouldn't be
caring about.  And as I point out, this script can add the padding itself
which seems to be the right place to resolve the problem.

(and I've finally dropped that bad email address from the CC line.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

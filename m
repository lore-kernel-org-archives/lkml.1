Return-Path: <linux-kernel-owner+w=401wt.eu-S933507AbXJQU0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507AbXJQU0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXJQU0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:26:25 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49477 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbXJQU0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:26:24 -0400
Date: Wed, 17 Oct 2007 22:27:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.23-mm1] CONFIG_LOCALVERSION handling broken
Message-ID: <20071017202756.GA12696@uranus.ravnborg.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <471142A8.40307@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471142A8.40307@imap.cc>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 12:11:52AM +0200, Tilman Schmidt wrote:
> Something seems to be amiss with CONFIG_LOCALVERSION handling.
> 
> I am routinely building with
> CONFIG_LOCALVERSION="-testing"
> CONFIG_LOCALVERSION_AUTO=y
> My usual sequence of "make ; sudo make modules_install install"
> has worked fine for all of 2.6.23{-rc?{,-mm?},}. For 2.6.23-mm1
> it fails with:
> 
> ts@xenon:~/kernel/linux-2.6.23-mm1-work> sudo make modules_install install
> root's password:
>   INSTALL arch/i386/crypto/aes-i586.ko
> [...]
>   INSTALL sound/usb/usx2y/snd-usb-usx2y.ko
> if [ -r System.map -a -x /sbin/depmod ]; then /sbin/depmod -ae -F System.map  2.6.23-mm1; fi
> sh /home/ts/kernel/linux-2.6.23-mm1-work/arch/i386/boot/install.sh 2.6.23-mm1 arch/i386/boot/bzImage System.map "/boot"
> Root device:    /dev/system/root (mounted on / as ext3)
> Module list:    processor thermal ahci pata_marvell aic7xxx fan jbd ext3 dm_mod edd dm-mod dm-snapshot (xennet xenblk dm-mod dm-snapshot)
> 
> Kernel image:   /boot/vmlinuz-2.6.23-mm1
> Initrd image:   /boot/initrd-2.6.23-mm1
> No modules found for kernel 2.6.23-mm1-testing
> ts@xenon:~/kernel/linux-2.6.23-mm1-work>
> 
> That is, both "make modules_install" and "make install" omit
> the "-testing" suffix, "make modules_install" installing the
> modules into /lib/modules/2.6.23-mm1 instead of
> /lib/modules/2.6.23-mm1-testing, and "make install" passing
> "2.6.23-mm1" without the "-testing" suffix to the install.sh
> script, but mkinitrd suddenly rediscovers the real kernel
> version string and consequently looks for modules in
> /lib/modules/2.6.23-mm1-testing, so initrd creation fails.
> 
> Ideas?
Nope...

I have just tried it out with latest -linus tree and I see no bugs.
Note that all kbuild fixes are in latest -linus except for
a few things that are postponed.

I will keep it in mind but nor persuade it further for now.

	Sam

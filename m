Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbZEVSpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbZEVSpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 14:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZEVSpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 14:45:33 -0400
Received: from mail.tmr.com ([64.65.253.246]:46376 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZEVSpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 14:45:32 -0400
Message-ID: <4A16F2C9.1000600@tmr.com>
Date: Fri, 22 May 2009 14:45:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 SeaMonkey/1.1.16
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "make config" to another architecture doesn't relink include/asm
References: <alpine.LFD.2.00.0905221219500.13933@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905221219500.13933@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   should i expect this with a fresh tree on x86_64?
> 
> $ make distclean
> $ make defconfig
> $ make modules_prepare
> $ ls -l include/asm
> lrwxrwxrwx    1 rpjday rpjday     7 2009-05-22 12:24 asm -> asm-x86
> $
> 
>   oh, wait, i changed my mind, i want to switch architectures so start
> over:
> 
> $ make clean
> $ make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- omap3_beagle_defconfig
> $ make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- uImage
> scripts/kconfig/conf -s arch/arm/Kconfig
> include/config/auto.conf:15:warning: symbol value 'arch/x86/configs/x86_64_defconfig' invalid for ARCH_DEFCONFIG
>   CHK     include/linux/version.h
> make[1]: `include/asm-arm/mach-types.h' is up to date.
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
> ERROR: the symlink include/asm points to asm-x86 but asm-arm was expected
>        set ARCH or save .config and run 'make mrproper' to fix it
> make: *** [include/asm] Error 1
> 
> $ ls -l include/asm
> lrwxrwxrwx 1 rpjday rpjday 7 2009-05-22 12:24 include/asm -> asm-x86
> $
> 
>   shouldn't it be sufficient that, if i do another "make ??_defconfig"
> to another architecture, all traces of the previous configure are
> erased and include/asm should be relinked automatically?
> 
Does "make distclean" (or maybe "make mrproper") get you to really clean status?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

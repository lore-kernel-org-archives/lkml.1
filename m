Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZIUNAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZIUNAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbZIUNAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:00:10 -0400
Received: from trinity.fluff.org ([89.16.178.74]:60235 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934AbZIUNAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:00:09 -0400
Date: Mon, 21 Sep 2009 14:00:00 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Shine Liu <shinel@foxmail.com>
Cc: ben-linux@fluff.org, linux-arm-kernel@lists.arm.linux.org.uk,
       inux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM:S3C24XX: Fix a wrong dependency in Kconfig which leads to a compile time error
Message-ID: <20090921130000.GW24720@trinity.fluff.org>
References: <1253519532.5804.30.camel@shinel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253519532.5804.30.camel@shinel>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 03:52:12PM +0800, Shine Liu wrote:
> Hi all,
> 
> There's a small mistake in arch/arm/plat-s3c24xx/Kconfig leads to a
> compile time error when compiling kernel for S3C24XX mach:
> 
>   LD      .tmp_vmlinux1
> arch/arm/mach-s3c2440/built-in.o: In function `mini2440_map_io':
> mach-mini2440.c:(.init.text+0x4a0): undefined reference to `s3c_device_nand'
> arch/arm/mach-s3c2440/built-in.o:(.init.data+0x78c): undefined reference to `s3c_device_nand'
> arch/arm/plat-s3c24xx/built-in.o: In function `s3c244x_map_io':
> common-smdk.c:(.init.text+0x8e4): undefined reference to `s3c_device_nand'
> arch/arm/plat-s3c24xx/built-in.o: In function `smdk_machine_init':
> common-smdk.c:(.init.text+0xe44): undefined reference to `s3c_device_nand'
> arch/arm/plat-s3c24xx/built-in.o:(.init.data+0x18c): undefined reference to `s3c_device_nand'
> make: *** [.tmp_vmlinux1] Error 1
> 
> The bug was introduced by the patch:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=db616eb67604242c11bfbb331bb143bfe4a2e386
> 
> Both kernel 2.6.31 and latest linux-next (next-20090918) has the defect.
> The following patch will fixed this bug.

Hi, thankyou for the great bug report but this is already fixed in
a set sent to RMK.

> Signed-off-by: Shine Liu <shinel@foxmail.com>
> Signed-off-by: Shine Liu <liuxian@redflag-linux.com>
> ----------------------------------------------------
> 
> --- a/arch/arm/plat-s3c24xx/Kconfig	2009-09-21 15:09:59.000000000 +0800
> +++ b/arch/arm/plat-s3c24xx/Kconfig	2009-09-21 15:10:09.000000000 +0800
> @@ -10,7 +10,7 @@
>  	default y
>  	select NO_IOPORT
>  	select ARCH_REQUIRE_GPIOLIB
> -	select S3C_DEVICE_NAND
> +	select S3C_DEV_NAND
>  	help
>  	  Base platform code for any Samsung S3C24XX device

The best solution (although it does touch a number of Kconfig files)
is to ensure each machine that requires the s3c_device_nand defines
a select in their machine Kconfig.

for example:

config MACH_OSIRIS
	....
	select S3C_DEV_NAND
	....

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbXFNKli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbXFNKli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXFNKlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:41:31 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:63665 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbXFNKla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:41:30 -0400
Date: Thu, 14 Jun 2007 11:41:28 +0100
From: Ben Dooks <ben@fluff.org>
To: ?????? <sns2002@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: An error of compile kernel2.6.22-rc3 for ARM CPU s3c2440
Message-ID: <20070614104128.GB7171@fluff.org.uk>
References: <9b9ffe290705280405m5086f2dbldea5961ed2b057ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b9ffe290705280405m5086f2dbldea5961ed2b057ca@mail.gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 07:05:43PM +0800, ?????? wrote:
> Hi,All.
> 
> I compiled new kernel2.6.22-rc3 for my s3c2440 platform yesterday,
> I got follow error message from gcc-compiler.
> 
> >CC      arch/arm/plat-s3c24xx/devs.o
> >linux/linux-2.6/arch/arm/plat-s3c24xx/devs.c:410:
> error:'S3C2443_PA_HSMMC' undeclared here (not in a function)
> >linux/linux-2.6/arch/arm/plat-s3c24xx/devs.c:411:
> error:'S3C2443_SZ_HSMMC' undeclared here (not in a function)
> 
> I found the reason of the error is the two marco  wasn't add into the
> file "arch-s3c2410/map.h",so I make a patch file for the problem.
> 
> >>------------------------------------------------------
> fix_miss_marco_for_s3c2443.patch
> >>------------------------------------------------------
> diff -Nurp linux-2.6.22-rc3-org/include/asm-arm/arch-s3c2410/map.h
> linux-2.6.22-rc3/include/asm-arm/arch-s3c2410/map.h
> --- linux-2.6.22-rc3-org/include/asm-arm/arch-s3c2410/map.h     2007-04-26
> 11:08:32.000000000 +0800
> +++ linux-2.6.22-rc3/include/asm-arm/arch-s3c2410/map.h 2007-05-28
> 18:38:54.000000000 +0800
> @@ -153,6 +153,10 @@
> #define S3C2440_PA_AC97           (0x5B000000)
> #define S3C2440_SZ_AC97           SZ_1M
> 
> +/* High-speed MMC/SD */
> +#define S3C2443_PA_HSMMC          (0x4A800000)
> +#define S3C2443_SZ_HSMMC          0xFF
> +
> /* ISA style IO, for each machine to sort out mappings for, if it
> * implements it. We reserve two 16M regions for ISA.
> */

It was missed out of the original patch to setup the device and
fixed as soon as the error was reported from kautobuild.

Errors like this are better reported to the linux-arm-kernel list
which I read more often than the linux-kernel list.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'

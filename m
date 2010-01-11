Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403Ab0AKMcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0AKMcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321Ab0AKMcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:32:05 -0500
Received: from mga06.intel.com ([134.134.136.21]:6674 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752178Ab0AKMcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:32:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,255,1262592000"; 
   d="scan'208";a="483023114"
Date: Mon, 11 Jan 2010 13:33:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: mfd tree build failure
Message-ID: <20100111123338.GA15938@sortiz.org>
References: <20100111160232.e37e5393.sfr@canb.auug.org.au>
 <20100111105126.GD3440@sirena.org.uk>
 <771cded01001110402p1d2c475bgdde077f066e7f22d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <771cded01001110402p1d2c475bgdde077f066e7f22d@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Mon, Jan 11, 2010 at 07:02:14AM -0500, Haojian Zhuang wrote:
> On Mon, Jan 11, 2010 at 5:51 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Mon, Jan 11, 2010 at 04:02:32PM +1100, Stephen Rothwell wrote:
> >> Hi Sam,
> >
> >> Today's linux-next build (x86_64_allmodconfig, gcc 4.4.0, binutils
> >> 2.19.1) failed like this:
> >
> >> ERROR: "max8925_set_bits" [drivers/video/backlight/max8925_bl.ko] undefined!
> >> ERROR: "max8925_reg_write" [drivers/video/backlight/max8925_bl.ko] undefined!
> >> ERROR: "max8925_reg_read" [drivers/video/backlight/max8925_bl.ko] undefined!
> >> ERROR: "max8925_set_bits" [drivers/regulator/max8925.ko] undefined!
> >> ERROR: "max8925_reg_read" [drivers/regulator/max8925.ko] undefined!
> >
> >> I am not sure what caused this, so I have used the version of the mfd
> >> tree from next-20100108 for today.
> >
> > CCing in Haojian who did the driver.  I've not looked but I'd guess that
> > the issue is missing EXPORT_SYMBOL{,_GPL}s on the symbols above.
> >
> 
> I'm sorry on inconvience. Now I attache the fix.
> 
> Samuel,
> Could you help to review and merge this patch?
Actually, I fixed it. The problem was caused by the mfd and regulator drivers
having the same name, i.e. max8925.ko. I renamed the regulator driver to
max8925-regulator.ko, which also makes it more consistent with the rest of the
regulator drivers.

Stephen, the fix is already pushed, you can resume pulling the latest mfd
bits. Thanks for letting us know about the failure.

Cheers,
Samuel.


> It's not caused by EXPORT_SYMBOL{,_GPL}. If I build in max8925 mfd
> driver, issue is resolved.
> Regulator subsystem could only be built in. And 8925 regulator driver
> calls i2c operations that is defined in mfd driver. If 8925 regulator
> is built it and mfd 8925 is built as module, it will cause linking
> error.
> 
> Thanks
> Haojian

> From cc08aae952302cbc4445f4db49fdfab5f9d779ed Mon Sep 17 00:00:00 2001
> From: Haojian Zhuang <haojian.zhuang@marvell.com>
> Date: Mon, 11 Jan 2010 14:38:39 -0500
> Subject: [PATCH] mfd: set max8925 as built in
> 
> Since regulator module is always built-in, MFD driver have to be built in.
> If MFD driver is built as module, linking error will occur.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 94e4d5e..b892c38 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -186,7 +186,7 @@ config PMIC_ADP5520
>  
>  config MFD_MAX8925
>  	tristate "Maxim Semiconductor MAX8925 PMIC Support"
> -	depends on I2C
> +	depends on I2C=y
>  	select MFD_CORE
>  	help
>  	  Say yes here to support for Maxim Semiconductor MAX8925. This is
> -- 
> 1.5.6.5
> 


-- 
Intel Open Source Technology Centre
http://oss.intel.com/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655Ab0AZIsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab0AZIsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207Ab0AZIsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:48:12 -0500
Received: from mga05.intel.com ([192.55.52.89]:64056 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752027Ab0AZIsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:48:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,345,1262592000"; 
   d="scan'208";a="767354663"
Date: Tue, 26 Jan 2010 09:49:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
       Ian Molton <ian@mnementh.co.uk>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH] mfd: fix asic3 build
Message-ID: <20100126084939.GA28172@sortiz.org>
References: <1264281620-24378-1-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264281620-24378-1-git-send-email-mad_soft@inbox.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Sun, Jan 24, 2010 at 12:20:20AM +0300, Dmitry Artamonow wrote:
> Commit 64e8867ba8 (mfd: tmio_mmc hardware abstraction for CNF area)
> missed to update Makefile rule for asic3, which leads to following
> error during linking:
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `asic3_mmc_clk_div':
> ledtrig-backlight.c:(.text+0x3de28): undefined reference to `tmio_core_mmc_clk_div'
> drivers/built-in.o: In function `asic3_mmc_pwr':
> ledtrig-backlight.c:(.text+0x3de50): undefined reference to `tmio_core_mmc_pwr'
> drivers/built-in.o: In function `asic3_mmc_enable':
> ledtrig-backlight.c:(.text+0x3e154): undefined reference to `tmio_core_mmc_enable'
> make: *** [.tmp_vmlinux1] Error 1
Thanks a lot, patch applied. I will ask Linus to pull it in a couple days or
so.

Cheers,
Samuel.


> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> ---
> This is a patch for regression introduced in -rc5 (-rc4 was ok)
> Error above is from building kernel 2.6.33-rc5 with magician_defconfig.
> Sorry if this already been reported/fixed.
> 
>  drivers/mfd/Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 8f0d184..97134c5 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -3,7 +3,7 @@
>  #
>  
>  obj-$(CONFIG_MFD_SM501)		+= sm501.o
> -obj-$(CONFIG_MFD_ASIC3)		+= asic3.o
> +obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
>  obj-$(CONFIG_MFD_SH_MOBILE_SDHI)		+= sh_mobile_sdhi.o
>  
>  obj-$(CONFIG_HTC_EGPIO)		+= htc-egpio.o
> -- 
> 1.6.6
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

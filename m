Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZBFN4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZBFN4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbZBFNz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:55:59 -0500
Received: from mga05.intel.com ([192.55.52.89]:5378 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754326AbZBFNz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:55:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,391,1231142400"; 
   d="scan'208";a="663431908"
Date: Fri, 6 Feb 2009 14:58:22 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: broonie@opensource.wolfsonmicro.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: tries reaches -1
Message-ID: <20090206135821.GD3341@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <4981CB45.8010108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4981CB45.8010108@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 04:29:09PM +0100, Roel Kluin wrote:
> With a postfix decrement tries will reach -1 rather than 0,
> so the warning will not be issued even upon timeout.
Thanks Roel, applied.

 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> index f92595c..2e0e5c2 100644
> --- a/drivers/mfd/wm8350-core.c
> +++ b/drivers/mfd/wm8350-core.c
> @@ -1111,7 +1111,7 @@ int wm8350_read_auxadc(struct wm8350 *wm8350, int channel, int scale, int vref)
>  	do {
>  		schedule_timeout_interruptible(1);
>  		reg = wm8350_reg_read(wm8350, WM8350_DIGITISER_CONTROL_1);
> -	} while (tries-- && (reg & WM8350_AUXADC_POLL));
> +	} while (--tries && (reg & WM8350_AUXADC_POLL));
>  
>  	if (!tries)
>  		dev_err(wm8350->dev, "adc chn %d read timeout\n", channel);
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZJSSkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZJSSkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 14:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZJSSkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 14:40:24 -0400
Received: from mga05.intel.com ([192.55.52.89]:14236 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751290AbZJSSkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 14:40:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,586,1249282800"; 
   d="scan'208";a="738072268"
Date: Mon, 19 Oct 2009 20:42:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32] mfd: Always initialise WM831x IRQ mutex
Message-ID: <20091019184223.GI3885@sortiz.org>
References: <1255946825-9569-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255946825-9569-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Oct 19, 2009 at 11:07:05AM +0100, Mark Brown wrote:
> This avoids crashes when running without interrupt support.
Thanks. I'll send a pull request with a couple more fixes in a few days.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm831x-irq.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
> index d3015df..ac056ea 100644
> --- a/drivers/mfd/wm831x-irq.c
> +++ b/drivers/mfd/wm831x-irq.c
> @@ -507,6 +507,8 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
>  {
>  	int i, ret;
>  
> +	mutex_init(&wm831x->irq_lock);
> +
>  	if (!irq) {
>  		dev_warn(wm831x->dev,
>  			 "No interrupt specified - functionality limited\n");
> @@ -521,7 +523,6 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
>  	}
>  
>  	wm831x->irq = irq;
> -	mutex_init(&wm831x->irq_lock);
>  	INIT_WORK(&wm831x->irq_work, wm831x_irq_worker);
>  
>  	/* Mask the individual interrupt sources */
> -- 
> 1.6.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

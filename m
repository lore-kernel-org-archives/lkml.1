Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZHLQEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZHLQEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZHLQEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:04:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:31547 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbZHLQEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=EMH7jB2j+LZYV+1dhbb2SWBnonK4+7SABLsBwCmbzjpq+cBmnHnVvZfGbtsSUGCV/2
         QeWX2IiX17AZDMwRJpRA8VuxYKajTP/xQ+o3aD6N0v2qJzaANMnwc1BextAIXQl818bP
         hH3wRX7pbjHsu/OtvtZEqHaI1zWB6vutW27Nk=
Date: Wed, 12 Aug 2009 09:04:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-input@vger.kernel.org
Subject: Re: [PATCH 2/5] [input] add mc13783 touchscreen driver
References: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-2-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090812163521.75631526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 05:05:28PM +0200, Sascha Hauer wrote:
> This driver provides support for the touchscreen interface
> integrated into the Freescale MC13783.
> 
> changes since v1:
> 
> - remove unused functions
> - use queue_delayed_work instead of queue_work
> - report pen events as BTN_TOUCH instead of ABS_PRESSURE
> - handle interrupt registration in open/close functions
> - do not call input_free_device() on already registered
>   input_device
> - use platform_driver_probe instead of platform_driver_register

BTW, if you are using platform_driver_probe() then __init is OK for
.probe() because all probes will only be run once, when driver loads.
IIRC the ability to discard probe() code was the main reason for
introducing platform_driver_probe().

> +
> +	/* unmask the ts wakeup interrupt */
> +	mc13783_set_bits(priv->mc13783, MC13783_REG_INTERRUPT_MASK_0,
> +			MC13783_INT_MASK_TSM, 0);
> +
> +	mc13783_adc_set_ts_status(priv->mc13783, 1);
> +

I actually expected these bits to go into ->open(); not the request IRQ
stuff...

-- 
Dmitry

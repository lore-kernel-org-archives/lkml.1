Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438Ab0CLSWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 13:22:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:46453 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934119Ab0CLSWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 13:22:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WtaEwUeZ2bKDnCSnySwYg2Jr4J3xfHePmK8EHLEfrY/JFpDiFmNCj4X85W3C9gsrYW
         d206GOly9ZW154W7yCUAvywcqd4zXNrBUZBW2iljMfTWoCiMPd9AvWlfDyPaehQr+IFF
         x2xi/FUBRmfOysb2c8dMogDcDJ4unGE3BLo0Q=
Date: Fri, 12 Mar 2010 10:22:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: florian@mickler.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] enhance sysfs rfkill interface
Message-ID: <20100312182209.GB8736@core.coreip.homeip.net>
References: <1268416988-24862-1-git-send-email-florian@mickler.org>
 <1268416988-24862-2-git-send-email-florian@mickler.org>
 <1268416988-24862-3-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268416988-24862-3-git-send-email-florian@mickler.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 07:03:08PM +0100, florian@mickler.org wrote:
>  
> +static ssize_t rfkill_hard_show(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	struct rfkill *rfkill = to_rfkill(dev);
> +	unsigned long flags;
> +	u32 state;
> +
> +	spin_lock_irqsave(&rfkill->lock, flags);
> +	state = rfkill->state;
> +	spin_unlock_irqrestore(&rfkill->lock, flags);

Why exactly is this lock needed?

> +
> +	return sprintf(buf, "%d\n", (state & RFKILL_BLOCK_HW) ? 1 : 0 );
> +}
> +
> +static ssize_t rfkill_soft_show(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	struct rfkill *rfkill = to_rfkill(dev);
> +	unsigned long flags;
> +	u32 state;
> +
> +	spin_lock_irqsave(&rfkill->lock, flags);
> +	state = rfkill->state;
> +	spin_unlock_irqrestore(&rfkill->lock, flags);

And here as well...

-- 
Dmitry

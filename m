Return-Path: <linux-kernel-owner+w=401wt.eu-S1750791AbXBVKwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750791AbXBVKwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXBVKwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:52:10 -0500
Received: from matups.math.u-psud.fr ([129.175.50.4]:47327 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbXBVKwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:52:09 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <254ad70138dc1cdf241hjzcr0007jhhw@thunder.lp0.eu>
Subject: Re: [PATCH 2/2] usbatm: Detect usb device shutdown and ignore failed urbs.
Date: Thu, 22 Feb 2007 11:43:38 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <45DCBC26.1050308@simon.arlott.org.uk>
In-Reply-To: <45DCBC26.1050308@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702221143.38809.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +		/* the module/device has probably been removed */
> +		if (urb->status == -ESHUTDOWN)
> +			return;
> +
>  		if (printk_ratelimit())
>  			atm_warn(channel->usbatm, "%s: urb 0x%p failed (%d)!\n",
>  				__func__, urb, urb->status);

I would rather just suppress the warning in this case, and still do the delayed
schedule of the tasklet, in case this error was spurious and we're not really
about to be disconnected.

Ciao,

Duncan.

PS: I plan to work on the drivers this weekend.

Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXAaOUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXAaOUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 09:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933291AbXAaOUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 09:20:00 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:36893 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933289AbXAaOT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 09:19:59 -0500
X-Greylist: delayed 12324 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 09:19:59 EST
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <e5d74fcd64729b17de1hc0yh0003aeoo@thunder.lp0.eu>
Subject: Re: [PATCH 3/3] cxacru: Store all device status information and report it when atm_proc_read is called.
Date: Wed, 31 Jan 2007 15:19:51 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <45BFB8F5.5010607@simon.arlott.org.uk>
In-Reply-To: <45BFB8F5.5010607@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311519.52023.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

> +static int cxacru_proc_read(struct usbatm_data *usbatm_instance,
> +	struct atm_dev *atm_dev, loff_t * pos, char *page)
> +{
> +	struct cxacru_data *instance = usbatm_instance->driver_data;
> +	u32 *cxinf = instance->cxinf_status;
> +	int left = *pos;

if there was no successfull call to cxacru_poll_status before this,
then you will output junk.  Please initialize cxinf_status to something
sensible in cxacru_bind.

> +       if (!left--)
> +               return sprintf(page, "MAC=%02x:%02x:%02x:%02x:%02x:%02x\n",
> +                                       atm_dev->esi[0], atm_dev->esi[1],
> +                                       atm_dev->esi[2], atm_dev->esi[3],
> +                                       atm_dev->esi[4], atm_dev->esi[5]);

Rather than duplicating code in usbatm, I think it would be better to
split the various output bits in usbatm_atm_proc_read into their own
functions, and export them, so they can be called from both
usbatm_atm_proc_read and cxacru_proc_read.

Best wishes,

Duncan.

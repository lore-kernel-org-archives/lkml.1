Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752195AbYLRPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbYLRPMT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 10:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYLRPME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 10:12:04 -0500
Received: from mail.openmoko.org ([88.198.124.205]:53681 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYLRPMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 10:12:02 -0500
Date: Thu, 18 Dec 2008 20:41:43 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: Re: [PATCH V2 4/7] rtc: PCF50633 rtc driver
Message-ID: <20081218151142.GA2284@cff.thadambail>
References: <20081218055618.31696.65002.stgit@cff.thadambail> <20081218055726.31696.80688.stgit@cff.thadambail> <20081218100310.385bb808@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218100310.385bb808@i1501.lan.towertech.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 10:03:10AM +0100, Alessandro Zummo wrote:
> On Thu, 18 Dec 2008 11:27:26 +0530
> Balaji Rao <balajirrao@openmoko.org> wrote:
> 
> > Changes from V1:
> > 	- Removed include/linux/mfd/pcf50633/rtc.h and moved defenitions into
> > 	  the source file.
> > 	- Remove PIE and introduce UIE support. UIE being the one actually
> > 	  supported in the chip.
> > 
> > Alessandro, I'll change to the new API for AIE once it appears upstream.
> 
>  Ok, I guess the driver will not go in tomorrow, so you can wait.
>  I'd add it now, while you're at it :)
> 

OK! :) So that I can change when it's in -next ?

> > +config RTC_DRV_PCF50633
> > +	depends on MFD_PCF50633
> > +	tristate "NXP PCF50633 RTC"
> > +	help
> > +	  If you say yes here you get support for the NXP PCF50633 RTC.
> 
>  a more detailed description please stating which platforms commonly
>  have this rtc
> 

OK.

> > +static int __devinit pcf50633_rtc_probe(struct platform_device *pdev)
> > +{
> > +	struct pcf50633_subdev_pdata *pdata;
> > +	struct pcf50633_rtc *rtc;
> > +	struct rtc_device *rtc_dev;
> > +
> > +	rtc_dev = rtc_device_register("pcf50633-rtc", &pdev->dev,
> > +				&pcf50633_rtc_ops, THIS_MODULE);
> > +
> > +	if (IS_ERR(rtc_dev))
> > +		return PTR_ERR(rtc_dev);
> > +
> > +	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
> > +	if (!rtc) {
> > +		dev_err(&pdev->dev, "allocation of pcf50633_rtc failed\n");
> > +		rtc_device_unregister(rtc_dev);
> > +		return -ENOMEM;
> > +	}
> 
>  once registered, the rtc could be immediately in use. you should first allocate
>  and setup your data structures and only then register the device:
> 

Oh, yea right. Will fix.

> > +static int __devexit pcf50633_rtc_remove(struct platform_device *pdev)
> > +{
> > +	struct pcf50633_rtc *rtc;
> > +
> > +	rtc = platform_get_drvdata(pdev);
> > +	rtc_device_unregister(rtc->rtc_dev);
> > +
> > +	pcf50633_free_irq(rtc->pcf, PCF50633_IRQ_ALARM);
> > +	pcf50633_free_irq(rtc->pcf, PCF50633_IRQ_SECOND);
> 
>  please remove rtc before unregistering
> 

Sorry, didn't get you meant.

Thank you for the review.

	-Balaji

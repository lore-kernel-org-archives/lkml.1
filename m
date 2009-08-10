Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZHJVI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZHJVI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 17:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZHJVI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 17:08:26 -0400
Received: from mx0.towertech.it ([213.215.222.73]:46716 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753197AbZHJVIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 17:08:25 -0400
Date: Mon, 10 Aug 2009 23:08:24 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: broonie@opensource.wolfsonmicro.com, Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [rtc-linux] Re: [PATCH 4/5] RTC: Add support for RTCs on
 Wolfson WM831x devices
Message-ID: <20090810230824.6d90d176@i1501.lan.towertech.it>
In-Reply-To: <20090810205712.GA4528@sirena.org.uk>
References: <1249922635-31864-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1249922635-31864-4-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20090810205535.4fb160af@i1501.lan.towertech.it>
	<20090810205712.GA4528@sirena.org.uk>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 21:57:13 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> 
> >  given you have your own include directory undef mfd/
> >  you might want to move those #defines there
> 
> Unlike the others these registers can't really be used outside of this
> driver - for the other drivers there's potential for at least platform
> specific code if not multiple drivers to use some or all of the register
> definitions.

 ack.
 
> > > +struct wm831x_rtc {
> > > +	struct wm831x *wm831x;
> > > +	struct rtc_device *rtc;
> > > +	int alarm_enabled;
> > > +	int per_irq;
> 
> >  are those tows int or unsigned int? 
> 
> I've just dropped per_irq, it's not needed anyway.
> 
> >  or maybe alarm_enabled could be :1 ?
> 
> Done, but it doesn't really buy us much given that there's nothing
> else to pack it with.

 ack.

> > > +/*
> > > + * Set current time and date in RTC
> > > + */
> > > +static int wm831x_rtc_settime(struct device *dev, struct rtc_time *tm)
> 
> >  isn't rtc_set_mmss more appropriate?
> 
> Hrm, I think so so I've made the change.  It's not a particularly
> discoverable API - the fact that there's no readback equivalent hides
> the fact that it's supposed to be an equivalent for settime.  Some
> documentation would really help here.

 you're right. there's one but it's still in my tree. will push it
 one day.

> 
> > > +	ret = wm831x_set_bits(wm831x_rtc->wm831x, WM831X_RTC_CONTROL,
> > > +			      WM831X_RTC_ALM_ENA, enable);
> > > +	if (ret != 0)
> > > +		dev_err(&pdev->dev, "Failed to update RTC alarm: %d\n", ret);
> > > +
> > > +	return 0;
> 
> >  always 0 ? (also below..)
> 
> Failing suspend and resume due to failure to disable the RTC alarm
> would be excessive - indeed, I'd expect the overwhelming majority of
> systems to function perfectly well with no suspend/resume support in the
> driver at all.  RTC alarms are infrequent relative to other
> suspend/resume events in typical systems but suspend is normally used
> fairly heavily to preserve battery (typical applications include things
> like MP3 players or phones).  Typically the error handling would at best
> cause more serious consequences than the original error and there's
> little chance the user will be able to even report the error.

 ack.

> > > +static int __init wm831x_rtc_init(void)
> > > +{
> > > +	return platform_driver_register(&wm831x_rtc_driver);
> 
> >  can you use platform_driver_probe() ?
> 
> No, this is a MFD accessed over slow buses and we can't guarantee that
> the device will be registered.
> 
> Fixed everything else, will repost tomorrow.

 here's my acked-by in advance, feel free to push the patch
 with the series.

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it


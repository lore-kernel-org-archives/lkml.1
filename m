Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbZHMPwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbZHMPwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZHMPwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:52:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:28076 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZHMPwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=Lw2kNPqGum4odwmm8sidNdEh18PCJv5snILV47pUKm55QLOlgubumtO4/DU+v53rZf
         /aeCMW+H0RvD6F5fRjkfZWqG390UmOMbg/H51HmsbBZ0dbYZz6yVPJqGpdf8fBadOJC2
         JQIeB0STxZOVeOJyYjA1iXyFBFQouKEi2ra9I=
Date: Thu, 13 Aug 2009 08:52:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-input@vger.kernel.org
Subject: Re: [PATCH 2/5] [input] add mc13783 touchscreen driver
References: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-2-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de> <20090812163521.75631526EC9@mailhub.coreip.homeip.net> <20090813122648.GH17992@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813122648.GH17992@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090813162321.5A2F5526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 02:26:48PM +0200, Sascha Hauer wrote:
> On Wed, Aug 12, 2009 at 09:04:38AM -0700, Dmitry Torokhov wrote:
> > On Wed, Aug 12, 2009 at 05:05:28PM +0200, Sascha Hauer wrote:
> > > This driver provides support for the touchscreen interface
> > > integrated into the Freescale MC13783.
> > > 
> > > changes since v1:
> > > 
> > > - remove unused functions
> > > - use queue_delayed_work instead of queue_work
> > > - report pen events as BTN_TOUCH instead of ABS_PRESSURE
> > > - handle interrupt registration in open/close functions
> > > - do not call input_free_device() on already registered
> > >   input_device
> > > - use platform_driver_probe instead of platform_driver_register
> > 
> > BTW, if you are using platform_driver_probe() then __init is OK for
> > .probe() because all probes will only be run once, when driver loads.
> > IIRC the ability to discard probe() code was the main reason for
> > introducing platform_driver_probe().
> 
> But __devinit should be ok also, right?
> 

It is OK but then what is the point of using platform_driver_probe()
instead of platform_driver_register()? The only reason you'd want to use
platform_driver_probe() if you wanted to discard the probe methods but
it will not happen if the are marked __devinit.

> > 
> > > +
> > > +	/* unmask the ts wakeup interrupt */
> > > +	mc13783_set_bits(priv->mc13783, MC13783_REG_INTERRUPT_MASK_0,
> > > +			MC13783_INT_MASK_TSM, 0);
> > > +
> > > +	mc13783_adc_set_ts_status(priv->mc13783, 1);
> > > +
> > 
> > I actually expected these bits to go into ->open(); not the request IRQ
> > stuff...
> 
> Yes I know, I just found it convenient to request the interrupts there
> so that we do not risk getting interrupts nobody is interested in this
> moment.
> 

OK, but still, the bits above should be moved to open() as well, right?

-- 
Dmitry

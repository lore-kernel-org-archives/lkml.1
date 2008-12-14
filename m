Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYLNXaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYLNXaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 18:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYLNXaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 18:30:04 -0500
Received: from mail.openmoko.org ([88.198.124.205]:37289 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYLNXaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 18:30:03 -0500
Date: Mon, 15 Dec 2008 04:59:46 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Andy Green <andy@openmoko.com>
Subject: Re: [rtc-linux] Re: [PATCH 4/7] rtc: PCF50633 rtc driver
Message-ID: <20081214232945.GC2741@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail> <20081214110304.3307.53502.stgit@cff.thadambail> <20081214202956.1f97b906@i1501.lan.towertech.it> <20081214220428.GA2741@cff.thadambail> <20081214232128.5c886379@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081214232128.5c886379@i1501.lan.towertech.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 11:21:28PM +0100, Alessandro Zummo wrote:
> On Mon, 15 Dec 2008 03:34:30 +0530
> Balaji Rao <balajirrao@openmoko.org> wrote:
> 
> > Hmm. This patch is included in [PATCH 1/7] of the series - which
> > implements the core driver. This core driver needs this file to compile
> > and not including there is going to break the bisectability of the
> > series. Isn't this what I'm supposed to do ? Please correct me if I'm
> > wrong.
> 
>  ok, then don't break.
>  

OK, thinking more about this, I realised that this series, has to be
taken in together, as rtc-pcf50633.c alone wouldn't compile for you..

Probably it could be taken into the MFD tree once you ACK this ? I don't
know.. If this is not a problem at all, please feel free to ignore me!

> > > > +	pcf = platform_get_drvdata(pdev);
> > > 
> > >  uh? where did you set up the pointer?
> > > 
> > > 
> > > > +	/* Set up IRQ handlers */
> > > > +	pcf->irq_handler[PCF50633_IRQ_ALARM].handler = pcf50633_rtc_irq;
> > > > +	pcf->irq_handler[PCF50633_IRQ_SECOND].handler = pcf50633_rtc_irq;
> > > > +
> > > > +	pcf->rtc.rtc_dev = rtc;
> > > 
> > >  ??
> > > 
> > 
> > It's done in the core driver - [PATCH 1/7] of this series.
> 
>  mm. that's strange. a platform driver is supposed to receive informational
>  structures (regions, irqs, ...) and init driver data by itself. you shouldn't need
>  to mess with the drvdata pointer.
> 

Oh, ok. I now see how I can do better. Will wait for comments for the
rest of the series and post a improved version.

>  I do not also feel fine with the irq handlers setup. Your core should export
>  a function for irq registration.
>

Yes, ok.
 
> > Thank you for the review. Will send again after resolving the issues.
> 
>  thanks for your contribution. you are doing great things at openmoko.
> 

You're welcome.

	- Balaji

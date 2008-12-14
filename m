Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYLNWWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYLNWWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 17:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYLNWVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 17:21:52 -0500
Received: from mx0.towertech.it ([213.215.222.73]:42198 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751909AbYLNWVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 17:21:52 -0500
Date: Sun, 14 Dec 2008 23:21:28 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: balajirrao@openmoko.org, linux-kernel@vger.kernel.org,
       Andy Green <andy@openmoko.com>
Subject: Re: [rtc-linux] Re: [PATCH 4/7] rtc: PCF50633 rtc driver
Message-ID: <20081214232128.5c886379@i1501.lan.towertech.it>
In-Reply-To: <20081214220428.GA2741@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail>
	<20081214110304.3307.53502.stgit@cff.thadambail>
	<20081214202956.1f97b906@i1501.lan.towertech.it>
	<20081214220428.GA2741@cff.thadambail>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008 03:34:30 +0530
Balaji Rao <balajirrao@openmoko.org> wrote:

> Hmm. This patch is included in [PATCH 1/7] of the series - which
> implements the core driver. This core driver needs this file to compile
> and not including there is going to break the bisectability of the
> series. Isn't this what I'm supposed to do ? Please correct me if I'm
> wrong.

 ok, then don't break.
 
> > > +	pcf = platform_get_drvdata(pdev);
> > 
> >  uh? where did you set up the pointer?
> > 
> > 
> > > +	/* Set up IRQ handlers */
> > > +	pcf->irq_handler[PCF50633_IRQ_ALARM].handler = pcf50633_rtc_irq;
> > > +	pcf->irq_handler[PCF50633_IRQ_SECOND].handler = pcf50633_rtc_irq;
> > > +
> > > +	pcf->rtc.rtc_dev = rtc;
> > 
> >  ??
> > 
> 
> It's done in the core driver - [PATCH 1/7] of this series.

 mm. that's strange. a platform driver is supposed to receive informational
 structures (regions, irqs, ...) and init driver data by itself. you shouldn't need
 to mess with the drvdata pointer.

 I do not also feel fine with the irq handlers setup. Your core should export
 a function for irq registration.

> Thank you for the review. Will send again after resolving the issues.

 thanks for your contribution. you are doing great things at openmoko.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it


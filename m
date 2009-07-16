Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbZGPXPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbZGPXPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933546AbZGPXPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:15:20 -0400
Received: from kroah.org ([198.145.64.141]:52488 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933112AbZGPXPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:15:20 -0400
Date: Thu, 16 Jul 2009 15:58:09 -0700
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register:  warn if probe is in
 .init.text
Message-ID: <20090716225809.GA3609@kroah.com>
References: <20090616182310.GC13048@pengutronix.de>
 <1245418939-20758-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20090619141128.GA11506@suse.de>
 <20090619144354.GA20985@pengutronix.de>
 <20090629075535.GA20155@pengutronix.de>
 <20090711033459.GC1344@suse.de>
 <20090711100014.GA9540@pengutronix.de>
 <20090711185920.GB25363@kroah.com>
 <20090711204631.GA12446@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090711204631.GA12446@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 11, 2009 at 10:46:31PM +0200, Uwe Kleine-König wrote:
> Hello Greg,
> 
> On Sat, Jul 11, 2009 at 11:59:20AM -0700, Greg KH wrote:
> > On Sat, Jul 11, 2009 at 12:00:14PM +0200, Uwe Kleine-König wrote:
> > > Hi Greg,
> > > 
> > > > > Are you conviced and took the patch or did you give up to convince me?
> > > > 
> > > > Heh, no, sorry, it got burried in my queue.
> > > > 
> > > > > I still think the patch is correct and I'd like to have it applied.
> > > > 
> > > > Ok, let's test it out in the linux-next tree for a while to make sure it
> > > > works properly.  Care to send me an updated version?
> > > I updated to latest Linus' master.  It applies to linux-next from
> > > Fri Jul 10 14:44:30 2009 +1000 as is.
> > > 
> > > Back some time I sent a series that fixes many of these bugs.  I will
> > > update it later today and resend.
> > > 
> > > Best regards and thanks,
> > > Uwe
> > > 
> > > ---->8----
> > > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > Subject: [PATCH] platform_driver_register:  warn if probe is in .init.text
> > > 
> > > with HOTPLUG=y it's wrong to register a platform_driver whose probe
> > > function lives in .init.text because the probe function can be called
> > > (e.g. via sysfs or by registering a device late) after the init sections
> > > are already discarded.  This results in an oops.
> > > 
> > > So warn if such a driver is registered.
> > > 
> > > Without HOTPLUG the probe function can (and should) be discarded if the
> > > driver is registered while the init sections are still available.
> > > In this case warn if the probe function isn't discarded later.  (As
> > > described in the comments there is a small chance for a wrong warning.
> > > But as HOTPLUG=n is unusual today and the situation is strage enough to
> > > be cleaned up anyhow, I think this is OK.)
> > > 
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > This code kills the build in very bad ways :(
> it's just a ; that didn't made it into the new version.  Don't know why.
> 
> If you squash the patch below into the patch I sent it should work
> again.

I don't have the original anymore :(

As it seemed that a lot of people who controlled the problem drivers
didn't like the patches, what are you considering doing now?

thanks,

greg k-h

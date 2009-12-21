Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZLUWjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZLUWjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 17:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbZLUWjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 17:39:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43267 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbZLUWje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 17:39:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] PM: Make the initcall_debug style timing for suspend/resume complete
Date: Mon, 21 Dec 2009 23:40:16 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0912211612340.3328-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912211612340.3328-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912212340.16279.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 December 2009, Alan Stern wrote:
> On Mon, 21 Dec 2009, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Commit f2511774863487e61b56a97da07ebf8dd61d7836
> > (PM: Add initcall_debug style timing for suspend/resume) introduced
> > basic timing instrumentation, needed for a scritps/bootgraph.pl
> > equivalent or humans, but it missed the fact that bus types and
> > device classes which haven't been switched to using struct dev_pm_ops
> > objects yet need special handling.  As a result, the suspend/resume
> > timing information is only available for devices whose bus types or
> > device classes use struct dev_pm_ops objects, so the majority of
> > devices is not covered.
> > 
> > Fix this by adding basic suspend/resume timing instrumentation for
> > devices whose bus types and device classes still don't use struct
> > dev_pm_ops objects for power management.  To reduce code duplication
> > move the timing code to helper functions.
> 
> A minor complaint...
> 
> > +/**
> >   * device_resume - Execute "resume" callbacks for given device.
> >   * @dev: Device to handle.
> >   * @state: PM transition of the system being carried out.
> > @@ -427,7 +465,7 @@ static int device_resume(struct device *
> >  			error = pm_op(dev, dev->bus->pm, state);
> >  		} else if (dev->bus->resume) {
> >  			pm_dev_dbg(dev, state, "legacy ");
> > -			error = dev->bus->resume(dev);
> > +			error = legacy_resume(dev, dev->bus->resume);
> >  		}
> >  		if (error)
> >  			goto End;
> > @@ -448,7 +486,7 @@ static int device_resume(struct device *
> >  			error = pm_op(dev, dev->class->pm, state);
> >  		} else if (dev->class->resume) {
> >  			pm_dev_dbg(dev, state, "legacy class ");
> > -			error = dev->class->resume(dev);
> > +			error = legacy_resume(dev, dev->class->resume);
> >  		}
> >  	}
> 
> If none of the method callbacks are non-NULL, this won't print 
> anything.  The same is true for device_suspend().
> 
> Now maybe you don't _want_ to print anything in that case, but for
> debugging purposes it could be useful.

I'm going to add that in a separate patch.

Rafael

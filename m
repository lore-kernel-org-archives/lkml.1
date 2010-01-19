Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824Ab0ASUcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0ASUcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123Ab0ASUcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:32:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57696 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab0ASUcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:32:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Update][RFC][PATCH] PM / Runtime: Add sysfs switch for disabling device run-time PM
Date: Tue, 19 Jan 2010 21:32:26 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1001191035150.1437-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001191035150.1437-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001192132.26765.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 January 2010, Alan Stern wrote:
> On Mon, 18 Jan 2010, Rafael J. Wysocki wrote:
> 
> > > Ouch.  This does nearly the same thing as the power/level attribute in
> > > the USB subsystem, but in an incompatible and more complicated way.
> > > 
> > > The power/level attribute can contain either "on" or "auto", meaning
> > > that the device is always on or that it is subject to automatic runtime
> > > power management (autosuspend).
> > 
> > It looks like my "disable" is similar to "on", while my "enable" is similar to
> > "auto".  I can use "auto" and "on" just fine.
> 
> Good.
> 
> > > Changing the setting from "auto" to "on" merely does sets a flag and does
> > > pm_runtime_get_sync(); changing it from "on" to "auto" clears the flag and
> > > does pm_runtime_put_sync().
> > 
> > We can do it almost this way in general, although I think the flag should be
> > changed under the power.lock.
> 
> Yes.  I was using the device semaphore, but the power.lock is more 
> appropriate here.
> 
> > Updated patch is appended.
> 
> Why change the name from "level" to "runtime"?

Because it wouldn't be really obvious what "level" applied to.  For example,
some people might expect the values of "level" to correspond to PCI power
states for PCI devices and so on, so it might turn out to be confusing. 

> >  /*
> > + *	runtime - Report/change current runtime PM setting of the device
> > + *
> > + *	Runtime power management of a device can be blocked with the help of
> > + *	this attribute.  All devices have one of the following two values for
> > + *	the power/runtime file:
> > + *
> > + *	 + "auto\n" to allow the device to be power managed at run time;
> > + *	 + "on\n" to prevent the device from being power managemed at run time;
> 
> ---------------------------------------------------------------^^  typo

Ah, thanks

> Don't forget to add an entry to Documentation/ABI/testing/.

OK

Rafael

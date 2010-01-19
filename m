Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975Ab0ASPke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0ASPke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819Ab0ASPkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:40:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37704 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753921Ab0ASPk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:40:28 -0500
Date: Tue, 19 Jan 2010 10:40:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [Update][RFC][PATCH] PM / Runtime: Add sysfs switch for disabling
 device run-time PM
In-Reply-To: <201001182325.28094.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001191035150.1437-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010, Rafael J. Wysocki wrote:

> > Ouch.  This does nearly the same thing as the power/level attribute in
> > the USB subsystem, but in an incompatible and more complicated way.
> > 
> > The power/level attribute can contain either "on" or "auto", meaning
> > that the device is always on or that it is subject to automatic runtime
> > power management (autosuspend).
> 
> It looks like my "disable" is similar to "on", while my "enable" is similar to
> "auto".  I can use "auto" and "on" just fine.

Good.

> > Changing the setting from "auto" to "on" merely does sets a flag and does
> > pm_runtime_get_sync(); changing it from "on" to "auto" clears the flag and
> > does pm_runtime_put_sync().
> 
> We can do it almost this way in general, although I think the flag should be
> changed under the power.lock.

Yes.  I was using the device semaphore, but the power.lock is more 
appropriate here.

> Updated patch is appended.

Why change the name from "level" to "runtime"?

>  /*
> + *	runtime - Report/change current runtime PM setting of the device
> + *
> + *	Runtime power management of a device can be blocked with the help of
> + *	this attribute.  All devices have one of the following two values for
> + *	the power/runtime file:
> + *
> + *	 + "auto\n" to allow the device to be power managed at run time;
> + *	 + "on\n" to prevent the device from being power managemed at run time;

---------------------------------------------------------------^^  typo

Don't forget to add an entry to Documentation/ABI/testing/.

Alan Stern


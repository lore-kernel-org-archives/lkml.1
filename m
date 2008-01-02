Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbYABQse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbYABQse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYABQsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:48:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42672 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbYABQsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:48:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4] PM: Introduce destroy_suspended_device()
Date: Wed, 2 Jan 2008 17:50:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0801021122070.5062-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801021122070.5062-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021750.16359.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of January 2008, Alan Stern wrote:
> On Wed, 2 Jan 2008, Rafael J. Wysocki wrote:
> 
> > On Wednesday, 2 of January 2008, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > It sometimes is necessary to destroy a device object during a suspend or
> > > hibernation, but the PM core is supposed to control all device objects in that
> > > cases.  For this reason, it is necessary to introduce a mechanism allowing one
> > > to ask the PM core to remove a device object corresponding to a suspended
> > > device on one's behalf.
> > > 
> > > Define function destroy_suspended_device() that will schedule the removal of
> > > a device object corresponding to a suspended device by the PM core during the
> > > subsequent resume.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Sorry, a small fix is needed for this patch.  Namely, dpm_sysfs_remove(dev)
> > should not be called by device_pm_schedule_removal(), because it will be called
> > anyway from device_pm_remove() when the device object is finally unregistered
> > (we're talking here about unlikely error paths only, but still).
> 
> The situation is a little confusing, because the source files under 
> drivers/base/power are maintained in Greg's tree and he already has 
> gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch 
> installed.  That patch conflicts with this one.
> 
> One of the these two patches will have to be rewritten to apply on top 
> of the other.  Which do you think should be changed?

Well, from the bisectability point of view, it would be better to adjust
gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch and let the
$subject patch series go first, if you don't mind.

Rafael

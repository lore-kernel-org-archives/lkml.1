Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYCFRkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYCFRkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYCFRki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:40:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36218 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751242AbYCFRki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:40:38 -0500
Date: Thu, 6 Mar 2008 12:40:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations
 concurrent with suspend/hibernation
In-Reply-To: <200803061726.03277.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803061233460.7892-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Rafael J. Wysocki wrote:

> > I thought of one more thing you might want to add: device_pm_add() 
> > doesn't handle the case where dev->parent is NULL.
> 
> I'm not sure what you mean.
> 
> If dev->parent is NULL, we get into the "successful" branch where the device is
> added to dpm_active.  Do you think we should add any extra handling of this
> case?

If a device is registered after dpm_suspend() has returned, the
device won't be suspended properly before the system goes to sleep.  

If the device has a parent then you're okay, because the parent must
already be suspended and so device_pm_add() will fail.  But if the
device doesn't have a parent then device_pm_add() will succeed, which
you don't want.

> > You could put in that static "all_devices_sleeping" flag, which gets set at
> > the end of dpm_suspend() and cleared at the start of dpm_resume().
> 
> Well, I don't think it's necessary.  dpm_active is empty in that case and
> we can use the list_empty(&dpm_active) check instead.

What would happen the very first time the system registers a device 
during startup?

Alan Stern


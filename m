Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbYCFUUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbYCFUUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760714AbYCFUUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:20:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38167 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760478AbYCFUUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:20:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations concurrent with suspend/hibernation
Date: Thu, 6 Mar 2008 21:18:32 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803061233460.7892-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803061233460.7892-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803062118.32860.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 6 of March 2008, Alan Stern wrote:
> On Thu, 6 Mar 2008, Rafael J. Wysocki wrote:
> 
> > > I thought of one more thing you might want to add: device_pm_add() 
> > > doesn't handle the case where dev->parent is NULL.
> > 
> > I'm not sure what you mean.
> > 
> > If dev->parent is NULL, we get into the "successful" branch where the device is
> > added to dpm_active.  Do you think we should add any extra handling of this
> > case?
> 
> If a device is registered after dpm_suspend() has returned, the
> device won't be suspended properly before the system goes to sleep.  
> 
> If the device has a parent then you're okay, because the parent must
> already be suspended and so device_pm_add() will fail.  But if the
> device doesn't have a parent then device_pm_add() will succeed, which
> you don't want.

Well, can it happen in practice?  If it can, then what way can it happen?

> > > You could put in that static "all_devices_sleeping" flag, which gets set at
> > > the end of dpm_suspend() and cleared at the start of dpm_resume().
> > 
> > Well, I don't think it's necessary.  dpm_active is empty in that case and
> > we can use the list_empty(&dpm_active) check instead.
> 
> What would happen the very first time the system registers a device 
> during startup?

For any other uses than in device_pm_add(), the list_empty(&dpm_active) test
should be sufficient, IMHO.

It seems to me that we're discussing purely academic stuff here.  If it turns
out to be of any practical relevance, it will be trivial to add the handling of
it in the future.

Thanks,
Rafael

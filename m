Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbYCFP1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbYCFP1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbYCFP1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:27:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46107 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752232AbYCFP07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:26:59 -0500
Date: Thu, 6 Mar 2008 10:26:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations
 concurrent with suspend/hibernation
In-Reply-To: <200803060024.28850.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803061022150.4061-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Rafael J. Wysocki wrote:

> > > Revised patch below.
> > 
> > It looks good.  Let's hope it doesn't mess up ACPI too badly...  :-)
> > 
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Thanks!

I thought of one more thing you might want to add: device_pm_add() 
doesn't handle the case where dev->parent is NULL.  You could put in 
that static "all_devices_sleeping" flag, which gets set at the end of 
dpm_suspend() and cleared at the start of dpm_resume().

> Okay, I also have the appended patch on top of this one. :-)
> 
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Include dpm_sysfs_add() into device_pm_add(), in analogy with
> device_pm_remove(), and modify device_add() to call the latter after
> bus_add_device(), to avoid situations in which the PM core may
> attempt to suspend a device the registration of which has not been
> successful.

Clean and simple.  Ack.

Alan Stern


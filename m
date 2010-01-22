Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909Ab0AVDCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0AVDCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 22:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302Ab0AVDC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 22:02:29 -0500
Received: from netrider.rowland.org ([192.131.102.5]:60861 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752262Ab0AVDC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 22:02:29 -0500
Date: Thu, 21 Jan 2010 22:02:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] PM / Runtime: Add sysfs switch for disabling device
 run-time PM (rev. 2)
In-Reply-To: <201001212359.38886.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001212157500.29627-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add new device sysfs attribute, power/control, allowing the user
> space to block the run-time power management of devices.  If this
> attribute is set to "on", the driver of the device won't be able to power
> manage it at run time (without breaking the rules) and the device will
> always be in the full power state (except when the entire system goes
> into a sleep state).

...

> --- linux-2.6.orig/drivers/base/power/power.h
> +++ linux-2.6/drivers/base/power/power.h
> @@ -2,11 +2,15 @@
>  
>  extern void pm_runtime_init(struct device *dev);
>  extern void pm_runtime_remove(struct device *dev);
> +extern void pm_runtime_allow(struct device *dev);
> +extern void pm_runtime_forbid(struct device *dev);

Can you write a follow-up patch that moves these declarations to a
public header file like include/linux/pm_runtime.h and EXPORTs the two
new routines?  It is sometimes useful for drivers to be able to call
the routines directly.

For example, we disable runtime PM for most USB devices by default.  
But a few drivers may know that their devices are able to handle it, so 
they want to change the default setting when they are bound.

Alan Stern


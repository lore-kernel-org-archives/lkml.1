Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab0BEPTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 10:19:21 -0500
Received: from netrider.rowland.org ([192.131.102.5]:39910 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932309Ab0BEPTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 10:19:19 -0500
Date: Fri, 5 Feb 2010 10:19:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] PM / Runtime: Add sysfs switch for disabling device
 run-time PM (rev. 2)
In-Reply-To: <20100205062718.GA1384@ucw.cz>
Message-ID: <Pine.LNX.4.44L0.1002051014020.22829-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010, Pavel Machek wrote:

> 
> > > > + *	The default for all devices is "auto", which means that devices may be
> > > > + *	subject to automatic power management, depending on their drivers.
> > > 
> > > Is it wise to specify 'auto' default value for devices without runtime
> > > pm?
> > 
> > Yes, it is.  It means the user space doesn't care whether or not the device is
> > power managed at run-time.
> 
> Well, defaulting to 'on' for drivers when runtime pm is experimental
> seems logical. and there will be such drivers...

It's really not very important what the default setting is.  Runtime PM
is always initially disabled, regardless of the "auto"/"on" setting,
until the driver explicitly enables it.  At that time the driver also
has the option of changing the setting from "auto" to "on".

So if a driver writer wants to support runtime PM but thinks that his
implementation (or the device!) may be buggy, he can easily arrange
things so the user has to change the sysfs setting to make anything
happen.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0CFVFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 16:05:40 -0500
Received: from netrider.rowland.org ([192.131.102.5]:40817 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751449Ab0CFVFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 16:05:38 -0500
Date: Sat, 6 Mar 2010 16:05:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       <linux-input@vger.kernel.org>, <linux-hotplug@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with remote-wakeup settings
In-Reply-To: <201003062154.02199.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1003061601520.23895-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Mar 2010, Rafael J. Wysocki wrote:

> > It's not difficult in theory to tie together the WoL setting and the
> > wakeup flag:
> > 
> > 	If ethtool changes the WoL setting, the driver's ioctl handler
> > 	should make the corresponding change to the wakeup flag.
> > 
> > 	If ethtool queries the WoL setting, the ioctl handler should
> > 	check the wakeup flag.  If the flag is off, it should report 
> > 	that WoL is disabled; if the flag is on, it should report that 
> > 	WoL is enabled.  (The same check should be made in the suspend
> > 	routine.)
> 
> That's done this way already in all drivers I know, but we need a hook
> from wake_store() back to the driver.

What for?  wake_store() can't be called during a sleep transition
(because tasks are frozen) or while the system is asleep.  And if it is
called at any other time, the driver doesn't need to know until either
its ioctl handler or its suspend method runs.

Alan Stern


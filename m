Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0CFVWj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 16:22:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab0CFVWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 16:22:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problems with remote-wakeup settings
Date: Sat, 6 Mar 2010 22:25:09 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       linux-input@vger.kernel.org, linux-hotplug@vger.kernel.org,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
References: <Pine.LNX.4.44L0.1003061601520.23895-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003061601520.23895-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003062225.09514.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 March 2010, Alan Stern wrote:
> On Sat, 6 Mar 2010, Rafael J. Wysocki wrote:
> 
> > > It's not difficult in theory to tie together the WoL setting and the
> > > wakeup flag:
> > > 
> > > 	If ethtool changes the WoL setting, the driver's ioctl handler
> > > 	should make the corresponding change to the wakeup flag.
> > > 
> > > 	If ethtool queries the WoL setting, the ioctl handler should
> > > 	check the wakeup flag.  If the flag is off, it should report 
> > > 	that WoL is disabled; if the flag is on, it should report that 
> > > 	WoL is enabled.  (The same check should be made in the suspend
> > > 	routine.)
> > 
> > That's done this way already in all drivers I know, but we need a hook
> > from wake_store() back to the driver.
> 
> What for?  wake_store() can't be called during a sleep transition
> (because tasks are frozen) or while the system is asleep.  And if it is
> called at any other time, the driver doesn't need to know until either
> its ioctl handler or its suspend method runs.

Right.

That means, though, that the network adapter drivers' "get WoL" routines
should check should_wakeup too.  They don't do that right now, but IMO it's
reasonable to request that they be modified.

Adding netdev to the Cc list.

Rafael

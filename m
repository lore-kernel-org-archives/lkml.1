Return-Path: <linux-kernel-owner+w=401wt.eu-S1761150AbZFJVP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761150AbZFJVP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbZFJVPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:15:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882AbZFJVPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:15:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Wed, 10 Jun 2009 23:15:26 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906101636180.2589-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906101636180.2589-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906102315.26999.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 June 2009, Alan Stern wrote:
> On Wed, 10 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > By the way, a legitimate reason for aborting an autosuspend is if the
> > > device's driver requires remote wakeup to be enabled during suspend but
> > > the user has disabled it.
> > 
> > Do you mean the user has disabled the remote wakeup?
> 
> Yes, by writing to the power/wakeup attribute.
> 
> 
> > > > > There should be a sysfs interface (like the one in USB) to allow
> > > > > userspace to prevent a device from being autosuspended -- and perhaps
> > > > > also to force it to be suspended.
> > > > 
> > > > To prevent a device from being suspended - yes.  To force it to stay suspended
> > > > - I'm not sure.
> > > 
> > > I'm not sure either.  Oliver Neukum requested it originally and it has
> > > been useful for debugging, but I haven't seen many places where it
> > > would come in useful in practice.
> 
> I did think of one use for this feature.  It's unique to USB,
> however...
> 
> In Windows, you're not supposed to unplug a hot-unpluggable device
> without first telling the OS -- there's a "Safely Remove Hardware"  
> applet.  When you tell the applet you want to remove a USB device, the
> system disables the device's port and then says it's okay to unplug the
> device.  Now Linux doesn't have any user API for disabling USB ports,
> but suspending a port has the same effect (the device can't distinguish
> a disable from a suspend).
> 
> It turns out that some devices (MP3 players, for instance) have
> incorporated this into their design.  They display a "Safe to unplug"  
> message when their port is disabled or suspended.  People like to see
> this message -- it makes them feel good about unplugging the device --
> and the only way to get it under Linux is by forcing the device to be
> suspended.  :-)

Well, I'd very much prefer to have a separate mechanism for that.

> > The problem with it is that the user space may not know if it is safe to keep
> > a device suspended and if it is not, the kernel will have to ignore the setting
> > anyway, so I'm not sure what's the point (except for debugging).
> 
> This falls into the category of "The user knows better".  If the user
> specifically tells the kernel to suspend a device (rather than just
> letting it autosuspend), and this causes a problem, then it's the
> user's own fault.
> 
> After all, who's really the master?  Us or the kernel?

Oh, that depends on who the user is.  If I'm the user, I'm the master, but in
case of a typical Windows user I'm afraid the kernel has to know better. ;-)

Best,
Rafael

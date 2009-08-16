Return-Path: <linux-kernel-owner+w=401wt.eu-S1752020AbZHPQJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbZHPQJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 12:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZHPQJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 12:09:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34689 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751201AbZHPQJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 12:09:11 -0400
Date: Sun, 16 Aug 2009 12:09:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, <linux-usb@vger.kernel.org>,
       <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
In-Reply-To: <200908152344.46898.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908161158210.6522-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Aug 2009, Rafael J. Wysocki wrote:

> On Saturday 15 August 2009, Matthew Garrett wrote:
> > On Sat, Aug 15, 2009 at 11:21:53PM +0200, Rafael J. Wysocki wrote:
> > 
> > > I can even imagine a scenario where this setting might be useful, like when
> > > we don't want a network adapter to be woken up from the outside.
> > 
> > I think in that case we'd probably just want the interface to be downed? 
> > Some of this is going to require device-specific policy, I think - for 
> > the network case we probably want something in between IF_RUNNING and 
> > IF_DOWN (IF_CARRIER, perhaps) that indicates that we want the PHY to be 
> > powered. Pushing this out to sysfs would mean we'd have a consistent 
> > interface but varying semantics, and I'm not convinced that's an 
> > especially helpful interface.
> 
> I'm not disagreeing with that.
> 
> At this point I'd like to know the Alan's opinion.  I would gladly use the
> 'runtime_forbidden' flag only, but if we overlook something now, it's going
> to be difficult to fix later.

The notion of "remote wakeup" is more or less the same for all devices,
and it can effectively be abstracted into the core.  Other notions,
like IF_CARRIER, are more device-dependent.  They must be handled at
the bus or driver level, not in the core.

The real question is whether we should export a "may_runtime_wakeup"  
flag.  If we don't then we prevent the use of a degraded
power-management mode in devices with broken wakeup support.  Perhaps 
that's okay, I don't know.

Which reminds me...  In addition to these flags controlling what
settings should be enabled, maybe we should add a flag to record
whether or not remote wakeup was turned on when the device was last
suspended.  Although the core wouldn't use it, such a flag might be
very convenient for drivers.

Alan Stern


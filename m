Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYK1VVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYK1VVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 16:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYK1VVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 16:21:25 -0500
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:58154 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYK1VVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 16:21:23 -0500
Date: Fri, 28 Nov 2008 13:21:22 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Matthew Wilcox <matthew@wil.cx>
cc: Alex Chiang <achiang@hp.com>, "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the	device
In-Reply-To: <20081128185722.GU25548@parisc-linux.org>
Message-ID: <Pine.LNX.4.58.0811281310050.30153@shell4.speakeasy.net>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
 <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum>
 <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum>
 <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net>
 <20081126225535.GA27936@ldl.fc.hp.com> <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net>
 <20081127024204.GJ25548@parisc-linux.org> <Pine.LNX.4.58.0811280151230.24816@shell4.speakeasy.net>
 <20081128185722.GU25548@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008, Matthew Wilcox wrote:
> On Fri, Nov 28, 2008 at 02:11:49AM -0800, Trent Piepho wrote:
> > On Wed, 26 Nov 2008, Matthew Wilcox wrote:
> > > Because fakephp was the odd one out.  Every other hotplug driver
> > > registers a slot number and puts the address in the directory.  We're
> > > making hotplug drivers simpler (by sharing more of the logic in the
> > > core) and so fakephp had to change to match the other drivers.  I'm
> > > sorry for your inconvenience, but it's necessary.
> >
> > Seems like changing a long established interface like this should be put on
> > the feature removable schedule.
>
> sysfs is more fluid than other interfaces.  Large parts of it
> change without warning.  I suppose it could have gone through
> feature-removal-schedule, and perhaps we should try to do that in future.

Sometimes I just want to give up on Linux.  Is there a different interface
that isn't wantonly changed without warning?  No?  Do you not see the
problem this creates for developers?  Do you not care?

> > > We can discuss other ways to make your life better, but it can't be
> > > changed back to one 'slot' per PCI function.
> >
> > Why not have a slot per pci function with each hotplug driver adding
> > attributes to the slot?  The slot would be registered by the hotplug core.
>
> What we have now is the 'address' file managed by the core.  This
> doesn't include the function number.

So the race condition doesn't matter?  Alex Chiang wasn't even aware
fakephp could be used to add new devices, so this change obviously wasn't
though out very well.

> > Is there any reason the fakephp driver should not be allowed to enable and
> > disable individual functions?  There a lot of mutli-function devices that
> > allow individual functions to be enabled and disabled with registers on the
> > primary function.  For instance, it would be possible to work around a BIOS
> > that doesn't have an option to disabled a southbridge's USB controller by
> > doing so in Linux and then using fakephp to remove the device, and thus
> > free address space that other devices might need.
>
> There are lots of circumstances where enabling and disabling individual
> functions is a good idea, but I don't think that fakephp is the right
> way to do it.  We need a better interface.

So maybe this better interface should be created before breaking the
existing one?

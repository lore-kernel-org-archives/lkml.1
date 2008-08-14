Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYHNPlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYHNPlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbYHNPkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:40:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58452 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751410AbYHNPk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:40:29 -0400
Date: Thu, 14 Aug 2008 11:40:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@suse.cz>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, <teheo@novell.com>
Subject: Re: [linux-pm] Power management for SCSI
In-Reply-To: <200808140808.27022.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808141134390.2846-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Oliver Neukum wrote:

> > > I dispute that USB in general has this property.
> > 
> > How can you dispute that?  You said it yourself, in the top quote
> > above: "All children that are USB must be powered down."
> 
> But the children are SCSI, not USB.

Oh, I see.  All right, yes.  However USB in general _does_ have the
property that child devices might not be able to accomplish much while
the USB link is suspended, particularly if they are bus-powered.  This 
includes draining caches.

> > Oliver, you can't have it both ways.  Either we do spin down disks and
> > drain device caches before autosuspending usb-storage or we don't.
> 
> That is true.
> 
> > For safety's sake, obviously we should.  The overhead is minimal since
> > this happens only after the idle timeout has expired.  And for devices
> > that don't support it (like flash storage), sd skips the spin-down
> > command anway.
> 
> But you cannot make the conclusion that the ultimate children should have
> any autosuspend attributes. We can implement autosuspend in usb storage
> and propagate the suspend calls down the tree without SCSI knowing about
> autosuspend.

The way I designed the autosuspend framework, you _can't_ do that.  In
my framework autosuspend and autoresume events propagate _up_ the
device tree, not _down_.  This means an autosuspend has to be initiated
by the child SCSI layer, not by the USB layer.  Which is as it should
be, since the USB layer doesn't know when it is appropriate for a SCSI
device to autosuspend.

> Such a system would have it drawbacks, but it'd be a lot simpler.

It would be a layering violation.

Alan Stern


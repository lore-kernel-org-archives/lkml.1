Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbZFKSgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbZFKSgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZFKSg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:36:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57502 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753784AbZFKSg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:36:28 -0400
Date: Thu, 11 Jun 2009 14:36:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re:
 [RFC][PATCH 0/2] PM: Rearrange core suspend code)
In-Reply-To: <200906111805.53388.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0906111433110.4875-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Oliver Neukum wrote:

> Am Donnerstag, 11. Juni 2009 17:22:06 schrieb Alan Stern:
> > > > Okay, I'll agree to that.  It should be made clear that a device which
> > > > is "suspended" according to this definition is not necessarily in a
> > > > low-power state.  For example, before powering down the link to a disk
> > > > drive you might want the drive's suspend method to flush the drive's
> > > > cache, but it wouldn't have to spin the drive down.
> > >
> > > This precludes handling busses that have low power states that are
> > > left automatically. If such links are stacked the management of
> > > acceptable latencies cannot be left to the busses.
> > > An actual example are the link states of USB 3.0
> >
> > I don't understand.  Can you explain more fully?
> 
> I am talking about the U1 and U2 feature of USB 3.0.
> 
> Or abstractly any power saving state that does autoresume in hardware.
> In these cases you know that you can enter a powersaving state that
> will add X latency.
> 
> In terms of user space API we'll probably add a way for user space
> to specify how much latency may be added for power management's sake.
> If busses are stacked the "latency budget" has to be handled at core level.
> If furthermore states that allow IO but with additional latency are ignored,
> the budget will be calculated wrongly.

Okay, fine.  What does this have to do with Rafael's work?  Why does 
setting the status to RPM_SUSPENDED even when a device is not in a 
low-power state preclude handling buses that automatically change their 
power state?

I don't see any connection between Rafael's work and managing
latencies, beyond the obvious fact that a device will have a higher
latency when it is suspended than when it isn't.

Alan Stern


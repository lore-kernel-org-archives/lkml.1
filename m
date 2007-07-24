Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbXGXOuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbXGXOuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763563AbXGXOu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:50:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45465 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757463AbXGXOuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:50:25 -0400
Date: Tue, 24 Jul 2007 10:50:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Huang, Ying" <ying.huang@intel.com>
cc: david@lang.hm, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Milton Miller <miltonm@bga.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       <nigel@nigel.suspend2.net>, Pavel Machek <pavel@ucw.cz>
Subject: RE: [linux-pm] Re: Hibernation considerations
In-Reply-To: <9D7649D18729DE4BB2BD7B494F7FEDC236CF5C@pdsmsx415.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.0707241046060.3568-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Huang, Ying wrote:

> >From: Alan Stern [mailto:stern@rowland.harvard.edu]
> >It can't.  Indeed, in the absence of a freezer, user threads will need
> >devices (more accurately, will submit I/O requests for devices) that
> >have to be kept quiescent or low-power.  Drivers will need to delay
> >those requests until the devices are returned to full operation.
> >
> >That's exactly what I've been saying all along: Drivers will need to
> >be changed to delay I/O requests, if there is no freezer.
> 
> If it is a too big work to implement "delaying I/O requests" for every
> driver, is it possible to implement it as follow:
> 
> 1. It is triggered to suspend to RAM/DISK.
> 2. Replace the driver related syscall entries (such as sys_read,
> sys_write, sys_ioctl, etc) in sys_call_table with special wrapper
> entries provided by "suspend to RAM/DISK" subsystem, which will delay
> I/O requests if appropriate.
> 3. When devices are quiesced, they are put into "low power" state and
> system is put into suspend state; or the image is written to disk
> (through snapshot/uswsusp or kexeced kernel).
> 4. After resuming from RAM/DISK, devices are put into "normal" state and
> the syscall entries replaced in step 2 are restored.

Ha!  I made exactly this same suggestion (URL lost in the mists of 
time), except that I proposed changing the syscall entries for every 
system call, not just the driver-related ones.

Nobody seemed to think it would work very well.

It leaves a few loose ends.  For example, suppose a user thread is 
already in the middle of a system call and is about to start doing some 
I/O (maybe it's waiting for a timer to expire).

In the end, this doesn't seem to be very different from freezing all 
user threads.

Alan Stern


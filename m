Return-Path: <linux-kernel-owner+w=401wt.eu-S933860AbZLOWBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbZLOWBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933875AbZLOWB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:01:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:32881 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933852AbZLOWBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:01:23 -0500
Date: Tue, 15 Dec 2009 17:01:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912152226.22578.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912151653140.2643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, Rafael J. Wysocki wrote:

> > Ideally we would figure out how to do the slow devices in parallel
> > without interference from fast devices having unknown dependencies.  
> > Unfortunately this may not be possible.
> 
> I really expect to see those "unknown dependencies" in the _noirq
> suspend/resume phases and above.  [The very fact they exist is worrisome,
> because that's why we don't know why things work on one system and don't
> work on another, although they appear to be very similar.]

This is a good reason for keeping the _noirq phases synchronous.  AFAIK 
they don't take long enough to be worth converting, so there's no loss.

> > The real issue is "blockage": synchronous devices preventing 
> > possible concurrency among async devices.  That's what you thought 
> > making PCI bridges async would help.
> > 
> > In general, blockage arises in suspend when you have an async child
> > with a synchronous parent.  The parent has to wait for the child, which
> > might take a long time, thereby delaying other unrelated devices.
> 
> Exactly, but the Linus' point seems to be that's going to be rare and we
> should be able to special case all of the interesting cases.

Maybe that's true.  Without seeing some examples of actual dpm_list
contents, we can't tell.  Can you post the interesting parts of the
lists from some of your test machines?  Maybe with a USB device or two
plugged in?  (The device names together with the names of their parents
should be enough.)

> > (This explains why you wanted to make PCI bridges async -- they are the
> > parents of USB controllers.)  For resume it's the opposite: an async
> > parent with synchronous children.
> 
> Is that really going to happen in practice?  I mean, what would be the point?

I don't know.  It's all speculation until we see some actual lists.

Alan Stern


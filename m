Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYBZP6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYBZP6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbYBZP6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:58:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41835 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750728AbYBZP6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:58:32 -0500
Date: Tue, 26 Feb 2008 10:58:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Newall <davidn@davidnewall.com>
cc: David Brownell <david-b@pacbell.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <47C415F2.2060905@davidnewall.com>
Message-ID: <Pine.LNX.4.44L0.0802261055230.4176-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, David Newall wrote:

> David Brownell wrote:
> > On Tuesday 26 February 2008, David Newall wrote:
> >   
> >> Hardware can be inserted and removed while we're in a suspend state; and
> >> there's nothing that we can do about it until we resume.  Is it fair to
> >> say, then, that having started suspend, we could reasonably ignore any
> >> device insertion and removal, and handle it on resume?
> >>     
> >
> > "Ignore" seems a bit strong; those events may be wakeup triggers,
> > which would cause the hardware to make it a very short suspend state.
> >
> > "Defer handling" is more to the point, be it by hardware or software.
> >
> >   
> 
> Of course, "defer".  The insertion has to be handled eventually.  What
> I'm wondering is if we can ignore it, and catch it on the resume.

Certainly.  If hardware-change events can get lost because of the
system sleep, the resume method should make every effort to verify that 
what it remembers of the hardware state matches the current reality.

> >> Presumably we need to scan for hardware changes on resume.
> >>     
> >
> > Not on most busses I work with; the hardware issues notifications
> > whenever the devices are removable.
> >   
> 
> There's no notification while we're suspended.  Isn't it necessary to
> scan all busses on resume, just to know what's on them?

It depends on the bus.  If the bus doesn't support hotplugging then 
scanning isn't necessary.  If the bus does support hotplugging then 
scanning after suspend may or may not be necessary, depending on 
whether or not the bus controller remained powered during the suspend.  
For hotpluggable buses, scanning after hibernation is always necessary.

Alan Stern


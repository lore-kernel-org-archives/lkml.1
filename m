Return-Path: <linux-kernel-owner+w=401wt.eu-S936705AbXGTWHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936705AbXGTWHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765107AbXGTWH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:07:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762937AbXGTWH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:07:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Sat, 21 Jul 2007 00:15:30 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, Milton Miller <miltonm@bga.com>,
       Ying Huang <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <Pine.LNX.4.44L0.0707201722060.5241-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0707201428080.5166@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707201428080.5166@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210015.31152.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 July 2007 23:34, david@lang.hm wrote:
> On Fri, 20 Jul 2007, Alan Stern wrote:
> 
> > On Fri, 20 Jul 2007 david@lang.hm wrote:
> >
> >>> Userspace can submit I/O requests.  Someone will have to audit every
> >>> driver to make sure that such I/O requests don't cause a quiesced
> >>> device to become active.  If the device is active, it will make the
> >>> memory snapshot inconsistent with the on-device data.
> >>
> >> assuming this is the suspend-from-ram after a kexec back from the
> >> write-to-disk kernel I don't think you are correct.
> >>
> >> when doing a suspend-to-ram you get to a point where you just don't use
> >> any userspace.
> >
> > What do you mean?  How can you prevent user tasks from running?  That's
> > basically what the freezer does, and the whole point of this approach
> > is to eliminate the freezer.  Right?
> >
> >> from that point on you are just walking the device tree
> >> putting things into low-power mode. This is the point where we are talking
> >> about jumping to.
> >
> > Yes.  And putting things into low-power mode requires the ability to
> > run the scheduler, which means that user tasks can be scheduled, which
> > means that they can run.
> 
> I did not know that getting into low-power mode required scheduling.
> 
> does it require userspace?
> 
> if so this is a problem and I say punt on suspend-to-disk-and-ram until 
> suspend-to-ram is working independantly ;-)
> 
> if not, then can you schedule but not consider non-kernel tasks runnable?
> 
> freezing all of userspace is easy (see above)
> 
> freezing all of kernelspace is easy (unplug all non-boot CPU's and don't 
> schedule)
> 
> where freezing gets hard is when you need to partially freeze either one 
> of these.

If you use the scheduler to "freeze" tasks, you never know where they are
stopped and what locks they may hold.

We would have done that already if that was so easy, because we really want
to freeze _all_ user space tasks (even if not all kernel threads).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

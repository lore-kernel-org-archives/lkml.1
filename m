Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbXGTWfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbXGTWfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937748AbXGTWfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:35:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53671 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S937485AbXGTWfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:35:19 -0400
Date: Fri, 20 Jul 2007 18:35:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
cc: david@lang.hm, Milton Miller <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <877ioupxi8.fsf@jbms.ath.cx>
Message-ID: <Pine.LNX.4.44L0.0707201830470.5241-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Jeremy Maitin-Shepard wrote:

> >> when doing a suspend-to-ram you get to a point where you just don't use 
> >> any userspace.
> 
> > What do you mean?  How can you prevent user tasks from running?  That's 
> > basically what the freezer does, and the whole point of this approach 
> > is to eliminate the freezer.  Right?
> 
> Presumably no tasks at all would be scheduled.

How would you prevent tasks from being scheduled?  How would you
prevent drivers from deadlocking because in order to put their device
in a low-power state they need to acquire a lock which is held by a
user task?

> >> from that point on you are just walking the device tree 
> >> putting things into low-power mode. This is the point where we are talking 
> >> about jumping to.
> 
> > Yes.  And putting things into low-power mode requires the ability to 
> > run the scheduler, which means that user tasks can be scheduled, which 
> > means that they can run.
> 
> Does it really (fundamentally) require scheduling tasks, particularly in
> the case that the devices have already been put in the "quiesced" state?

I can't say for sure.  That's the way we have been doing it.  It
wouldn't be easy to change, because the driver would have to busy-wait
during delays -- which would mean it would need to use different code
for system-wide suspend and runtime suspend.

Alan Stern


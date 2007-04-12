Return-Path: <linux-kernel-owner+w=401wt.eu-S2992550AbXDLNcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992550AbXDLNcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 09:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992551AbXDLNcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 09:32:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60630 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992550AbXDLNcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 09:32:01 -0400
Date: Thu, 12 Apr 2007 15:31:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Buytaert_Steven@emc.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: sched_yield proposals/rationale
Message-ID: <20070412133158.GB31455@one.firstfloor.org>
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com> <p737ish90ss.fsf@bingen.suse.de> <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 09:05:25AM -0400, Buytaert_Steven@emc.com wrote:
> > -----Original Message-----
> > From: Andi Kleen
> > [ ... about use of sched_yield ...]
> > On the other hand when they fix their code to not rely on sched_yield
> > but use [...]
> 
> Agreed, but $ find . -name "*.[ch]" | xargs grep -E "yield[ ]*\(" | wc over
> the 2.6.16 kernel yields 105 hits, note including comments... An interesting spot is e.g. fs/buffer.c free_more_memory()

A lot of those are probably broken in some way agreed.

> > 
> > > 2) When a task is eventually put in the expired list in sched_yield,
> > > give it back the full time slices round (as done in scheduler_tick), not > > with the remaining slices as is done now?
> > 
> > That would likely be unfair and exploitable.
> 
> I don't understand; how more unfair would it be than passing via scheduler_tick? Grabbing a resource with a single time slice left would be more unfair towards other tasks IMHO when you get moved to the expired list with the resource in still in your possession.

With a particular sleep pattern it could get more CPU time.

> > > 3) Put the task in the expired list at a random position, not at the end
> > > is done now?
> > 
> > Sounds like an interesting approach, but to do it in O(1) you would
> > need a new data structure with possibly much larger constant overhead.
> 
> Agreed, but not dramatic. Suppose you need to insert at position X, you would do, on the linked list after proper setup:
> 
> while (X--) { prev = current; current = current->next }
> 
> You could have a small duffs device to reduce the X-- checking overhead.

You would need to rename the scheduler to "sometimes O(1)" first @)

Besides - but I guess you're aware of it - any randomized algorithms tend
to drive benchmarkers and performance analysts crazy because their performance
cannot be repeated. So it's usually better to avoid them unless there is 
really no alternative.

-Andi

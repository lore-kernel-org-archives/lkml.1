Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbYDQNzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbYDQNzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 09:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYDQNy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 09:54:56 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28338 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbYDQNyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 09:54:55 -0400
Date: Thu, 17 Apr 2008 15:54:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: Fabio Checconi <fchecconi@gmail.com>,
       Paolo Valente <paolo.valente@unimore.it>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080417135448.GF12774@kernel.dk>
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <48072549.7040104@cse.unsw.edu.au> <20080417111407.GS62286@gandalf.sssup.it> <48073F15.7070502@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48073F15.7070502@cse.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17 2008, Aaron Carroll wrote:
> Fabio Checconi wrote:
> >>From: Aaron Carroll <aaronc@cse.unsw.edu.au>
> >>How do you figure that?  This is a situation where time-slices work 
> >>nicely,
> >>because they implicitly account for the performance penalty of poor access
> >>patterns.  The sequential-accessing processes (and the system overall) 
> >>ends
> >>up with higher throughput.
> >>
> >
> >The unfairness is not WRT tasks generating poor access patterns.
> >If you have two tasks doing sequential accesses on two different
> >regions of the disk the exact amount of service they receive in the
> >same amount of time depends on the transfer rate of the disk on
> >that regions, and, depending on the media, it is not always the same.
> 
> Ok... you're talking about ZBR.
> 
> I'm not convinced this should be treated differently to, say, random vs.
> sequential workloads.  You still end up with reduced global throughput as
> you've shown in the ``Short-term time guarantees'' table.  It is an
> interesting case though... since the lower performance is not though fault
> of the process it doesn't seem fair to ``punish'' it.

It is indeed a valid observation, but I think we are getting into
details still. CFQ wants to provide fair access to the drive, it doesn't
claim to be 100% fair wrt throughput or transfer sums at all costs. This
is where fairness and real life for an all round scheduler divert
somewhat.

So while it IS true that you could have 40mb/sec at one end and 65mb/sec
at the other and thus give the process at the start an 'unfair' share of
bandwidth, it's honestly mostly a theoretical problem. I can envision
some valid concerns for media streaming filling the entire drive, but
then my solution would be to just bump the time slice if you are not
meeting deadlines. I've never heard anyone complain about this issue.

-- 
Jens Axboe


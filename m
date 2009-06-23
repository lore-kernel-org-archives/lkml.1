Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZFWFQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZFWFQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbZFWFQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:16:38 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:34612 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbZFWFQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:16:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19008.25905.550815.222975@drongo.ozlabs.ibm.com>
Date: Tue, 23 Jun 2009 15:16:33 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: eranian@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.2 - Grouping
In-Reply-To: <20090622115017.GC24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	<20090622115017.GC24366@elte.hu>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> > 2/ Grouping
> >
> > By design, an event can only be part of one group at a time.

To clarify this statement of Stephane's, a _counter_ can only be in
one group.  You can have multiple counters counting the same _event_
and those counters can (obviously) be in different groups.

> > Events in a group are guaranteed to be active on the PMU at the
> > same time. That means a group cannot have more events than there
> > are available counters on the PMU. Tools may want to know the
> > number of counters available in order to group their events
> > accordingly, such that reliable ratios could be computed. It seems
> > the only way to know this is by trial and error. This is not
> > practical.
> 
> Groups are there to support heavily constrained PMUs, and for them
> this is the only way, as there is no simple linear expression for
> how many counters one can load on the PMU.

That's not the only reason for having groups, or even the main reason
IMO.  The main reason for having groups is to provide a way to ask the
scheduler to ensure that two or more counters are always scheduled
together, so that you can meaningfully do arithmetic operations on the
counter values that would be sensitive to the statistical noise
introduced by the scheduling, such as ratios and differences.

In other words, grouping is there because we don't guarantee to have
all counters scheduled onto the PMU whenever possible.  Heavily
constrained PMUs increase the need for scheduling, but even if
counters are completely orthogonal there are only a fixed number of
them so we still need to schedule counters at some point.

Paul.

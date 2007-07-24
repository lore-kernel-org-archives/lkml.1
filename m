Return-Path: <linux-kernel-owner+w=401wt.eu-S1762371AbXGXXOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762371AbXGXXOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbXGXXOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:14:17 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:46209
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762070AbXGXXOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:14:15 -0400
Date: Tue, 24 Jul 2007 16:14:00 -0700
To: Chris Snook <csnook@redhat.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Tong Li <tong.n.li@intel.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
Message-ID: <20070724231400.GA18307@gnuppy.monkey.org>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <46A53C88.6060006@redhat.com> <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com> <46A64002.8080103@redhat.com> <46A6576A.9020506@nortel.com> <46A66393.5000705@redhat.com> <20070724210607.GB32582@gnuppy.monkey.org> <46A66DA7.2020700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A66DA7.2020700@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 05:22:47PM -0400, Chris Snook wrote:
> Bill Huey (hui) wrote:
> Well, you need enough CPU time to meet your deadlines.  You need 
> pre-allocated memory, or to be able to guarantee that you can allocate 
> memory fast enough to meet your deadlines.  This principle extends to any 
> other shared resource, such as disk or network.  I'm being vague because 
> it's open-ended.  If a medical device fails to meet realtime guarantees 
> because the battery fails, the patient's family isn't going to care how 
> correct the software is.  Realtime engineering is hard.
...
> Actually, it's worse than merely an open problem.  A clairvoyant fair 
> scheduler with perfect future knowledge can underperform a heuristic fair 
> scheduler, because the heuristic scheduler can guess the future incorrectly 
> resulting in unfair but higher-throughput behavior.  This is a perfect 
> example of why we only try to be as fair as is beneficial.

I'm glad we agree on the above points. :)

It might be that there needs to be another more stiff policy than what goes
into SCHED_OTHER in that we also need a SCHED_ISO or something has more
strict rebalancing semantics for -rt applications, sort be a super SCHED_RR.
That's definitely needed and I don't see how the current CFS implementation
can deal with this properly even with numerical running averages, etc...
at this time.

SCHED_FIFO is another issue, but this actually more complicated than just
per cpu run queues in that a global priority analysis. I don't see how
CFS can deal with SCHED_FIFO efficiently without moving to a single run
queue. This is kind of a complicated problem with a significant set of
trade off to take into account (cpu binding, etc..)

>> Tong's previous trio patch is an attempt at resolving this using a generic
>> grouping mechanism and some constructive discussion should come of it.
>
> Sure, but it seems to me to be largely orthogonal to this patch.

It's based on the same kinds of ideas that he's been experimenting with in
Trio. I can't name a single other engineer that's posted to lkml recently
that has quite the depth of experience in this area than him. It would be
nice to facilitted/incorporate some his ideas or get him to and work on
something to this end that's suitable for inclusion in some tree some where.

bill


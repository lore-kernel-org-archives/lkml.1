Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXGXVXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXGXVXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbXGXVXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:23:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbXGXVXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:23:36 -0400
Message-ID: <46A66DA7.2020700@redhat.com>
Date: Tue, 24 Jul 2007 17:22:47 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Bill Huey (hui)" <billh@gnuppy.monkey.org>
CC: Chris Friesen <cfriesen@nortel.com>, Tong Li <tong.n.li@intel.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <46A53C88.6060006@redhat.com> <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com> <46A64002.8080103@redhat.com> <46A6576A.9020506@nortel.com> <46A66393.5000705@redhat.com> <20070724210607.GB32582@gnuppy.monkey.org>
In-Reply-To: <20070724210607.GB32582@gnuppy.monkey.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Huey (hui) wrote:
> On Tue, Jul 24, 2007 at 04:39:47PM -0400, Chris Snook wrote:
>> Chris Friesen wrote:
>>> We currently use CKRM on an SMP machine, but the only way we can get away 
>>> with it is because our main app is affined to one cpu and just about 
>>> everything else is affined to the other.
>> If you're not explicitly allocating resources, you're just low-latency, not 
>> truly realtime.  Realtime requires guaranteed resources, so messing with 
>> affinities is a necessary evil.
> 
> You've mentioned this twice in this thread. If you're going to talk about this
> you should characterize this more specifically because resource allocation is
> a rather incomplete area in the Linux.

Well, you need enough CPU time to meet your deadlines.  You need pre-allocated 
memory, or to be able to guarantee that you can allocate memory fast enough to 
meet your deadlines.  This principle extends to any other shared resource, such 
as disk or network.  I'm being vague because it's open-ended.  If a medical 
device fails to meet realtime guarantees because the battery fails, the 
patient's family isn't going to care how correct the software is.  Realtime 
engineering is hard.

> Rebalancing is still an open research
> problem the last time I looked.

Actually, it's worse than merely an open problem.  A clairvoyant fair scheduler 
with perfect future knowledge can underperform a heuristic fair scheduler, 
because the heuristic scheduler can guess the future incorrectly resulting in 
unfair but higher-throughput behavior.  This is a perfect example of why we only 
try to be as fair as is beneficial.

> Tong's previous trio patch is an attempt at resolving this using a generic
> grouping mechanism and some constructive discussion should come of it.

Sure, but it seems to me to be largely orthogonal to this patch.

	-- Chris

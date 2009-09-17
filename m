Return-Path: <linux-kernel-owner+w=401wt.eu-S1751761AbZIQOYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbZIQOYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 10:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZIQOYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 10:24:44 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:25626 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZIQOYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 10:24:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACTjsUqrR7MV/2dsb2JhbADGSYhOAZA6BYQY
X-IronPort-AV: E=Sophos;i="4.44,403,1249257600"; 
   d="scan'208";a="390667384"
From: Roland Dreier <rdreier@cisco.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 17 Sep 2009 07:24:45 -0700
In-Reply-To: <1253187028.8439.2.camel@twins> (Peter Zijlstra's message of
	"Thu, 17 Sep 2009 13:30:28 +0200")
Message-ID: <adafxalejiq.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Sep 2009 14:24:45.0991 (UTC) FILETIME=[9B1A6B70:01CA37A2]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Anton Blanchard suggested a while back that this might be integrated
 > with perf-counters, since perf-counters already does mmap() tracking and
 > also provides events through an mmap()'ed buffer.
 > 
 > Has anybody looked into this?

I didn't see the original suggestion.  Certainly hooking in to existing
infrastructure for user/kernel communication would be good.

The fit doesn't seem great to me, although I am rather naive about perf
counters.  The problem that ummunotify is trying to solve is to let an
app say 'for these 1000 address ranges (that possibly only cover a small
part of my total address space), please let me know when the mappings
are invalidated for any reason'.

So getting those events in the kernel is no problem -- we have the MMU
notifier hooks that tell us exactly what we need to know.  The issue is
purely the way userspace registers interest in address ranges, and how
to kernel returns the events.

For perf counters it seems that one would have to create a new counter
for each address range... is that correct?  And also I don't know if
perf counter has an analog for the fast path optimization that
ummunotify provides via a mmap'ed generation counter (a quick way for
userspace to see 'nothing happened since last time you checked').

 - R.

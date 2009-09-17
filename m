Return-Path: <linux-kernel-owner+w=401wt.eu-S1751496AbZIQOcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbZIQOcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 10:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZIQOcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 10:32:53 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:60496 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZIQOcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 10:32:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPPlsUqrR7PD/2dsb2JhbADGXIhOAZA7BYQY
X-IronPort-AV: E=Sophos;i="4.44,404,1249257600"; 
   d="scan'208";a="95020547"
From: Roland Dreier <rdreier@cisco.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	<adafxalejiq.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 17 Sep 2009 07:32:47 -0700
In-Reply-To: <adafxalejiq.fsf@cisco.com> (Roland Dreier's message of "Thu, 17
	Sep 2009 07:24:45 -0700")
Message-ID: <adaab0tej5c.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Sep 2009 14:32:48.0029 (UTC) FILETIME=[BA6B94D0:01CA37A3]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > So getting those events in the kernel is no problem -- we have the MMU
 > notifier hooks that tell us exactly what we need to know.  The issue is
 > purely the way userspace registers interest in address ranges, and how
 > to kernel returns the events.
 > 
 > For perf counters it seems that one would have to create a new counter
 > for each address range... is that correct?  And also I don't know if
 > perf counter has an analog for the fast path optimization that
 > ummunotify provides via a mmap'ed generation counter (a quick way for
 > userspace to see 'nothing happened since last time you checked').

Oh I forgot... ummunotify also preallocates everything etc. so that
there is no way for events to be lost.  Which saves userspace from
having to trash everything cached and start over, which it would have to
do if it misses an invalidate event.

And AFAIK, pref counters does have the possibility of overflowing a
buffer and losing an event, right?

 - R.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039Ab0AJWHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0AJWHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834Ab0AJWHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:07:24 -0500
Received: from ozlabs.org ([203.10.76.45]:43138 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab0AJWHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:07:24 -0500
Date: Mon, 11 Jan 2010 09:04:40 +1100
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 6/6] perf: Increase round-robin fairness of flexible
 events
Message-ID: <20100110220440.GA4595@brick.ozlabs.ibm.com>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
 <1263087500-14215-7-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263087500-14215-7-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

Nice to see someone working on the event scheduling in perf.

But I don't think this patch makes sense:

> Group of flexible events are round-robined in each tick so that
> each group has its chance to be scheduled. But the fairness
> per group granularity doesn't propagate inside the groups
> themselves.
> 
> If only the first events of each groups have a chance to make
> their way, the remaining ones will never be scheduled.
> 
> Hence this patch propagates the round-robin to the events
> inside the groups.

The semantic of a group is that either all of the events in the group
are scheduled in, or none of them are.  So it doesn't make sense to
talk about fairness within a group, and I don't see any point to
rotating the elements of the sibling_list.  Or have I misunderstood
what you're aiming at?

Paul.

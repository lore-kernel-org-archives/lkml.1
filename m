Return-Path: <linux-kernel-owner+w=401wt.eu-S1751300AbZKJFN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbZKJFN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZKJFN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:13:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZKJFN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:13:27 -0500
Date: Tue, 10 Nov 2009 06:13:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/4] perf/core: Small event scheduling changes
Message-ID: <20091110051321.GE7897@elte.hu>
References: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> This is an rfc patchset, only compile tested just to ensure I'm taking 
> a good direction before going ahead.
> 
> This is intended to rework a bit the perf event scheduling to 
> guarantee a real priority of the pinned events over the volatile ones. 
> This patchset handles such priority on task tick time only. But if the 
> idea is agreed, I could expand that to every task event sched-in calls 
> to guarantee the priority in every event rescheduling time.
> 
> Thanks.
> 
> Frederic Weisbecker (4):
>   perf/core: split context's event group list into pinned and
>     non-pinned lists
>   perf/core: Optimize a bit rotate_ctx()
>   perf/core: Split up pinned and non pinned processing
>   perf/core: Schedule every pinned events before the the non-pinned
> 
>  include/linux/perf_event.h |    3 +-
>  kernel/perf_event.c        |  283 ++++++++++++++++++++++++++++++++-----------
>  2 files changed, 212 insertions(+), 74 deletions(-)

Sans the small naming suggestions i had, the general principle looks 
good to me - it's a nice restructuring of the various scheduling rules 
we have for events.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751665AbZL1Oa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbZL1Oa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZL1Oa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:30:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbZL1Oaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:30:55 -0500
Subject: Re: [RFC 8/12][PATCH] SCHED_DEADLINE: wait next instance syscall
 added.
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1255707898.6228.463.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707898.6228.463.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 15:30:01 +0100
Message-ID: <1262010601.7135.113.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:44 +0200, Raistlin wrote:
> This commit introduces another new SCHED_DEADLINE related syscall. It is
> called sched_wait_interval() and it has close-to-clock_nanosleep semantic.
> 
> However, for SCHED_DEADLINE tasks, it should be the call with which each
> job closes its current instance. In fact, in this case, the task is put to
> sleep and, when it wakes up, the scheduler is informed that a new job
> arrived, saving the overhead that usually comes with a task activation
> to enforce maximum task bandwidth.

The changelog suggests (and a very brief looks seems to confirm) that
this code could be much smaller by using hrtimer_nanosleep().

The implementation as presented seems to only call ->wait_interval()
when the timer arms, which seems like a bug, we should always call it,
regardless of whether we're on a period boundary.


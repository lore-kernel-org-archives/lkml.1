Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZL1Oo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZL1Oo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZL1Oo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:44:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:51069 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbZL1Oo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:44:56 -0500
Subject: Re: [RFC 9/12][PATCH] SCHED_DEADLINE: system wide bandwidth
 management
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
In-Reply-To: <1255707940.6228.464.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707940.6228.464.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 15:44:09 +0100
Message-ID: <1262011449.7135.116.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:45 +0200, Raistlin wrote:
> This commit adds the capability of controlling the maximum, system wide,
> CPU bandwidth that is devoted to SCHED_DEADLINE tasks.
> 
> This is done by means of two files:
>  - /proc/sys/kernel/sched_deadline_runtime_us,
>  - /proc/sys/kernel/sched_deadline_period_us.
> The ratio runtime/period is the total bandwidth all the SCHED_DEADLINE tasks
> can use in the system as a whole.
> Trying to create tasks in such a way that they exceed this limitation will
> fail, as soon as the bandwidth cap would be overcome.
> 
> Default value is _zero_ bandwidth available, thus write some numbers in those
> files before trying to start some SCHED_DEADLINE task. Setting runtime > period
> is allowed (i.e., more than 100% bandwidth available for -deadline tasks),
> since it makes more than sense in SMP systems.

Right, so the current rt bandwidth controls go up to 100%, where 100% is
root_domain wide. That is, the bandwidth usage scale is irrespective of
the number of cpus.

If that was the best choice could of course be argued, but since we have
that, it would be strange to add another set of controls which do not
conform.


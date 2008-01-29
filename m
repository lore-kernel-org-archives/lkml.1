Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbYA2K6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbYA2K6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 05:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYA2K6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 05:58:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44124 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYA2K6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 05:58:34 -0500
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, vatsa <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve Grubb <sgrubb@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Li, Tong N" <tong.n.li@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>
In-Reply-To: <1201600428.28547.87.camel@lappy>
References: <1201600428.28547.87.camel@lappy>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 11:57:22 +0100
Message-Id: <1201604243.28547.101.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here I go, talking to myself..

On Tue, 2008-01-29 at 10:53 +0100, Peter Zijlstra wrote:

> My thoughts were to make stronger use of disjoint cpu-sets. cgroups and
> cpusets are related, in that cpusets provide a property to a cgroup.
> However, load_balance_monitor()'s interaction with sched domains
> confuses me - it might DTRT, but I can't tell.
> 
> [ It looks to me it balances a group over the largest SD the current cpu
>   has access to, even though that might be larger than the SD associated
>   with the cpuset of that particular cgroup. ]

Hmm, with a bit more thought I think that does indeed DTRT. Because, if
the cpu belongs to a disjoint cpuset, the highest sd (with
load-balancing enabled) would be that. Right?

[ Just a bit of a shame we have all cgroups represented on each cpu. ]

Also, might be a nice idea to split the daemon up if there are indeed
disjoint sets - currently there is only a single daemon which touches
the whole system.


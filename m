Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYIHSEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYIHSEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYIHSE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:04:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40021 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYIHSE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:04:27 -0400
Subject: Re: 2.6.27-rc5 OLTP performance regression
From: Peter Zijlstra <peterz@infradead.org>
To: "Ma, Chinang" <chinang.ma@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1220896833.18239.141.camel@twins.programming.kicks-ass.net>
References: <BC02C49EEB98354DBA7F5DD76F2A9E8002FE60F751@azsmsx501.amr.corp.intel.com>
	 <1220896833.18239.141.camel@twins.programming.kicks-ass.net>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 20:04:12 +0200
Message-Id: <1220897052.18239.147.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 20:00 +0200, Peter Zijlstra wrote:
> On Mon, 2008-09-08 at 10:58 -0700, Ma, Chinang wrote:
> > We found the group scheduler in 2.6.27-rc5 has negative performance
> > impact on TPC Online Transaction Processing workload. The test was
> > conducted on a dual-socket quad-core Xeon server. OLTP workload is
> > disk i/o intensive and we have over 200 database shadow processes
> > running in the server during this test.  Enabling group scheduler
> > (CONFIG_GROUP_SCHED=y) reduced performance by 2.0%. Oprofile data
> > indicates significant amount of cycles are spent in tg_shares_up().
> >  This is new regression as we did not find the same issue with 2.6.26
> > kernel group scheduler. Is anybody looking into group scheduler
> > performance and any idea for reducing the performance impact? 
> 
> Because the .26 group scheduler wasn't SMP aware. The extra cost comes
> from the fact that .27 is.

What you can do it increase the /proc/sys/kernel/sched_shares_ratelimit
value and thereby decrease the accuracy of the SMP fairness of the group
scheduler.


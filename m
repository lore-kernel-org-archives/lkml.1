Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbYIIVkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbYIIVkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 17:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbYIIVjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 17:39:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:28996 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbYIIVjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 17:39:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,368,1217833200"; 
   d="scan'208";a="378499681"
From: "Ma, Chinang" <chinang.ma@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 9 Sep 2008 14:39:41 -0700
Subject: RE: 2.6.27-rc5 OLTP performance regression
Thread-Topic: 2.6.27-rc5 OLTP performance regression
Thread-Index: AckR3WhOcri0J1IkSiqlrkZ+VUJdxgA5l/OQ
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E8002FE6E71C7@azsmsx501.amr.corp.intel.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E8002FE60F751@azsmsx501.amr.corp.intel.com>
	 <1220896833.18239.141.camel@twins.programming.kicks-ass.net>
 <1220897052.18239.147.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1220897052.18239.147.camel@twins.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,
        We increased sched_shares_ratelimit and were able to recover the 2% performance regression.
Thanks,

-----Original Message-----
From: Peter Zijlstra [mailto:peterz@infradead.org]
Sent: Monday, September 08, 2008 11:04 AM
To: Ma, Chinang
Cc: Ingo Molnar; Srivatsa Vaddagiri; Mike Galbraith; Gregory Haskins; Steven Rostedt; Nick Piggin; Siddha, Suresh B; Wilcox, Matthew R; Tripathi, Sharad C; Chilukuri, Harita; linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5 OLTP performance regression

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


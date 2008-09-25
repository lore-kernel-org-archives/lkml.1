Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYIYVEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYIYVEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbYIYVEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:04:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:13668 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbYIYVEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:04:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,309,1220252400"; 
   d="scan'208";a="620372631"
From: "Ma, Chinang" <chinang.ma@intel.com>
To: "Ma, Chinang" <chinang.ma@intel.com>, Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 25 Sep 2008 14:04:01 -0700
Subject: RE: 2.6.27-rc5 OLTP performance regression
Thread-Topic: 2.6.27-rc5 OLTP performance regression
Thread-Index: AckTbJNRtFcyH+QFRlCY2aaqKI5uqAANOdUgAuvKpXA=
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E8002FEC1730D@azsmsx501.amr.corp.intel.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E8002FE60F751@azsmsx501.amr.corp.intel.com>
 <1220896833.18239.141.camel@twins.programming.kicks-ass.net>
 <1220897052.18239.147.camel@twins.programming.kicks-ass.net>
 <BC02C49EEB98354DBA7F5DD76F2A9E8002FE6E71C7@azsmsx501.amr.corp.intel.com>
 <20080910122622.GG14757@elte.hu>
 <BC02C49EEB98354DBA7F5DD76F2A9E8002FE6E7B62@azsmsx501.amr.corp.intel.com>
 <20080910173442.GB31942@elte.hu> 
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

We also tested sched_shares_ratelimit = 100 ms and reduce the OLTP regression to 0.2%. (very small return in performance with 10x the value). Can we count on this sched_shares_ratelimit tunable be always accessible for workload that does not depend on group fairness?

Chinang

-----Original Message-----
From: Ma, Chinang
Sent: Wednesday, September 10, 2008 5:08 PM
To: Ingo Molnar
Cc: Peter Zijlstra; Srivatsa Vaddagiri; Mike Galbraith; Gregory Haskins; Steven Rostedt; Nick Piggin; Siddha, Suresh B; Wilcox, Matthew R; Tripathi, Sharad C; Chilukuri, Harita; linux-kernel@vger.kernel.org
Subject: RE: 2.6.27-rc5 OLTP performance regression

When set to 10 ms the regression is about 0.4%. We get most of the 2%.

Chinang
-----Original Message-----
From: Ingo Molnar [mailto:mingo@elte.hu]
Sent: Wednesday, September 10, 2008 10:35 AM
To: Ma, Chinang
Cc: Peter Zijlstra; Srivatsa Vaddagiri; Mike Galbraith; Gregory Haskins; Steven Rostedt; Nick Piggin; Siddha, Suresh B; Wilcox, Matthew R; Tripathi, Sharad C; Chilukuri, Harita; linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5 OLTP performance regression


* Ma, Chinang <chinang.ma@intel.com> wrote:

> I increased the /proc/sys/kernel/sched_shares_ratelimit from 1
> millisecond to one second to reduce the frequency of shares update.
> That was okay for OLTP workload. As Peter mentioned, a larger value
> will reduce the accuracy of SMP fairness for group scheduler and the
> ratelimit and using a larger default value may not be good for general
> case.

does 10 msecs already get you most of the 2%? 1000 millisecond sounds
very (and probably unacceptable) coarse.

        Ingo

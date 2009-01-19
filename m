Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZASTIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZASTIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZASTIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:08:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43805 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbZASTIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:08:38 -0500
Subject: RE: Mainline kernel OLTP performance update
From: Steven Rostedt <srostedt@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: "Ma, Chinang" <chinang.ma@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1232391305.6521.146.camel@think.oraclecorp.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
	 <20090114163557.11e097f2.akpm@linux-foundation.org>
	 <20090115012147.GW29283@parisc-linux.org>
	 <20090114180431.f4a96543.akpm@linux-foundation.org>
	 <1231986439.21980.54.camel@localhost.localdomain>
	 <BC02C49EEB98354DBA7F5DD76F2A9E80031752B166@azsmsx501.amr.corp.intel.com>
	 <1232388291.6521.140.camel@think.oraclecorp.com>
	 <1232390259.25783.5.camel@localhost.localdomain>
	 <1232391305.6521.146.camel@think.oraclecorp.com>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 19 Jan 2009 14:07:35 -0500
Message-Id: <1232392055.25783.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-01-19 at 13:55 -0500, Chris Mason wrote:

> I wasn't actually looking at the cost of the checks, even though they do
> look higher (if they are using CONFIG_CPUMASK_OFFSTACK anyway).
> 
> The 2.6.24 code would trigger a rescheduling interrupt only when the
> prio of the inbound task was higher than the running task.
> 
> This workload has a large number of equal priority rt tasks that are not
> bound to a single CPU, and so I think it should trigger more
> preempts/reschedules with the today's check_preempt_equal_prio().

Ah yeah. This is one of the things that shows RT being more "responsive"
but less on performance. An RT task wants to run ASAP even if that means
there's a chance of more interrupts and higher cache misses.

The old way would be much faster in general through put, but I measured
RT tasks taking up to tens of milliseconds to get scheduled. This is
unacceptable for an RT task.

-- Steve



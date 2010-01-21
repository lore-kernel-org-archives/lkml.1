Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763Ab0AUHVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab0AUHVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 02:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689Ab0AUHVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 02:21:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39617 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab0AUHVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 02:21:47 -0500
Date: Thu, 21 Jan 2010 08:21:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
Message-ID: <20100121072118.GA10585@elte.hu>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
 <1263994448.4283.1052.camel@laptop>
 <1264023204.4283.1124.camel@laptop>
 <4B57907E.5000207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B57907E.5000207@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> I really think we need some sort of data structure which is passed from the 
> kernel to user space to represent the topology of the system, and give 
> useful information to be able to identify each PMU node.  Whether this is 
> done with a sysfs-style tree, a table in a file, XML, etc... it doesn't 
> really matter much, but it needs to be something that can be parsed 
> relatively easily and *contains just enough information* for the user to be 
> able to correctly choose PMUs, and for the kernel to be able to relate that 
> back to actual PMU hardware.

The right way would be to extend the current event description under 
/debug/tracing/events with hardware descriptors and (maybe) to formalise this 
into a separate /proc/events/ or into a separate filesystem.

The advantage of this is that in the grand scheme of things we _really_ dont 
want to limit performance events to 'hardware' hierarchies, or to 
devices/sysfs, some existing /proc scheme, or any other arbitrary (and 
fundamentally limiting) object enumeration.

We want a unified, logical enumeration of all events and objects that we care 
about from a performance monitoring and analysis point of view, shaped for the 
purpose of and parsed by perf user-space. And since the current event 
descriptors are already rather rich as they enumerate all sorts of things: 

 - tracepoints
 - hw-breakpoints
 - dynamic probes
 
etc., and are well used by tooling we should expand those with real hardware 
structure.

Thanks,

	Ingo

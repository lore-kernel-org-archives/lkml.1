Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386Ab0A1THp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab0A1THp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 14:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780Ab0A1THo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 14:07:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:60060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab0A1THn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 14:07:43 -0500
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <4B61D0CB.4090809@linux.vnet.ibm.com>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <1263994448.4283.1052.camel@laptop> <1264023204.4283.1124.camel@laptop>
	 <4B57907E.5000207@linux.vnet.ibm.com> <20100121072118.GA10585@elte.hu>
	 <4B58A750.2060607@linux.vnet.ibm.com> <4B58AAF7.60507@linux.vnet.ibm.com>
	 <20100127102834.GA27357@elte.hu>  <4B60990C.1030804@linux.vnet.ibm.com>
	 <1264676244.4283.2093.camel@laptop>  <4B61D0CB.4090809@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 20:06:47 +0100
Message-ID: <1264705607.4283.2120.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 10:00 -0800, Corey Ashford wrote:
> 
> I don't quite get what you're saying here.  Perhaps you are thinking 
> that all uncore units are associated with a particular cpu node, or a 
> set of cpu nodes?  And that there's only one uncore unit per cpu (or set 
> of cpus) that needs to be addressed, i.e. no ambiguity?

Well, I was initially thinking of the intel uncore thing which is memory
controller, so node, level.

But all system topology bound pmus can be done that way.

> That is not going to be the case for all systems.  We can have uncore 
> units that are associated with the entire system,

Right, but that's simple too.

> for example PMUs in an I/O device.  

> And we can have multiple uncore units of a particular 
> type, for example multiple vector coprocessors, each with its own PMU, 
> and are associated with a single cpu or a set of cpus.
> 
> perf_events needs an addressing scheme that covers these cases. 

You could possible add a u64 pmu_id field to perf_event_attr and use
that together with things like:

  PERF_TYPE_PCI, attr.pmu_id = domain:bus:device:function encoding
  PERF_TYPE_SPU, attr.pmu_id = spu-id

But before we go there the perf core needs to be extended to deal with
multiple hardware pmus, something which isn't too hard but we need to be
careful not to bloat the normal code paths for these somewhat esoteric
use cases.




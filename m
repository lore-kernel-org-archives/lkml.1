Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZENNZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZENNZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZENNZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:25:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49973 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZENNZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:25:21 -0400
Date: Thu, 14 May 2009 09:25:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       zhaolei@cn.fujitsu.com, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v3] ftrace: add a tracepoint for
 __raise_softirq_irqoff()
In-Reply-To: <20090514123606.GB21241@Krystal>
Message-ID: <alpine.DEB.2.00.0905140923180.30591@gandalf.stny.rr.com>
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal> <4A07D3B3.10605@cn.fujitsu.com> <20090511134019.GB10932@Krystal> <4A0B859B.8070801@cn.fujitsu.com> <20090514035037.GA8159@Krystal> <4A0BB4EA.60203@cn.fujitsu.com>
 <20090514123606.GB21241@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 14 May 2009, Mathieu Desnoyers wrote:
> > > 
> > 
> > It's not needed for trace/events/irq.h
> > 
> > Yes, it's a solution.
> > 
> > But I don't think we have to do this, CREATE_TRACE_POINTS is
> > needed only _once_ for every <trace/events/xxxx.h>
> > 
> > The .c file which defines CREATE_TRACE_POINTS can provide
> > (had provided likely) things like "#include <linux/interrupt.h>"
> > 
> > See kernel/softirq.c:
> > #include <linux/interrupt.h>
> > ......
> > ......
> > #define CREATE_TRACE_POINTS
> > #include <trace/events/irq.h>
> > 
> 
> Isn't it all included under kernel/trace/events.c ? e.g. :

Mathieu,

I've told you this two or three times before. That file no longer exists. 
Maybe it is still there for .30, but these updates are for .31 (too late 
for .30). The code to make TRACE_EVENT work for modules removed the 
events.c file and got rid of those nasty stages.

-- Steve


> 
> #include <trace/trace_events.h>
> 
> #include "trace_output.h"
> 
> #include "trace_events_stage_1.h"
> #include "trace_events_stage_2.h"
> #include "trace_events_stage_3.h"
> 
> Therefore, adding a #include <linux/interrupt.h> would be just weird
> here. We would have to do that for every tracepoint headers, and we
> would just lose the ability to keep track of which tracepoint header has
> which include dependency.
> 
> I thought the goal of TRACE_EVENT() was exactly the opposite : to
> declare everything in one location....
> 
> Therefore, if you agree that it's good to have TRACE_EVENT() declaring
> everything in one location, then I don't see why you would argue to move
> the include dependencies in the very remote kernel/trace/events.c file ?
> 
> Mathieu
> 
> > I don't think it's a problem, CREATE_TRACE_POINTS is defined only
> > once for a <trace/events/xxxx.h>.
> > 
> > Lai.
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 

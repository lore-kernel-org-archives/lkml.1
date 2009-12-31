Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbZLaBoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbZLaBoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 20:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZLaBoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 20:44:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbZLaBoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 20:44:19 -0500
X-Authority-Analysis: v=1.0 c=1 a=saNOKxlm9mAA:10 a=7U3hwN5JcxgA:10 a=bTxtrCFKbuZ93E9ZVZUA:9 a=XDVISQ6WHFSh93Da13q2YfBHLYgA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] dynamic debug - adding ring buffer storage support
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20091230225011.GJ6322@nowhere>
References: <1261481526-17630-1-git-send-email-jolsa@redhat.com>
	 <20091222153955.GD3308@redhat.com>
	 <20091222161353.GB20225@jolsa.lab.eng.brq.redhat.com>
	 <20091228092402.GD24690@elte.hu>  <20091230225011.GJ6322@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 30 Dec 2009 20:44:17 -0500
Message-ID: <1262223857.28171.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 23:50 +0100, Frederic Weisbecker wrote:

> That said, I sometimes dream about one event per printk.
> 
> Having, say:
> 
> /debug/tracing/events/printk/
>          |
>          ---- kernel/
>          |      |
>          |      ------- time/
>          |      |        |
>          |      |        ---- clocksource.c
>          |      |                 |
>          |      |                 --- clocksource_unstable:218/
>          |      |                 |            |
>          |      |                 |            ---- format
>          |      |                 |            |
>          |      |                 |            ---- filter
>          |      |                 |            |
>          |      |                 |            ---- enable
>          |      |                 --- [...]
>          |      ------- [...]
>          |
>          ---- drivers/
>          |       |
>          |       ---- [...]
>          |
>          ---- [...]
> 
> 
> That would give a total control over every printk, trace_printk, etc...
> 
> Too bad that would bloat the memory.
> Well, that could be wrapped in a single, wildly implemented (understand:
> not using TRACE_EVENT macro) trace event, something able to walk through
> every calls of printk, trace_printk, early_printk, etc... and imitate
> a per printk event granularity.
> 
> But still it needs to be useful...


I think we can do the above without bloating memory. Yes we would not
need the TRACE_EVENT macro for this. The TRACE_EVENT macro is just for
generic tracing, but we could easily come up with something specific for
the printk's that will not bloat the kernel as much.

When I get some time, I may try to play with this idea.

-- Steve




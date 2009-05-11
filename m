Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZEKOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZEKOJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZEKOJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:09:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36775 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZEKOJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:09:05 -0400
Date: Mon, 11 May 2009 10:09:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v3] ftrace: add a tracepoint for
 __raise_softirq_irqoff()
In-Reply-To: <20090511134019.GB10932@Krystal>
Message-ID: <alpine.DEB.2.00.0905111003280.14976@gandalf.stny.rr.com>
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal> <4A07D3B3.10605@cn.fujitsu.com> <20090511134019.GB10932@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 11 May 2009, Mathieu Desnoyers wrote:
> 
> Yes, we should try to fix TRACE_EVENT, but we should fix it _before_ we
> start using it widely. Circular header dependencies is a real problem
> with TRACE_EVENT right now.
> 
> Until we fix this, I will be tempted to stay with a known-good solution,
> which is DECLARE/DEFINE_TRACE.

The majority of tracepoints happen is C files. Those few cases where they 
are used in headers is where the issues arise.

But...

I did not want to uglify all trace event headers with:

#ifdef CREATE_FOO_TRACE_POINTS
#undef CREATE_FOO_TRACE_POINTS
#include <trace/define_trace.h>
#endif

We would only need to do that for those trace points that need to be 
included in header files. Then the declaration C file would need to define 
both CREATE_FOO_TRACE_POINTS and CREATE_TRACE_POINTS

#define CREATE_FOO_TRACE_POINTS
#define CRATE_TRACE_POINTS
#include <trace/events/foo.h>


But this is pretty trivial to solve, and I do not consider it a show 
stopper or a major header dependency problem.

-- Steve


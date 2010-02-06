Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0BFNVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 08:21:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44595 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab0BFNVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 08:21:18 -0500
X-Authority-Analysis: v=1.0 c=1 a=I-JJUczq-h8A:10 a=kSWueQS-EJw4MZsgdscA:9 a=vZxg-Ijrb5fqLmGPFzNFBfo0SzoA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 02/11] tracing: Introduce TRACE_EVENT_INJECT
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20100206122004.GF5062@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265188475-23509-3-git-send-regression-fweisbec@gmail.com>
	 <1265381266.24386.32.camel@gandalf.stny.rr.com>
	 <1265381604.22001.682.camel@laptop>
	 <1265382452.24386.38.camel@gandalf.stny.rr.com>
	 <20100206122004.GF5062@nowhere>
Content-Type: text/plain
Date: Sat, 06 Feb 2010 08:19:30 -0500
Message-Id: <1265462370.4561.12179.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-06 at 13:20 +0100, Frederic Weisbecker wrote:

> I agree with you that creating a new trace event macro is a bit
> insane. ftrace.h is already a nightmare. I just thought that
> having the injector set inside the same macro that the synchronous
> event is defined helped to make it clear about its nature: that
> it needs a secondary async catch up thing.
> 
> But a register_event_injector thing will work too, we probably
> better want that, given the maintainance pain otherwise.

We can add a register_event_injector later. For now, why not just add
the TRACE_EVENT() and then hook to it in perf using the normal
tracepoint mechanism.

You could add some macro around the trace_init_lock_class() call that
would facilitate finding all the locks you need. This would probably be
a bit more straight forward than to overload TRACE_EVENT() again.

> 
> I really would like to make something useful for everyone, could
> you tell me more about johill needs?

Well, basically he needed a way to cause polling to happen using an
event. From what I understood, the polling called the trace point. Just
enabling the trace point did nothing because the polling did not take
place. I thought about ways to enable this command when the trace point
was enabled. But in the end, it was specific to a driver and another
debugfs file seemed a better fit to initiate it.

-- Steve



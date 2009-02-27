Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZB0RDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZB0RDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 12:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZB0RD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 12:03:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53212 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417AbZB0RD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 12:03:26 -0500
Message-ID: <49A81D05.4040807@redhat.com>
Date: Fri, 27 Feb 2009 12:04:05 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH] tracing/ftrace: add missing wake-up on some callsites
References: <49a1cc8f.2283420a.54d2.ffff8461@mx.google.com> <alpine.DEB.2.00.0902231034570.18221@gandalf.stny.rr.com> <alpine.DEB.2.00.0902231039290.18221@gandalf.stny.rr.com> <20090223162630.GG5961@nowhere> <alpine.DEB.2.00.0902231151020.18221@gandalf.stny.rr.com> <20090223170528.GH5961@nowhere> <alpine.DEB.2.00.0902231211230.18221@gandalf.stny.rr.com> <20090223173714.GA601@elte.hu> <alpine.DEB.2.00.0902231303000.18221@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0902231303000.18221@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 23 Feb 2009, Ingo Molnar wrote:
> 
>> * Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>>>> Which would send a delayed work to wake up?
>>> No, I was thinking that trace_delay_wake_up() would be called 
>>> by these dangerous call sites. Then a per_cpu flag could be 
>>> set. We could have a trace point in the scheduler code that is 
>>> outside holding a runqueue lock, and this trace point would 
>>> call a trace function that will clear the per cpu flag, and 
>>> then call trace_wake_up().
>> No, that's very roundabout and ugly. If we putting a tracepoint 
>> there we might as well put real scheduler code there that looks 
>> for such a flag. But i'm not convinced we need a flag ...
> 
> Just a suggestion. I was trying to keep the tracer from being an overhead. 
> But what else would you suggest? Just having the scheduler call 
> trace_wakeup?

Actually, Systemtap(LTTng too?) also has same problem. Currently,
we're using a periodical timer to wake the reader process up.
I assume if we can put a tracepoint at the beginning of schedule(),
we can share it.

Thank you,


> 
> -- Steve
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


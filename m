Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbYJKXun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbYJKXun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 19:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYJKXuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 19:50:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYJKXug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 19:50:36 -0400
Date: Sat, 11 Oct 2008 19:50:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 4/5] tracing/fastboot: Add a time field on the sched_switch
 entry
In-Reply-To: <c62985530810111358o10e33becw8ce9c83c46733f3b@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810111947120.19507@gandalf.stny.rr.com>
References: <48F10A9D.3030705@gmail.com>  <alpine.DEB.1.10.0810111644440.19507@gandalf.stny.rr.com> <c62985530810111358o10e33becw8ce9c83c46733f3b@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 11 Oct 2008, Fr?d?ric Weisbecker wrote:

> 2008/10/11 Steven Rostedt <rostedt@goodmis.org>:
> >> +
> >> +static enum print_line_t boot_trace_print_line(struct trace_iterator *iter)
> >> +{
> >> +     struct trace_entry *entry = iter->ent;
> >> +
> >> +     if (entry->type == TRACE_BOOT)
> >> +             return initcall_print_line(iter);
> >> +     if (entry->type == TRACE_CTX || entry->type == TRACE_WAKE)
> >> +             return sched_switch_print_line(iter);
> >>       return TRACE_TYPE_UNHANDLED;
> >>  }
> >>
> >> @@ -100,7 +159,7 @@ struct tracer boot_tracer __read_mostly =
> >>       .init           = boot_trace_init,
> >>       .reset          = reset_boot_trace,
> >>       .ctrl_update    = boot_trace_ctrl_update,
> >> -     .print_line     = initcall_print_line,
> >> +     .print_line     = boot_trace_print_line,
> >>  };
> >>
> >>  void trace_boot(struct boot_trace *it, initcall_t fn)
> >>
> >>
> >
> 
> Yes but this one doesn't seem to start at zero at the boot time.
> There is a big difference between those two ...

Even so, I disagree having the context switch tracer hold another 8 byte 
timestamp.  If you want to add something to the boot tracer, than fine. 
But not to something that other tracers use.

You can tap into the context switch trace_point too, and have that record 
a special trace entry for you instead.

-- Steve


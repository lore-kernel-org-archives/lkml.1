Return-Path: <linux-kernel-owner+w=401wt.eu-S934259AbYD1NFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934259AbYD1NFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbYD1NFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:05:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54375 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765480AbYD1NFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:05:23 -0400
Date: Mon, 28 Apr 2008 09:05:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] ftrace: add trace pipe header pluggin
In-Reply-To: <20080426203306.2e41fb55@daedalus.pq.iki.fi>
Message-ID: <Pine.LNX.4.58.0804280903210.813@gandalf.stny.rr.com>
References: <20080421210935.460817943@goodmis.org> <20080421212128.360075568@goodmis.org>
 <20080426203306.2e41fb55@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 26 Apr 2008, Pekka Paalanen wrote:

> On Mon, 21 Apr 2008 17:09:37 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > This patch adds a method for open_pipe and open_read to the pluggins
> > so that they can add a header to the trace pipe call.
> >
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>
> In addition to this, I think I need tracer::close method called on
> tracing_release_pipe(). Use case: the reader closes the pipe before
> I have printed all of my header, i.e. walked through all PCI devices,
> so I need to properly destroy trace_iterator::private.

Good idea, I'll add that.

>
> I also intend to use trace_iterator::seq for printing my header, so I
> am looking if I can reuse code from tracing_read_pipe(). Looks like I'll
> extract the "return any leftover data" part into a separate function.
>
> To check trace_iterator::overrun, I'd like to be able to use
> for_each_tracing_cpu(), but that is local to trace.c.

I'll look into that.

>
> What happens when the tracing cpu mask changes? Mmiotrace does not take
> that into account and will continue to record with all CPUs, will this
> lead to problems, when mmiotrace starts to support SMP properly?

Good question. The tracing_cpu_mask isn't mine. So I'll need to know that
answer too.

>
> Now that I think of it, I probably want to use for_each_online_cpu()
> in checking for overruns... but that's not good either, if someone
> enables/disables a cpu during tracing. I guess you will have to / had to
> deal with this case in tracing core, too.

Good point.


-- Steve


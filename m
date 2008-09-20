Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYITOMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYITOMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 10:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYITOMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 10:12:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:60061 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbYITOMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 10:12:32 -0400
Date: Sat, 20 Sep 2008 07:12:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080920071232.46908040@infradead.org>
In-Reply-To: <20080920135548.GB23215@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	<alpine.DEB.1.10.0809200451420.9362@gandalf.stny.rr.com>
	<20080920135548.GB23215@Krystal>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 09:55:48 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> How about :
> 
>   trace_mark(ftrace_evname, "size %lu binary %pW",
>     sizeof(mystruct), mystruct);
>   or
>   trace_mark(sched_wakeup, "target_pid %ld", task->pid);
> 
> Note the namespacing with buffers being "ftrace" and "sched" here.
> 
> That would encapsulate the whole
>   - Event ID registration
>   - Event type registration
>   - Sending data out
>   - Enabling the event source directly at the source
> 
> We can then export the markers through a debugfs file and let userland
> enable them one by one and possibly connect systemtap filters on them
> (one table of registered filters, one table for the markers, a command
> file to connect/disconnect filters to/from markers).

I would like to ask for the following from the start: have a field for
a longer description of the marker that describes it's usage and
context. Getting this there from the start is critical, because only
when adding the marker point do people still really remember why/what
(and having to type a good description also helps them to realize if
this is the right point or not). This can then be exposed to the user
so he has a standing chance of knowing what the marker is about.

It also has a standing chance of being updated when the code changes
this way

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

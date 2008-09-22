Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbYIVTsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbYIVTsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYIVTsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:48:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbYIVTsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:48:04 -0400
Message-ID: <48D7F5E8.3000705@redhat.com>
Date: Mon, 22 Sep 2008 15:45:44 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Martin Bligh <mbligh@google.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
In-Reply-To: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Martin Bligh wrote:
> During kernel summit and Plumbers conference, Linus and others
> expressed a desire for a unified
> tracing buffer system for multiple tracing applications (eg ftrace,
> lttng, systemtap, blktrace, etc) to use.
> This provides several advantages, including the ability to interleave
> data from multiple sources,
> not having to learn 200 different tools, duplicated code/effort, etc.
> 
> Several of us got together last night and tried to cut this down to
> the simplest usable system
> we could agree on (and nobody got hurt!). This will form version 1.
> I've sketched out a few
> enhancements we know that we want, but have agreed to leave these
> until version 2.
> The answer to most questions about the below is "yes we know, we'll
> fix that in version 2"
> (or 3). Simplicity was the rule ...
>
> Sketch of design.  Enjoy flaming me. Code will follow shortly.
>
>
> STORAGE
> -------
>
> We will support multiple buffers for different tracing systems, with
> separate names, event id spaces.
> Event ids are 16 bit, dynamically allocated.
> A "one line of text" print function will be provided for each event,
> or use the default (probably hex printf)
> Will provide a "flight data recorder" mode, and a "spool to disk" mode.
>
> Circular buffer per cpu, protected by per-cpu spinlock_irq
> Word aligned records.
> Variable record length, header will start with length record.
> Timestamps in fixed timebase, monotonically increasing (across all CPUs)

I agree to integrate tracing buffer mechanism, but I don't think
your proposal is the simplest one.

To simplify, I think the layered buffering mechanism is desirable.
- The lowest layer just provides named circular buffers(both per-cpu and
  uni-buffer in system) and read/write scheme.
- Next layer provides user/kernel interface including controls.
- Top layer defines packet(and event) formatting utilities.
- Additionally, it would better provide some library routines(timestamp,
  event-id synchronize, and so on).

Since this unified buffer is used from different kind of tracers/loggers,
I don't think all of them(and future tracers) want to be tied down by
"event-id"+"parameter" format.
So, Sorry, I disagree about that the tracing buffer defines its *data format*,
it's just overkill for me.

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZDVJkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZDVJkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZDVJki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:40:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39859 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbZDVJkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:40:37 -0400
Date: Wed, 22 Apr 2009 11:40:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/events: make struct trace_entry->type to be int
	type
Message-ID: <20090422094026.GF18226@elte.hu>
References: <49EEDB0E.5070207@cn.fujitsu.com> <20090422091045.GA6031@nowhere> <49EEE104.9050709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EEE104.9050709@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Frederic Weisbecker wrote:
> > On Wed, Apr 22, 2009 at 04:53:34PM +0800, Li Zefan wrote:
> >> struct trace_entry->type is unsigned char, while trace event's id is
> >> int type, thus for a event with id >= 256, it's entry->type is cast
> >> to (id % 256), and then we can't see the trace output of this event.
> >>
> >>  # insmod trace-events-sample.ko
> >>  # echo foo_bar > /mnt/tracing/set_event
> >>  # cat /debug/tracing/events/trace-events-sample/foo_bar/id
> >>  256
> >>  # cat /mnt/tracing/trace_pipe
> >>            <...>-3548  [001]   215.091142: Unknown type 0
> >>            <...>-3548  [001]   216.089207: Unknown type 0
> >>            <...>-3548  [001]   217.087271: Unknown type 0
> >>            <...>-3548  [001]   218.085332: Unknown type 0
> >>
> >> [ Impact: fix output for trace events with id >= 256 ]
> >>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > 
> > 
> > Indeed, now with the trace_events, we are approaching this possible
> > overflow and the type is indeed an int:
> > 
> > struct trace_event *ftrace_find_event(int type)
> > 
> > Curious: does it only happen with the trace-event-sample?
> > I doubt we already reached this threshold of event number.
> > But anyway, it's a good thing.
> > 
> 
> I guess we haven't reached this limit, at least for mainline. :)
> 
> And the biggest id is 48 in my config.

I think we'll hit 256 pretty soon :) Applied, thanks guys!

Btw., has anyone thought about a .config option that turns every 
dprintk into a tracepoint, enumerated in /debug/tracing/events/ 
nicely (grouped by subsystems) and toggle-able?

( They cannot have 'format' and 'filter' files [at least yet] - but 
  integrating them into the existing tracing facilities makes sense 
  nevertheless - they are often used as subsystem tracepoints. 
  Allowing them to be captured via the tracing facilities would make 
  their usage a lot more flexible. )

	Ingo

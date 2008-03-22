Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYCVURA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYCVURA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 16:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYCVUQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 16:16:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYCVUQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 16:16:50 -0400
Date: Sat, 22 Mar 2008 16:16:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: tracing and mmiotrace
In-Reply-To: <20080322173245.01e69743@daedalus.pq.iki.fi>
Message-ID: <Pine.LNX.4.58.0803221609550.12942@gandalf.stny.rr.com>
References: <20080321233955.66e75a57@daedalus.pq.iki.fi> <20080322120746.GF13264@elte.hu>
 <20080322173245.01e69743@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Pekka,

I'm on vacation at the moment, but will start up helping Ingo with ftrace
on Monday.

On Sat, 22 Mar 2008, Pekka Paalanen wrote:

> >
> > that's weird - _entry_ is NULL?
>
> Yes. See the patch, and my kernel log at
> http://jumi.lut.fi/~paalanen/scratch/tracing-dmesg1.txt
>
> First you see my check in __trace_special() trigger, and then NULL
> pointer dereference BUG at ffffffff80259332 which translates to
> kernel/trace/trace.c:639 in tracing_generic_entry_update(), line:
> 	entry->preempt_count	= pc & 0xff;
> I don't understand why it tries to dereference NULL even when I
> check for it.

Interesting. I'll have to look into that more on Monday.

>
> ---
> Oh, and during bootup there is an error about -fstack-protector-all
> test failed.
>
> > > btw. currently 'cat /debug/tracing/trace' gives the
> > > print_func_help_header() and quits, it never stays waiting for more
> > > data.
> >
> > yeah - try "cat /debug/tracing/trace_pipe" for the waiting variant -
> > does that work better?
>
> Not really. IIRC it said "resource temporarily unavailable" until
> mmiotrace actually tried to produce data. No header there. So I
> cannot make "cat" ready to read and after that start tracing.

I'll have to clean up the trace_pipe code to be a bit more robust.

Thanks for doing this. I'll be getting more involved starting Monday.

-- Steve


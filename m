Return-Path: <linux-kernel-owner+w=401wt.eu-S966784AbYD1T1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966784AbYD1T1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966730AbYD1T1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:27:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32808 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966726AbYD1T1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:27:22 -0400
Date: Mon, 28 Apr 2008 15:27:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: ftrace and debugfs weird interaction
In-Reply-To: <20080428153956.GH18776@elte.hu>
Message-ID: <Pine.LNX.4.58.0804281523260.4615@gandalf.stny.rr.com>
References: <20080426185403.GA22522@Krystal> <20080428153956.GH18776@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5BOn Mon, 28 Apr 2008, Ingo Molnar wrote:

>
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
>
> > Hi,
> >
> > When trying to figure out what was going on with the sched tracer
> > "tracing_enabled" file (sched-devel.git tree), I fell on this strange
> > behavior :
> >
> > echo 1>tracing_enabled seems _not_ to send 1 to the tracing_ctrl_write

It should actually send "1" and not 1 (and technically "1\n") ;-)

> > callback. However, sending garbage, e.g. echo s> tracing_enabled,
> > correctly sends the 's' character down the chain. echo 0>tracing_enabled
> > sometimes results in the callback not even being called.

I haven't seen this. Perhaps I'm confused about what you are seeing.

> >
> > The debugfs file has been created with
> >
> >         entry = debugfs_create_file("tracing_enabled", 0644, d_tracer,
> >                                     &global_trace, &tracing_ctrl_fops);
> >         if (!entry)
> >                 pr_warning("Could not create debugfs 'tracing_enabled' entry\n");
> >
> > I wonder what kind of weird debugfs interaction we might have here ?

This looks normal to me. Could you provide a bit more detail to what you
are doing, what the results are, and what you expect the restults to be?

>
> hm. Cc:-ed more ftrace developers.

Thanks,

-- Steve

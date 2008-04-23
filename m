Return-Path: <linux-kernel-owner+w=401wt.eu-S933977AbYDWA62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977AbYDWA62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 20:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYDWA6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 20:58:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60693 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYDWA6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 20:58:19 -0400
Date: Tue, 22 Apr 2008 20:58:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>
Subject: Re: [PATCH 0/3] ftrace: overrun accounting and trace_pipe headers
In-Reply-To: <20080422203602.488bb8f9@daedalus.pq.iki.fi>
Message-ID: <Pine.LNX.4.58.0804222056190.22504@gandalf.stny.rr.com>
References: <20080421210935.460817943@goodmis.org> <20080422203602.488bb8f9@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 22 Apr 2008, Pekka Paalanen wrote:

> Excellent!

Thanks ;-)

>
> On Mon, 21 Apr 2008 17:09:35 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > The first patch in this series adds accounting to record overruns. That is
> > where the writing catches up to the reading of the buffer. This really
> > only matters for trace_pipe since that's a consumer / producer output file.
>
> This takes me some thinking how to make the best of it, but looks like it
> allows me to relay the overrun events into the trace log. Very good.
>
> > The next patch adds new methods for the plugins to hook into the
> > open_pipe and open_read, to let a plugin produce a header.
> > The open_read method can also be used to do something when overruns
> > are detected.
>
> You mean pipe_open() and read()? :-)
> And read() is pipe specific?

Yeah the read API is pipe specific (for now). I'll have to think about
whether or not we should have a generic "read" and a "pipe_read"

> Ah, now I see what you mean by read() can be used to notice overruns:
> it is called for every read syscall, not just in the beginning.

Right!

>
> > The last patch is a test patch AND SHOULD NOT BE APPLIED. It is just an
> > example in how to use the new methods to produce a header. It simply
> > makes the ftrace tracer produce a simple "Test header" before any
> > output.
>
> In function_read(), shouldn't I be doing something with filp and/or ppos?

Probably, that's why I said not to apply it ;-)

Thanks,

-- Steve


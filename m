Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbZASXaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbZASXaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZASXaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:30:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:14241 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbZASXaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:30:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ZiU6aH522Ooei1ovj2SG8ijlQb99fZljxVAI4N9Ja607DoA6TIZKqmCO7kJvbHUfUt
         ekMGv64IbNMydptJIgNMvE1DdJm1w6aW1+ko86yc+H2STpONX7cM9ijDj+R1LA1BXkvs
         LrfviOR1U9naeLNv6jrSKt+yiJF/ZRnkQiPDc=
Date: Tue, 20 Jan 2009 00:29:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] ftrace: infrastructure for supporting binary record
Message-ID: <20090119232956.GD6194@nowhere>
References: <495ADF45.2030203@cn.fujitsu.com> <20081231045956.GC28472@nowhere> <39e6f6c70901021424v28c1a7dbgbaaf67ac12ca9526@mail.gmail.com> <c62985530901191128k5a76fe4bh4fae585b8febf6c@mail.gmail.com> <20090119202523.GE690@ghostprotocols.net> <20090119210839.GA6194@nowhere> <20090119213720.GF690@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090119213720.GF690@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 07:37:21PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 19, 2009 at 10:08:40PM +0100, Frederic Weisbecker escreveu:
> > On Mon, Jan 19, 2009 at 06:25:23PM -0200, Arnaldo Carvalho de Melo wrote:
> > > Em Mon, Jan 19, 2009 at 08:28:03PM +0100, Frédéric Weisbecker escreveu:
> > > > 2009/1/2 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> > > > >
> > > > > warning: I haven't looked at the patch details
> > > > >
> > > > > But I would love to use something like this to provide the exact
> > > > > contents the userspace blktrace utilities want.
> > > > >
> > > > > - Arnaldo
> > > > >
> > > > 
> > > > 
> > > > Hi Arnaldo,
> > >  
> > > > Since you talked about binary record for the blk tracer, I just recall
> > > > this patch.  Are you sure this infrastructure would cover your needs?
> > > 
> > > Nope, now that I look at it it definetely isn't what I need. See? the
> > > warning was valid after all :-)
> > > 
> > > What I want and will experiment now is to almost dump the contents of
> > > the ring buffer as-is to userspace. I want that so that I can use
> > > blkparse to validate the ring buffer + blkFtrace routines produced
> > > buffer.
> > > 
> > > So probably it will be a matter of using trace_iter to signal that, and
> > > when it gets to my print_line routine I just put together the initial
> > > trace format expected by blkparse + the ones I'm collecting at
> > > tracepoint time.
> > 
> > 
> > So you would like two different trace files? Or print both bin and formatted
> > output together in the same file?
> > I'm not sure I understand :-s
> 
> output depends on iter_flags, most of what is needed is there, but I
> guess there are too many ways to achieve the same result and some
> keywords that are already used for other purposes, such as
> TRACE_ITER_BIN -> print_bin_fmt that forces all traces to first have
> pid, cpu and timestamp (all using trace_seq_putmem), then whatever the
> tracer wants to put after that (if it registered a tracer_event _and_ it
> has a ->binary() emitter), when I wanted it to just call ->binary(),
> where I would emulate exactly the old blktrace format, then we would be
> able to just ask for binary traces, collect them thru
> /d/tracing/trace_pipe and pipe them into blkparse for
> validation/debugging the ring_buffer + ftrace + blkFtrace code.


Oh I see. I think it just needs a new flag in struct trace_event to tell
if we want the headers or not.
And then check this flag in trace.c to decide if we print the cpu/time/pid
or let the tracer do all its job.

I will submit a patch in the next days to bring it.

 
> I'll try to get a brain dump in the form of working code later
> today/early tomorrow, now I'm being preempted by my wife to do those
> social things like having dinner and going to the movie theater 8)


Heh, have a good evening! :-)


> Regards,
> 
> - Arnaldo


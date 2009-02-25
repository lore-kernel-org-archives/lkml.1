Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZBYBPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZBYBPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZBYBPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:15:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZBYBPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:15:05 -0500
Date: Tue, 24 Feb 2009 20:15:01 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/4][RFC] event tracer
In-Reply-To: <20090225010111.GB16396@Krystal>
Message-ID: <alpine.DEB.2.00.0902242012360.12697@gandalf.stny.rr.com>
References: <20090224193344.638329210@goodmis.org> <1235504556.4645.2252.camel@laptop> <alpine.DEB.2.00.0902241706260.12697@gandalf.stny.rr.com> <49A473ED.4010001@redhat.com> <alpine.DEB.2.00.0902241731020.12697@gandalf.stny.rr.com>
 <20090225010111.GB16396@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Feb 2009, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > On Tue, 24 Feb 2009, Masami Hiramatsu wrote:
> > > > 
> > > > #undef TPFMT
> > > > #define TPFMT(fmt, args...) \
> > > > 	"(%s)" fmt "\n", #call, ##args
> > > > 
> > > > and then I could do
> > > > 
> > > > 	event_printk(fmt);
> > > 
> > > Why don't you do as below? :)
> > > 	event_printk_line("(" #call ")" ##fmtandargs);
> > 
> > Still need to sneak that "\n" in ;-)
> > 
> 
> Why do you need the \n ? Having all event format strings ending with \0
> should be enough to tell event_printk to generate a \n each time it
> encounters a format string \0. Doing so would save 1 byte per format
> string.

Because currently event_printk uses a generic function that acts pretty 
much like ftrace_printk.

I like having fmt and args separate. This way, we can add more stuff to 
the end if we ever want to. For now it's a '\n'. We can deal with 
those extra bytes.

-- Steve


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbZCJNkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbZCJNkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZCJNj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:39:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49862 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbZCJNjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:39:55 -0400
Date: Tue, 10 Mar 2009 09:39:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/7] tracing: typecast sizeof and offsetof to unsigned
 int
In-Reply-To: <20090309222033.d39c7b22.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0903100939200.4802@gandalf.stny.rr.com>
References: <20090310045710.286915983@goodmis.org> <20090310045810.602528682@goodmis.org> <20090309222033.d39c7b22.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Mar 2009, Andrew Morton wrote:

> On Tue, 10 Mar 2009 00:57:11 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On x86_64 sizeof and offsetof are treated as long, where as on x86_32
> > they are int. This patch typecasts them to unsigned int to avoid
> > one arch giving warnings while the other does not.
> 
> Actually, both have type size_t.
> 
> >  static int trace_write_header(struct trace_seq *s)
> >  {
> > @@ -457,11 +458,11 @@ static int trace_write_header(struct trace_seq *s)
> >  
> >  	/* struct trace_entry */
> >  	return trace_seq_printf(s,
> > -				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
> > -				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
> > -				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
> > -				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
> > -				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
> > +				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
> > +				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
> > +				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
> > +				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
> > +				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
> 
> Which may be printed with %z.

That's new to me ;-)

OK, I'll add a patch to my next series.

Thanks,

-- Steve


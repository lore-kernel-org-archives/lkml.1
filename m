Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZBYBB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZBYBB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZBYBBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:01:20 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:51312 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbZBYBBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:01:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQFAHclpElMQWXi/2dsb2JhbACBb9YRhBEG
Date: Tue, 24 Feb 2009 20:01:11 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
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
Message-ID: <20090225010111.GB16396@Krystal>
References: <20090224193344.638329210@goodmis.org> <1235504556.4645.2252.camel@laptop> <alpine.DEB.2.00.0902241706260.12697@gandalf.stny.rr.com> <49A473ED.4010001@redhat.com> <alpine.DEB.2.00.0902241731020.12697@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902241731020.12697@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:59:51 up 3 days, 16:33,  3 users,  load average: 0.41, 0.40,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Tue, 24 Feb 2009, Masami Hiramatsu wrote:
> > > 
> > > #undef TPFMT
> > > #define TPFMT(fmt, args...) \
> > > 	"(%s)" fmt "\n", #call, ##args
> > > 
> > > and then I could do
> > > 
> > > 	event_printk(fmt);
> > 
> > Why don't you do as below? :)
> > 	event_printk_line("(" #call ")" ##fmtandargs);
> 
> Still need to sneak that "\n" in ;-)
> 

Why do you need the \n ? Having all event format strings ending with \0
should be enough to tell event_printk to generate a \n each time it
encounters a format string \0. Doing so would save 1 byte per format
string.

Mathieu

> > 
> > Anyway, your proposal is good for me, because it will recover
> > an information which tracepoint has lost.
> 
> Thanks,
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

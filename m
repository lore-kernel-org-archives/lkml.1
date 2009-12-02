Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZLBQ1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZLBQ1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 11:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZLBQ1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 11:27:12 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:41984 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135AbZLBQ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 11:27:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFACMkFktGGNlG/2dsb2JhbACBTtY2hDEE
Date: Wed, 2 Dec 2009 11:27:15 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [tip:perf/core] tracing: Add DEFINE_EVENT(),
	DEFINE_SINGLE_EVENT() support to docbook
Message-ID: <20091202162715.GB9710@Krystal>
References: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com> <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org> <1259761934.12870.12.camel@gandalf.stny.rr.com> <20091202140128.GA2611@elte.hu> <1259764109.12870.37.camel@gandalf.stny.rr.com> <20091202144334.GA30359@elte.hu> <1259765735.12870.42.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1259765735.12870.42.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:23:29 up  7:14,  1 user,  load average: 0.00, 0.03, 0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2009-12-02 at 15:43 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Wed, 2009-12-02 at 15:01 +0100, Ingo Molnar wrote:
> > > 
> > > > >  DECLARE_CLASS_AND_DEFINE_EVENT()
> > > > 
> > > > Hm, that's a bit too long. How about 'DEFINE_CLASS_EVENT()' as a 
> > > > compromise? It's similarly short-ish to TRACE_EVENT(), and it also 
> > > > conveys the fact that we create both a class and an event there.
> > > > 
> > > > The full series would thus be:
> > > > 
> > > > 	DECLARE_EVENT_CLASS
> > > > 	DEFINE_EVENT
> > > > 	DEFINE_CLASS_EVENT
> > > > 
> > > > hm?
> > > 
> > > I thought about that too, but it actually makes it more confusing. 
> > > Because, looking at this with a fresh POV, I would think that after I 
> > > declare a class, I would use DEFINE_CLASS_EVENT with that class.
> > 
> > yeah. Hence was my second-best choice 'DEFINE_STANDALONE_EVENT' or 
> > 'DEFINE_SINGLE_EVENT' - to stress the special nature it, and to actually 
> > nudge people towards creating classes of events instead of doing 
> > separate, standalone points. (which are a waste in the majority of 
> > cases)
> 
> But the current TRACE_EVENT is still defining a class. Thus, you could
> create a TRACE_EVENT (or whatever it is called) and then create
> DEFINE_EVENTs based on the TRACE_EVENT.
> 
> That's why I want a name that describes this.
> 
> DEFINE_EVENT_CLASS?
> 
> Perhaps that's the best.
> 
> DECLARE_EVENT_CLASS - only creates a class
> DEFINE_EVENT - defines an event based off of a class
> DEFINE_EVENT_CLASS - creates a class and defines an event by the same name
> 
> Perhaps this is best in keeping with linux kernel naming conventions?

Hi Steve,

A few questions about the semantic:

Is "declare" here always only used as a declaration ? (e.g. only in
headers, never impacted by CREATE_TRACE_POINT ?)

Is "define" here always mapping to a definition ? (e.g. to be used in a
C file to define the class or event handling stub)

I feel that your DEFINE_EVENT_CLASS might actually be doing a bit more
than just "defining", it would actually also perform the declaration.
Same goes for "DEFINE_EVENT". So can you tell us a bit more about that
is the context of templates ?

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

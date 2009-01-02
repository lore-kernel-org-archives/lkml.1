Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbZABXdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbZABXdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbZABXcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:32:51 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:46116 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757066AbZABXcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:32:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAAkvXklMQWTh/2dsb2JhbACBbMkohXI
Date: Fri, 2 Jan 2009 18:32:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20090102233245.GA29623@Krystal>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro> <51a70358bfd74d84c844260d9b5b3ad6ac189d7d.1230622069.git.eduard.munteanu@linux360.ro> <20081230124017.GH28520@ghostprotocols.net> <20081230140232.GG10635@localhost> <20090102214805.GA26654@Krystal> <20090102223850.GA5235@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090102223850.GA5235@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:32:29 up 1 day, 23:30,  2 users,  load average: 0.03, 0.04,
	0.00
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Fri, Jan 02, 2009 at 04:48:05PM -0500, Mathieu Desnoyers wrote:
> > Yes, we could (and maybe should) use __always_inline there. Hrm, which
> > which tree to you work ? You probably mean DECLARE_TRACE() rather than
> > DEFINE_TRACE() ?
> > 
> > I just went over your patch again. it uses the old DEFINE_TRACE() API.
> > You should get the latest tracepoints which have DECLARE_TRACE() (for
> > trace/kmemtrace.h) and then a DEFINE_TRACE() in a .c.  Ah I see, you
> > work on 2.6.28. You should work on top of -tip, which has this new API.
> > Using the tracepoints present in 2.6.28 will not let you do only a
> > single definition of the tracepoint structure and it will lead to waste
> > of kernel memory by defining multiple instances of tracepoint structures
> > (one for each trace_*() use, so one per kmalloc()). The
> > Documentation/tracepoints.txt file is updated accordingly.
> > 
> 
> I'm supposed to merge it through Ingo's tip tree. If we're talking about
> the same tree, I'll do as you suggested.
> 
> > > But it is quite pointless. Sometimes we need _RET_IP_, sometimes
> > > _THIS_IP_ and sometimes a parameter we've been passed. That's because we
> > > want the IP of the caller, so it depends on whether this slab function
> > > is __always_inline, non-inlined or deeply nested within other functions
> > > (which can be as well __always_inline or non-inlined).
> > > 
> > 
> > Hrm ? In the case we just want
> > 
> >   trace_kmalloc(_THIS_IP, ......);
> > 
> > If we have __always_inline for the trace_*() declaration, isn't it the
> > same to just do this in the probe ?
> > 
> > void probe_kmalloc(......)
> > {
> >   ... _RET_IP_ ...;
> > 
> > }
> > 
> > This would remove a parameter from the stack created from the
> > instrumentation site, which is always good.
> 
> No, it's not always possible. Not all allocator functions (not even
> those of the same kind, as in alloc/free) make up an __always_inline
> chain. For example, there is one or a few instances where we pass a
> value other than _RET_IP_ or _THIS_IP_ to probes. It's quite hard to
> untangle things without making extensive modifications.
> 

OK, so let's leave the caller ip parameter then.

Mathieu

> > Mathieu
> > 
> > > 
> > > 	Eduard
> > > 
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

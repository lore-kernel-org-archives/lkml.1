Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYKGSsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYKGSsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYKGSr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:47:56 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:34223 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbYKGSrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:47:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEANcZFElMQWxa/2dsb2JhbACBdsdxg1Y
Date: Fri, 7 Nov 2008 13:42:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dhowells@redhat.com,
       nico@cam.org, torvalds@linux-foundation.org, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107184251.GA29428@Krystal>
References: <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com> <alpine.LFD.2.00.0811070952150.13034@xanadu.home> <8189.1226074915@redhat.com> <8509.1226077800@redhat.com> <20081107092643.0bd9bb4e.akpm@linux-foundation.org> <20081107180041.GG22134@Krystal> <20081107102148.6eb53dea.akpm@linux-foundation.org> <1226082624.11596.28.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1226082624.11596.28.camel@brick>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:42:30 up 155 days, 23:22,  6 users,  load average: 0.66, 0.65,
	0.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Harvey Harrison (harvey.harrison@gmail.com) wrote:
> On Fri, 2008-11-07 at 10:21 -0800, Andrew Morton wrote:
> > On Fri, 7 Nov 2008 13:00:41 -0500
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > > It's one of those things I hope I never need to know about, but perhaps
> > > > we do somewhere have static storage in an inline.  Wouldn't surprise
> > > > me, and I bet that if we do, it's a bug.
> > > 
> > > Tracepoints actually use that.
> > 
> > Referring to include/linux/tracepoint.h:DEFINE_TRACE()?
> > 
> > It does look a bit fragile.  Does every .c file which included
> > include/trace/block.h get a copy of __tracepoint_block_rq_issue,
> > whether or not it used that tracepoint? Hopefully not.
> > 
> > > It could be changed so they use :
> > > 
> > > DECLARE_TRACE() (in include/trace/group.h)
> > > DEFINE_TRACE()  (in the appropriate kernel c file)
> > > trace_somename(); (in the code)
> > > 
> > > instead. That would actually make more sense and remove the need for
> > > multiple declarations when the same tracepoint name is used in many
> > > spots (this is a problem kmemtrace has, it generates a lot of tracepoint
> > > declarations).
> 
> Could this scheme also help with the thousands of sparse warnings that
> kmemtrace produces because of the current arrangement, all of the form:
> 
> include/linux/kmemtrace.h:33:2: warning: Initializer entry defined twice
> include/linux/kmemtrace.h:33:2:   also defined here
> 
> As you could have unique names for the tracepoints now, rather than the
> 'unique' static storage?  Or am I off-base here?
> 

Exactly.

Mathieu

> Harvey
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

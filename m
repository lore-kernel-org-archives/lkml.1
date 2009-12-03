Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZLCOrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZLCOrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbZLCOrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:47:32 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:49768 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbZLCOrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:47:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAIJZF0tGGNlG/2dsb2JhbACBTtcwhDIE
Date: Thu, 3 Dec 2009 09:42:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: trace/events: DECLARE vs DEFINE semantic
Message-ID: <20091203144221.GA28823@Krystal>
References: <1259781578.12870.78.camel@gandalf.stny.rr.com> <4B16EC06.6010706@redhat.com> <1259794005.12870.102.camel@gandalf.stny.rr.com> <20091202231019.GB14770@Krystal> <4B1737E2.6010502@redhat.com> <1259813228.12870.108.camel@gandalf.stny.rr.com> <4B17C25A.8090703@redhat.com> <1259848493.12870.114.camel@gandalf.stny.rr.com> <20091203140942.GB24905@Krystal> <1259850248.12870.132.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1259850248.12870.132.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:39:10 up 1 day,  5:29,  3 users,  load average: 0.44, 0.47,
	0.42
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2009-12-03 at 09:09 -0500, Mathieu Desnoyers wrote:
[...]
> > Maybe we could have separate files for:
> > 
> > a) event definitions
> > b) class definitions
> 
> Um, because we don't add classes nor definitions for that matter in C
> files. These files will just have:
> 
> #define CREATE_TRACE_POINT
> #include <trace/event/x.h>
> #include <trace/event/y.h>
> [...]
> 
>
[...] 
> > I agree with Steven here: modules should come with their own trace event
> > definitions, and if the trace classes they use are not available in the
> > standard kernel, they should come with these trace classes definitions
> > too.
> > 
> > A small *_trace.c file linked along with the module looks fine by me.
> > 
> > And please, try to re-used the already existing symbol dependency
> > management already present in the kernel to deal with module dependency
> > on class and dependency such as:
> > 
> >   module-a.ko
> >     defines trace class
> >   module-b.ko
> >   module-c.ko
> > 
> >     module-b and module-c define events which depend on the trace class.
> > 
> > If you make the event definition depend on a symbol defined in module-a,
> > everything should work flawlessly. It also works if the class is defined
> > in the core kernel.
> 
> I think the issue is where to find the headers.
> 
> But this does bring up another point. I don't think I designed the class
> macro to be used by events in other headers. Looking at the code, since
> all the shared functions are "static" it wont work.
> 
> I guess I can modify it to be global, and also export them as GPL.

In that case maybe it would become appropriate to extract the
TRACE_CLASS() macros meant to be used by many headers into their own

include/trace/class/*.h

headers ?

And then it starts to make sense to have separate C files for event and
class definitions.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

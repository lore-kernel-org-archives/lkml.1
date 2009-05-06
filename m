Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbZEFPAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbZEFPAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761408AbZEFO75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:59:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37073 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761452AbZEFO74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:59:56 -0400
Subject: Re: [PATCH, RFC] sputrace: use the generic event tracer
From: Steven Rostedt <srostedt@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20090506144708.GC29044@elte.hu>
References: <20090506102918.GA23278@lst.de> <20090506105748.GE25203@elte.hu>
	 <20090506110258.GA24850@lst.de> <20090506112301.GK25203@elte.hu>
	 <1241618089.11379.22.camel@localhost.localdomain>
	 <20090506144708.GC29044@elte.hu>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 06 May 2009 10:59:28 -0400
Message-Id: <1241621968.11379.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-05-06 at 16:47 +0200, Ingo Molnar wrote:
> * Steven Rostedt <srostedt@redhat.com> wrote:
> 
> > 
> > On Wed, 2009-05-06 at 13:23 +0200, Ingo Molnar wrote:
> > 
> > > > > > +# magic for the trace events
> > > > > > +CFLAGS_sched.o := -I$(src)
> > > > > 
> > > > > Steve, i'm wondering whether this type of Makefile hackery (caused 
> > > > > by modular tracepoints) could be eliminated ...
> > > > 
> > > > We would just have to include the header file with "" instead of 
> > > > <>. But I remember Steve not liking this when we talked about it.
> > > 
> > > Yeah. But changing Makefiles isnt particularly clean either ...
> > > 
> > > And adding -I$(src) can have side-effects: we often have a local 
> > > foo.h while an include/linux/foo.h as well.
> > 
> > That still would not conflict, because
> > 
> > #include "foo.h"
> > 
> > will not include "linux/foo.h" and
> > 
> > #include <linux/foo.h>
> > 
> > will not include a local foo.h, unless there's also a local "linux"
> > directory with a foo.h in it.
> >
> > The Makefile hack has to do with being able to have the "foo.h" 
> > file with the TRACE_EVENTs someplace other than include/trace.
> > 
> > If the "foo.h" is in include/trace.h we do not need to include 
> > this hack. But because the include/trace/define_trace.h needs to 
> > include the "foo.h" file recursively, it must be able to find it. 
> > If we do not add a search path, include/trace/define_trace.h will 
> > not look in the other locations.
> > 
> > Note, as Christoph did, we only need to add the include path to 
> > the file that defines "CREATE_TRACE_POINTS". Which is only one 
> > file.
> > 
> > CFLAGS_sched.o := -I$(src)
> > 
> > Only touches the sched.c file in that directory (Note, for those 
> > reading this thread out of context, this is not the same file as 
> > kernel/sched.c)
> 
> Yeah, i guess we can live with it. It still feels imperfect though.

Yeah, I dislike it too. But this is a limitation on CPP. When we get
sparse to replace CPP then we can fix it there ;-)

> 
> (btw., find below a small typo fix)
> 
> 	Ingo
> 
> diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
> index f7a7ae1..1d6fa17 100644
> --- a/include/trace/define_trace.h
> +++ b/include/trace/define_trace.h
> @@ -1,5 +1,5 @@
>  /*
> - * Trace files that want to automate creationg of all tracepoints defined
> + * Trace files that want to automate the creation of all tracepoints defined
>   * in their file should include this file. The following are macros that the
>   * trace file may define:
>   *

Thanks,

-- Steve



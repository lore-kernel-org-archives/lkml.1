Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbZEFOrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbZEFOrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZEFOrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:47:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45374 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbZEFOrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:47:23 -0400
Date: Wed, 6 May 2009 16:47:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH, RFC] sputrace: use the generic event tracer
Message-ID: <20090506144708.GC29044@elte.hu>
References: <20090506102918.GA23278@lst.de> <20090506105748.GE25203@elte.hu> <20090506110258.GA24850@lst.de> <20090506112301.GK25203@elte.hu> <1241618089.11379.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241618089.11379.22.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <srostedt@redhat.com> wrote:

> 
> On Wed, 2009-05-06 at 13:23 +0200, Ingo Molnar wrote:
> 
> > > > > +# magic for the trace events
> > > > > +CFLAGS_sched.o := -I$(src)
> > > > 
> > > > Steve, i'm wondering whether this type of Makefile hackery (caused 
> > > > by modular tracepoints) could be eliminated ...
> > > 
> > > We would just have to include the header file with "" instead of 
> > > <>. But I remember Steve not liking this when we talked about it.
> > 
> > Yeah. But changing Makefiles isnt particularly clean either ...
> > 
> > And adding -I$(src) can have side-effects: we often have a local 
> > foo.h while an include/linux/foo.h as well.
> 
> That still would not conflict, because
> 
> #include "foo.h"
> 
> will not include "linux/foo.h" and
> 
> #include <linux/foo.h>
> 
> will not include a local foo.h, unless there's also a local "linux"
> directory with a foo.h in it.
>
> The Makefile hack has to do with being able to have the "foo.h" 
> file with the TRACE_EVENTs someplace other than include/trace.
> 
> If the "foo.h" is in include/trace.h we do not need to include 
> this hack. But because the include/trace/define_trace.h needs to 
> include the "foo.h" file recursively, it must be able to find it. 
> If we do not add a search path, include/trace/define_trace.h will 
> not look in the other locations.
> 
> Note, as Christoph did, we only need to add the include path to 
> the file that defines "CREATE_TRACE_POINTS". Which is only one 
> file.
> 
> CFLAGS_sched.o := -I$(src)
> 
> Only touches the sched.c file in that directory (Note, for those 
> reading this thread out of context, this is not the same file as 
> kernel/sched.c)

Yeah, i guess we can live with it. It still feels imperfect though.

(btw., find below a small typo fix)

	Ingo

diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index f7a7ae1..1d6fa17 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -1,5 +1,5 @@
 /*
- * Trace files that want to automate creationg of all tracepoints defined
+ * Trace files that want to automate the creation of all tracepoints defined
  * in their file should include this file. The following are macros that the
  * trace file may define:
  *

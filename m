Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbZABVxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbZABVxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbZABVxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:53:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39892 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbZABVxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:53:00 -0500
Date: Fri, 2 Jan 2009 22:52:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] fix compilation error
Message-ID: <20090102215239.GA17240@elte.hu>
References: <495AA87D.9060704@kernel.org> <495ABDF8.2070703@kernel.org> <20081231004722.GA28472@nowhere> <495AC45D.8010102@kernel.org> <20081231014747.GB28472@nowhere> <20081231081458.GB12942@elte.hu> <3f9a31f40812310040y27c39b87v456ae38e46031624@mail.gmail.com> <20081231084420.GA13665@elte.hu> <1230716702.24316.3.camel@jaswinder.satnam> <20081231141248.GA5748@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231141248.GA5748@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Dec 31, 2008 at 03:15:02PM +0530, Jaswinder Singh Rajput wrote:
> > On Wed, 2008-12-31 at 09:44 +0100, Ingo Molnar wrote:
> > > * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
> > > 
> > > > Hello Ingo,
> > > > 
> > > > On Wed, Dec 31, 2008 at 1:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > > > >
> > > > > Could you check whether latest tip/master is still OK? I had these
> > > > > problems resolved locally (but forgot to push them out), and now i also
> > > > > had to do a few conflict resolutions with latest -git, hopefully i have
> > > > > not lost hpa's fixes ...
> > > > >
> > > > 
> > > > With latest/tip, I am still getting error on X86_32 machines :
> > > > 
> > > >   CC      mm/slab.o
> > > > mm/slab.c:105:31: error: tracing/kmemtrace.h: No such file or directory
> > > > make[1]: *** [mm/slab.o] Error 1
> > > > make: *** [mm] Error 2
> > > 
> > > ok, pushed out a new one - does it build fine now?
> > > 
> > 
> > Yes, Now it looks better, thanks :-)
> > 
> > I think it will be better to move trace/XXX below to linux/XXX to aviod
> > confusion and some minor cleanup in trace folder, do you thinks this is
> > useful :
> 
> 
> I'm not sure. The tracer's headers are small files that are only 
> included in very few c files. They should be rarely included for general 
> uses.

yeah - it's also good to have a central repository of all tracepoints in 
one directory. The header guard fixes look correct nevertheless:

> > ---
> >  include/trace/boot.h      |    6 +++---
> >  include/trace/kmemtrace.h |    6 +++---
> >  mm/slab.c                 |    2 +-
> >  3 files changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/trace/boot.h b/include/trace/boot.h
> > index 088ea08..21dcce3 100644
> > --- a/include/trace/boot.h
> > +++ b/include/trace/boot.h
> > @@ -1,5 +1,5 @@
> > -#ifndef _LINUX_TRACE_BOOT_H
> > -#define _LINUX_TRACE_BOOT_H
> > +#ifndef _TRACE_BOOT_H
> > +#define _TRACE_BOOT_H
> >  
> >  #include <linux/module.h>
> >  #include <linux/kallsyms.h>
> > @@ -57,4 +57,4 @@ static inline void enable_boot_trace(void) { }
> >  static inline void disable_boot_trace(void) { }
> >  #endif /* CONFIG_BOOT_TRACER */
> >  
> > -#endif /* __LINUX_TRACE_BOOT_H */
> > +#endif /* _TRACE_BOOT_H */
> > diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
> > index ad8b785..4ea5300 100644
> > --- a/include/trace/kmemtrace.h
> > +++ b/include/trace/kmemtrace.h
> > @@ -4,8 +4,8 @@
> >   * This file is released under GPL version 2.
> >   */
> >  
> > -#ifndef _LINUX_KMEMTRACE_H
> > -#define _LINUX_KMEMTRACE_H
> > +#ifndef _TRACE_KMEMTRACE_H
> > +#define _TRACE_KMEMTRACE_H
> >  
> >  #ifdef __KERNEL__
> >  
> > @@ -71,5 +71,5 @@ static inline void kmemtrace_mark_alloc(enum kmemtrace_type_id type_id,
> >  
> >  #endif /* __KERNEL__ */
> >  
> > -#endif /* _LINUX_KMEMTRACE_H */
> > +#endif /* _TRACE_KMEMTRACE_H */

	Ingo

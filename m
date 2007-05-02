Return-Path: <linux-kernel-owner+w=401wt.eu-S1767202AbXEBXLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767202AbXEBXLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767201AbXEBXLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:11:08 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:49153 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767195AbXEBXLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:11:06 -0400
Date: Wed, 2 May 2007 19:11:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070502231104.GA26045@Krystal>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502172934.GA17782@infradead.org> <20070502203627.GA18733@Krystal> <20070502135336.6d6d3569.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070502135336.6d6d3569.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 19:02:30 up 89 days, 13:09,  5 users,  load average: 1.51, 1.18, 1.18
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Wed, 2 May 2007 16:36:27 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Christoph Hellwig (hch@infradead.org) wrote:
> > > On Wed, May 02, 2007 at 09:47:07AM -0700, Andrew Morton wrote:
> > > > > That doesn't constitute using it.
> > > > 
> > > > Andi, there was a huge amount of discussion about all this in September last
> > > > year (subjects: *markers* and *LTTng*). The outcome of all that was, I
> > > > believe, that the kernel should have a static marker infrastructure.
> > > 
> > > Only when it's actually useable.  A prerequisite for merging it is
> > > having an actual trace transport infrastructure aswell as a few actually
> > > useful tracing modules in the kernel tree.
> > > 
> > > Let this count as a vote to merge the markers once we have the infrastructure
> > > above ready, it'll be very useful then.
> > 
> > Hi Christoph,
> > 
> > The idea is the following : either we integrate the infrastructure for
> > instrumentation / data serialization / buffer management / extraction of
> > data to user space in multiple different steps, which makes code review
> > easier for you guys, or we bring the main pieces of the LTTng project
> > altogether with the Linux Kernel Markers, which would result in a bigger
> > change.
> > 
> > Based on the premise that discussing about logically distinct pieces of
> > infrastructure is easier and can be done more thoroughly when done
> > separately, we decided to submit the markers first, with the other
> > pieces planned in a near future.
> > 
> > I agree that it would be very useful to have the full tracing stack
> > available in the Linux kernel, but we inevitably face the argument :
> > "this change is too big" if we submit all LTTng modules at once or
> > the argument : "we want the whole tracing stack, not just part of it"
> > if we don't.
> > 
> > This is why we chose to push the tracing infrastructure chunk by chunk :
> > to make code review and criticism more efficient.
> > 
> 
> I didn't know that this was the plan.
> 
> The problem I have with this is that once we've merged one part, we're
> committed to merging the other parts even though we haven't seen them yet.
> 
> What happens if there's a revolt over the next set of patches?  Do we
> remove the core markers patches again?  We end up in a cant-go-forward,
> cant-go-backward situation.
> 
> I thought the existing code was useful as-is for several projects, without
> requiring additional patching to core kernel.  If such additional patching
> _is_ needed to make the markers code useful then I agree that we should
> continue to buffer the markers code in -mm until the
> use-markers-for-something patches have been eyeballed.
> 

My statement was probably not clear enough. The actual marker code is
useful as-is without any further kernel patching required : SystemTAP is
an example where they use external modules to load probes that can
connect either to markers or through kprobes. LTTng, in its current state,
has a mostly modular core that also uses the markers.

Although some, like Christoph and myself, think that it would benefit to
the kernel community to have a common infrastructure for more than just
markers (meaning common serialization and buffering mechanism), it does
not change the fact that the markers, being in mainline, are usable by
projects through additional kernel modules.

If we are looking at current "potential users" that are already in
mainline, we could change blktrace to make it use the markers.

Mathieu


> In which case we have:
> 
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
> atomich-complete-atomic_long-operations-in-asm-generic.patch
> atomich-i386-type-safety-fix.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
> atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
> local_t-architecture-independant-extension.patch
> local_t-alpha-extension.patch
> local_t-i386-extension.patch
> local_t-ia64-extension.patch
> local_t-mips-extension.patch
> local_t-parisc-cleanup.patch
> local_t-powerpc-extension.patch
> local_t-sparc64-cleanup.patch
> local_t-x86_64-extension.patch
> 
>   For 2.6.22
> 
> linux-kernel-markers-kconfig-menus.patch
> linux-kernel-markers-architecture-independant-code.patch
> linux-kernel-markers-powerpc-optimization.patch
> linux-kernel-markers-i386-optimization.patch
> markers-add-instrumentation-markers-menus-to-avr32.patch
> linux-kernel-markers-non-optimized-architectures.patch
> markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
> linux-kernel-markers-documentation.patch
> #
> markers-define-the-linker-macro-extra_rwdata.patch
> markers-use-extra_rwdata-in-architectures.patch
> #
> some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
> no-longer-include-asm-kdebugh.patch
> 
>   Hold.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

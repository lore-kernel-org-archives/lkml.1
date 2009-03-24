Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZCXRw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZCXRw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZCXRuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:50:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34314 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZCXRuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:50:19 -0400
Date: Tue, 24 Mar 2009 18:48:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: 2.6.30 Xen merge plan (what's in xen.git)
Message-ID: <20090324174859.GB31117@elte.hu>
References: <49C915A3.3020809@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C915A3.3020809@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo, Linus,
>
> I have several topic branches which I'd like to merge in this 
> merge window.  They fall into two classes: those which make 
> significant changes to arch/x86 files, and those which just touch 
> Xen-specific files.
>
> The x86-touching ones should definitely go via tip.git, just to 
> keep things sane and orderly.
>
> How should we handle the rest?  Should I send them directly to 
> Linus, or put them via x86.git too?  Either way, they'll generally 
> need to go after the non-Xen changes.
>
> (I'll post full pull-requests with diffstats as followups to this mail.)
>
> All branches in git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git
>
>
> Branches which mostly or entirely Xen (only trivial non-Xen changes):
>
> push2/xen/core
>
>    Updates to existing Xen support, features, optimisations, etc.
>
> push2/xen/control
>
>    A set of usermode interfaces for Xen (/sys/hypervisor, /dev/evtchn,
>    updates to xenbus and xenfs)

Will take a look.

> push2/xen/dom0/core
>
>    Core set of changes to add Xen dom0 functionality.  (Mostly
>    Xen-only, but adds a new Xen mtrr driver.)

I suspect this makes limited sense without the arch dom0 changes so 
they should go with this bucket:

> Branches with non-trivial non-Xen changes:
>
> push2/x86/paravirt
>
>    Allow preemption while doing a lazy mmu update.

That's probably OK, just a bit late. If Thomas signs off on them 
then i guess it might be OK later in the window - he's the one who 
was struggling with paravirt lazy mmu fallout in the past. Thomas?

> push2/xen/dom0/apic
>
>    Changes to hook the Xen dom0 apic model into the standard platform
>    apic code.  HPA reviewed and OKed this.
>
> push2/xen/dom0/pci
>
>    Add a Xen pci driver and dma_ops implementations.  Small changes to
>    x86 pci+swiotlb code to add some function calls.
>
> push2/xen/dom0/agp
>
>    Change the AGP driver to allocate its memory using the
>    pci_alloc_coherent to get guaranteed physically contiguous memory,
>    and use proper phys<->bus functions so that Xen's pseudo-phys <->
>    machine mappings are handled properly.

hpa wanted dom0 changes in some cleaner fashion - he knows the 
details. (he'll be back in a few days)

	Ingo

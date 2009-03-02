Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbZCBGiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbZCBGiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 01:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZCBGiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 01:38:05 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:41816 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754248AbZCBGiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 01:38:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=ziVb4prefLUZ84Jdwg32w5GbL+Ao3lTR9fWAUR7OcS6KfpGYopp61cDjCCQgwcCWBqP/PqTmytkhFHvVDW7qIs8WofBhCILMSZtSnyOFDbbxUskjo+VB4hXyWw30/JXlTJAtU71Pe0U0qs4D5eMTb37lVQcWIZ9/aBkH9Nf+9dc=  ;
X-YMail-OSG: s16N9l4VM1n0JlhtgKt9B4xlQm3sTfBiJGDV4ViIoMSVAkJ6tBxxuSl8cgcqhumZ0aNLlCj362uMV0EEjOSlBuODSVBKVRZGfJtjwGN.9UAYEdmhZg6dpB_ZPojUBxRy5T9JItUvcCgl5M86rjTKDi50ayygRh2TL8geZmZBugAv_5diuyEF5wznM6R41raU.NxCm2GS17zHPzTYoykaowP_zs2H
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] xen: core dom0 support
Date: Mon, 2 Mar 2009 17:37:24 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <200902282309.07576.nickpiggin@yahoo.com.au> <49AB19E1.4050604@goop.org>
In-Reply-To: <49AB19E1.4050604@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903021737.24903.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009 10:27:29 Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > On Saturday 28 February 2009 17:52:24 Jeremy Fitzhardinge wrote:
> >> Andrew Morton wrote:
> >>> I hate to be the one to say it, but we should sit down and work out
> >>> whether it is justifiable to merge any of this into Linux.  I think
> >>> it's still the case that the Xen technology is the "old" way and that
> >>> the world is moving off in the "new" direction, KVM?
> >>
> >> I don't think that's a particularly useful way to look at it.  They're
> >> different approaches to the problem, and have different tradeoffs.
> >>
> >> The more important question is: are there real users for this stuff?
> >> Does not merging it cause more net disadvantage than merging it?
> >> Despite all the noise made about kvm in kernel circles, Xen has a large
> >> and growing installed base.  At the moment its all running on massive
> >> out-of-tree patches, which doesn't make anyone happy.  It's best that it
> >> be in the mainline kernel.  You know, like we argue for everything else.
> >
> > OTOH, there are good reasons not to duplicate functionality, and many
> > many times throughout the kernel history competing solutions have been
> > rejected even though the same arguments could be made about them.
> >
> > There have also been many times duplicate functionality has been merged,
> > although that does often start with the intention of eliminating
> > duplicate implementations and ends with pain. So I think Andrew's
> > question is pretty important.
>
> Those would be pertinent questions if I were suddenly popping up and
> saying "hey, let's add Xen support to the kernel!"  But Xen support has
> been in the kernel for well over a year now, and is widely used, enabled
> in distros, etc.  The patches I'm proposing here are not a whole new
> thing, they're part of the last 10% to fill out the kernel's support to
> make it actually useful.

As a guest, I guess it has been agreed that guest support for all
different hypervisors is "a good thing". dom0 is more like a piece
of the hypervisor itself, right?


> > The user issue aside -- that is a valid point -- you don't really touch
> > on the technical issues. What tradeoffs, and where Xen does better
> > than KVM would be interesting to know, can Xen tools and users ever be
> > migrated to KVM or vice versa (I know very little about this myself, so
> > I'm just an interested observer).
>
> OK, fair point, its probably time for another Xen architecture refresher
> post.

Thanks.


> There are two big architectural differences between Xen and KVM:
>
> Firstly, Xen has a separate hypervisor who's primary role is to context
> switch between the guest domains (virtual machines).   The hypervisor is
> relatively small and single purpose.  It doesn't, for example, contain
> any device drivers or even much knowledge of things like pci buses and
> their structure.  The domains themselves are more or less peers; some
> are more privileged than others, but from Xen's perspective they are
> more or less equivalent.  The first domain, dom0, is special because its
> started by Xen itself, and has some inherent initial privileges; its
> main job is to start other domains, and it also typically provides
> virtualized/multiplexed device services to other domains via a
> frontend/backend split driver structure.
>
> KVM, on the other hand, builds all the hypervisor stuff into the kernel
> itself, so you end up with a kernel which does all the normal kernel
> stuff, and can run virtual machines by making them look like slightly
> strange processes.
>
> Because Xen is dedicated to just running virtual machines, its internal
> architecture can be more heavily oriented towards that task, which
> affects things from how its scheduler works, its use and multiplexing of
> physical memory.  For example, Xen manages to use new hardware
> virtualization features pretty quickly, partly because it doesn't need
> to trade-off against normal kernel functions.  The clear distinction
> between the privileged hypervisor and the rest of the domains makes the
> security people happy as well.  Also, because Xen is small and fairly
> self-contained, there's quite a few hardware vendors shipping it burned
> into the firmware so that it really is the first thing to boot (many of
> instant-on features that laptops have are based on Xen).  Both HP and
> Dell, at least, are selling servers with Xen pre-installed in the firmware.

That would kind of seem like Xen has a better design to me, OTOH if it
needs this dom0 for most device drivers and things, then how much
difference is it really? Is KVM really disadvantaged by being a part of
the kernel?


> The second big difference is the use of paravirtualization.  Xen can
> securely virtualize a machine without needing any particular hardware
> support.  Xen works well on any post-P6 or any ia64 machine, without
> needing any virtualzation hardware support.  When Xen runs a kernel in
> paravirtualized mode, it runs the kernel in an unprivileged processor
> state.  The allows the hypervisor to vet all the guest kernel's
> privileged operations, which are carried out are either via hypercalls
> or by memory shared between each guest and Xen.
>
> By contrast, KVM relies on at least VT/SVM (and whatever the ia64 equiv
> is called) being available in the CPUs, and needs the most modern of
> hardware to get the best performance.
>
> Once important area of paravirtualization is that Xen guests directly
> use the processor's pagetables; there is no shadow pagetable or use of
> hardware pagetable nesting.  This means that a tlb miss is just a tlb
> miss, and happens at full processor performance.  This is possible
> because 1) pagetables are always read-only to the guest, and 2) the
> guest is responsible for looking up in a table to map guest-local pfns
> into machine-wide mfns before installing them in a pte.  Xen will check
> that any new mapping or pagetable satisfies all the rules, by checking
> that the writable reference count is 0, and that the domain owns (or has
> been allowed access to) any mfn it tries to install in a pagetable.

Xen's memory virtualization is pretty neat, I'll give it that. Is it
faster than KVM on a modern CPU? Would it be possible I wonder to make
a MMU virtualization layer for CPUs without support, using Xen's page
table protection methods, and have KVM use that? Or does that amount
to putting a significant amount of Xen hypervisor into the kernel..?


> The other interesting part of paravirtualization is the abstraction of
> interrupts into event channels.  Each domain has a bit-array of 1024
> bits which correspond to 1024 possible event channels.  An event channel
> can have one of several sources, such as a timer virtual interrupt, an
> inter-domain event, an inter-vcpu IPI, or mapped from a hardware
> interrupt.  We end up mapping the event channels back to irqs and they
> are delivered as normal interrupts as far as the rest of the kernel is
> concerned.
>
> The net result is that a paravirtualized Xen guest runs a very close to
> full speed.  Workloads which modify live pagetables a lot take a bit of
> a performance hit (since the pte updates have to trap to the hypervisor
> for validation), but in general this is not a huge deal.  Hardware
> support for nested pagetables is only just beginning to get close to
> getting performance parity, but with different tradeoffs (pagetable
> updates are cheap, but tlb misses are much more expensive, and hits
> consume more tlb entries).
>
> Xen can also make full use of whatever hardware virtualization features
> are available when running an "hvm" domain.  This is typically how you'd
> run Windows or other unmodified operating systems.
>
> All of this is stuff that's necessary to support any PV Xen domain, and
> has been in the kernel for a long time now.
>
>
> The additions I'm proposing now are those needed for a Xen domain to
> control the physical hardware, in order to provide virtual device
> support for other less-privileged domains.  These changes affect a few
> areas:
>
>     * interrupts: mapping a device interrupt into an event channel for
>       delivery to the domain with the device driver for that interrupt
>     * mappings: allowing direct hardware mapping of device memory into a
>       domain
>     * dma: making sure that hardware gets programmed with machine memory
>       address, nor virtual ones, and that pages are machine-contiguous
>       when expected
>
> Interrupts require a few hooks into the x86 APIC code, but the end
> result is that hardware interrupts are delivered via event channels, but
> then they're mapped back to irqs and delivered normally (they even end
> up with the same irq number as they'd usually have).
>
> Device mappings are fairly easy to arrange.  I'm using a software pte
> bit, _PAGE_IOMAP, to indicate that a mapping is a device mapping.  This
> bit is set by things like ioremap() and remap_pfn_range, and the Xen mmu
> code just uses the pfn in the pte as-is, rather than doing the normal
> pfn->mfn translation.
>
> DMA is handled via the normal DMA API, with some hooks to swiotlb to
> make sure that the memory underlying its pools is really DMA-ready (ie,
> is contiguous and low enough in machine memory).
>
> The changes I'm proposing may look a bit strange from a purely x86
> perspective, but they fit in relatively well because they're not all
> that different from what other architectures require, and so the
> kernel-wide infrastructure is mostly already in place.
>
>
> I hope that helps clarify what I'm trying to do here, and why Xen and
> KVM do have distinct roles to play.

Thanks, it's very informative to me and hopefully helps others with
the discussion (I don't pretend to be able to judge whether your dom0
patches should be merged or not! :)). I'll continue to read with
interest.

Thanks,
Nick


Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbZCXRSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbZCXRSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758340AbZCXRRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:17:31 -0400
Received: from gw.goop.org ([64.81.55.164]:46008 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762944AbZCXRR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:17:26 -0400
Message-ID: <49C915A3.3020809@goop.org>
Date: Tue, 24 Mar 2009 10:17:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: 2.6.30 Xen merge plan (what's in xen.git)
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Linus,

I have several topic branches which I'd like to merge in this merge 
window.  They fall into two classes: those which make significant 
changes to arch/x86 files, and those which just touch Xen-specific files.

The x86-touching ones should definitely go via tip.git, just to keep 
things sane and orderly.

How should we handle the rest?  Should I send them directly to Linus, or 
put them via x86.git too?  Either way, they'll generally need to go 
after the non-Xen changes.

(I'll post full pull-requests with diffstats as followups to this mail.)

All branches in git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git


Branches which mostly or entirely Xen (only trivial non-Xen changes):

push2/xen/core

    Updates to existing Xen support, features, optimisations, etc.

push2/xen/control

    A set of usermode interfaces for Xen (/sys/hypervisor, /dev/evtchn,
    updates to xenbus and xenfs)

push2/xen/dom0/core

    Core set of changes to add Xen dom0 functionality.  (Mostly
    Xen-only, but adds a new Xen mtrr driver.)


Branches with non-trivial non-Xen changes:

push2/x86/paravirt

    Allow preemption while doing a lazy mmu update.

push2/xen/dom0/apic

    Changes to hook the Xen dom0 apic model into the standard platform
    apic code.  HPA reviewed and OKed this.

push2/xen/dom0/pci

    Add a Xen pci driver and dma_ops implementations.  Small changes to
    x86 pci+swiotlb code to add some function calls.

push2/xen/dom0/agp

    Change the AGP driver to allocate its memory using the
    pci_alloc_coherent to get guaranteed physically contiguous memory,
    and use proper phys<->bus functions so that Xen's pseudo-phys <->
    machine mappings are handled properly.



Thanks,
    J

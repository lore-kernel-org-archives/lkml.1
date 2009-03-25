Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZCYVXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZCYVXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZCYVWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:22:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56788 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbZCYVWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:22:49 -0400
Date: Wed, 25 Mar 2009 22:21:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Yu, Fenghua" <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "'Andrew Lutomirski'" <amluto@gmail.com>,
       "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "'kyle@redhat.com'" <kyle@redhat.com>,
       "'mgross@linux.intel.com'" <mgross@linux.intel.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>
Subject: Re: [patch 0/2] Intel IOMMU Suspend/Resume Support
Message-ID: <20090325212158.GA11503@elte.hu>
References: <20090325184548.012018000@intel.com> <cb0375e10903251353r367294d1ra00226e030594a32@mail.gmail.com> <A6AD88C3F2289247BE726C37303E1EB8A056D45A@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8A056D45A@orsmsx505.amr.corp.intel.com>
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


* Yu, Fenghua <fenghua.yu@intel.com> wrote:

> >Subject: Re: [patch 0/2] Intel IOMMU Suspend/Resume Support
> >
> >It looks like patch 1 calls dmar_reenable_qi but patch 2 defines it.
> >
> >In 2.6.29, there's no dmar_disable_qi that I can see.  Can you respin
> >these against something a little less scary than -tip during a merge
> >window?  (Especially since -stable will need this soon.)
> >
> 
> dmar_disable_qi() is defined in tip tree already. This patch set 
> is based on the tip tree. I do have another version of the patch 
> set which is based on 2.6.29.
> 
> Ingo,
> 
> Do you think which tree this patch set should based on?

yes, dmar_disable_qi() was part of the x2apic fix patches (for 
various crashes and hangs) from Suresh, merged by hpa, and they are 
queued up for 2.6.30:

ce4e240: x86: add x2apic_wrmsr_fence() to x2apic flush tlb paths
fa4b57c: x86, dmar: use atomic allocations for QI and Intr-remapping init
68a8ca5: x86: fix broken irq migration logic while cleaning up multiple vectors
05c3dc2: x86, ioapic: Fix non atomic allocation with interrupts disabled
29b61be: x86, x2apic: cleanup ifdef CONFIG_INTR_REMAP in io_apic code
0280f7c: x86, x2apic: cleanup the IO-APIC level migration with interrupt-remapping
cf6567f: x86, x2apic: fix clear_local_APIC() in the presence of x2apic
7c6d9f9: x86, x2apic: use virtual wire A mode in disable_IO_APIC() with interrupt-remapping
2e93456: x86, intr-remapping: fix free_irte() to clear all the IRTE entries
1531a6a: x86, dmar: start with sane state while enabling dma and interrupt-remapping
eba67e5: x86, dmar: routines for disabling queued invalidation and intr remapping
9d783ba: x86, x2apic: enable fault handling for intr-remapping
0ac2491: x86, dmar: move page fault handling code to dmar.c
4c5502b: x86, x2apic: fix lock ordering during IRQ migration
0ca0f16: Merge branches 'x86/apic', 'x86/asm', 'x86/cleanups', 'x86/debug', 'x86/kconfig', 'x86/mm', 'x86/ptrace', 'x86/setup' and 'x86/urgent'; commit 'v2.6.29-rc8' into x86/core

So it would be nice to have this based on -tip, to reduce conflicts 
- but it definitely needs David's review and acks. We can do a 
separate branch for this if needed.

	Ingo

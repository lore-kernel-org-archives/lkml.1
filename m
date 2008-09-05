Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYIEILP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYIEILP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYIEILD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:11:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47657 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbYIEILA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:11:00 -0400
Date: Fri, 5 Sep 2008 10:10:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch 1/5] x2apic: fix reserved APIC register accesses in
	print_local_APIC()
Message-ID: <20080905081042.GD12409@elte.hu>
References: <20080904000237.746216000@linux-os.sc.intel.com> <20080904110631.GC8668@elte.hu> <20080904175139.GN14481@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904175139.GN14481@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Thu, Sep 04, 2008 at 04:06:31AM -0700, Ingo Molnar wrote:
> > 
> > applied the following patches tip/irq/sparseirq:
> 
> Ingo, Shouldn't this go to tip/x86/x2apic ? Thanks.

normally yes - but this is a special case: there's existing overlap with 
other DMAR changes in irq/sparseirq (intr-remap and ioapic unification 
changes), so these followups have to go there too. Also, since they 
change the generic PCI code it's better they live in a generic topic to 
begin with. The full stack of pending changes is:

0f48966: dmar: fix dmar_parse_dev() devices_cnt error condition check
2283240: dmar: use list_for_each_entry_safe() in dmar_dev_scope_init()
3f1fdb3: dmar: initialize the return value in dmar_parse_dev()
f12c73e: dmar: fix using early fixmap mapping for DMAR table parsing
1cb1158: x64, x2apic/intr-remap: disable DMA-remapping if Interrupt-remapping is detected (temporary quirk)
2ae2101: x64, x2apic/intr-remap: Interrupt remapping infrastructure
fe962e9: x64, x2apic/intr-remap: Queued invalidation infrastructure (part of VT-d)
ad3ad3f: x64, x2apic/intr-remap: parse ioapic scope under vt-d structures
2d6b5f8: x64, x2apic/intr-remap: Fix the need for RMRR in the DMA-remapping detection
aaa9d1d: x64, x2apic/intr-remap: use CONFIG_DMAR for DMA-remapping specific code
1886e8a: x64, x2apic/intr-remap: code re-structuring, to be used by both DMA and Interrupt remapping
c42d9f3: x64, x2apic/intr-remap: fix the need for sequential array allocation of iommus
e61d98d: x64, x2apic/intr-remap: Intel vt-d, IOMMU code reorganization

Jesse, do you have any objections to this approach?

	Ingo

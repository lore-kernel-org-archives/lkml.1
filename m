Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbYGLFhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbYGLFhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 01:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYGLFhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 01:37:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33776 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbYGLFhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 01:37:40 -0400
Date: Sat, 12 Jul 2008 07:37:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
	x2apic support
Message-ID: <20080712053713.GA341@elte.hu>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710195320.GA23322@elte.hu> <20080710215617.GM1678@linux-os.sc.intel.com> <20080711102814.GA17938@elte.hu> <20080711200957.GA8173@elte.hu> <20080711203151.GU1678@linux-os.sc.intel.com> <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com> <20080711204521.GA15689@elte.hu> <20080711212418.GV1678@linux-os.sc.intel.com> <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > Yinghai, Can you please try the appended patch to see if it fixes 
> > your problem?

> works. it should be merged into the patch that introduce new 
> read_apic_id

ok, that came from the x86/uv branch - but in that form it was not 
affected, only tip/x2apic exposed the problem, right?

So i've rebased tip/x86/x2apic and moved Suresh's fix in front of the 
other patches, to make it all bisectable.

i have also applied your apic unification patches. This is how the topic 
layout looks like now:

Ingo Molnar (1):
      Merge branch 'x86/core' into x86/x2apic

Suresh Siddha (31):
      x64, x2apic/intr-remap: Interrupt-remapping and x2apic support, fix
      x64, x2apic/intr-remap: Intel vt-d, IOMMU code reorganization
      x64, x2apic/intr-remap: fix the need for sequential array allocation of iommus
      x64, x2apic/intr-remap: code re-structuring, to be used by both DMA and Interrupt remapping
      x64, x2apic/intr-remap: use CONFIG_DMAR for DMA-remapping specific code
      x64, x2apic/intr-remap: Fix the need for RMRR in the DMA-remapping detection
      x64, x2apic/intr-remap: parse ioapic scope under vt-d structures
      x64, x2apic/intr-remap: move IOMMU_WAIT_OP() macro to intel-iommu.h
      x64, x2apic/intr-remap: Queued invalidation infrastructure (part of VT-d)
      x64, x2apic/intr-remap: Interrupt remapping infrastructure
      x64, x2apic/intr-remap: routines managing Interrupt remapping table entries.
      x64, x2apic/intr-remap: generic irq migration support from process context
      x64, x2apic/intr-remap: 8259 specific mask/unmask routines
      x64, x2apic/intr-remap: ioapic routines which deal with initial io-apic RTE setup
      x64, x2apic/intr-remap: introduce read_apic_id() to genapic routines
      x64, x2apic/intr-remap: basic apic ops support
      x64, x2apic/intr-remap: cpuid bits for x2apic feature
      x64, x2apic/intr-remap: disable DMA-remapping if Interrupt-remapping is detected (temporary quirk)
      x64, x2apic/intr-remap: x2apic ops for x2apic mode support
      x64, x2apic/intr-remap: introcude self IPI to genapic routines
      x64, x2apic/intr-remap: x2apic cluster mode support
      x64, x2apic/intr-remap: setup init_apic_ldr for UV
      x64, x2apic/intr-remap: IO-APIC support for interrupt-remapping
      x64, x2apic/intr-remap: MSI and MSI-X support for interrupt remapping infrastructure
      x64, x2apic/intr-remap: add x2apic support, including enabling interrupt-remapping
      x64, x2apic/intr-remap: support for x2apic physical mode support
      x64, x2apic/intr-remap: introduce CONFIG_INTR_REMAP
      x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
      x2apic: uninline uv_init_apic_ldr()
      x2apic: xen64 paravirt basic apic ops
      x2apic: kernel-parameter documentation for "x2apic_phys"

Yinghai Lu (3):
      x86: let 32bit use apic_ops too
      x86: mach_apicdef.h need to include before smp.h
      x86: make read_apic_id return final apicid

	Ingo

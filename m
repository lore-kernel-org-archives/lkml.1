Return-Path: <linux-kernel-owner+w=401wt.eu-S933110AbZHDRRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110AbZHDRRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbZHDRRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:17:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:63470 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932864AbZHDRRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,322,1246863600"; 
   d="scan'208";a="172208168"
Subject: Re: [PATCH] x86: use online_mask for x2apic target_cpus
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A785AFF.3050902@kernel.org>
References: <4A785AFF.3050902@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 04 Aug 2009 10:13:56 -0700
Message-Id: <1249406036.27006.10785.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 08:59 -0700, Yinghai Lu wrote:
> found one system with x2apic report:
> [  302.859446] igbvf 0000:81:10.4: enabling device (0000 -> 0002)
> [  302.874369] igbvf 0000:81:10.4: using 64bit DMA mask
> [  302.879023] igbvf 0000:81:10.4: using 64bit consistent DMA mask
> [  302.894386] igbvf 0000:81:10.4: enabling bus mastering
> [  302.898171] igbvf 0000:81:10.4: setting latency timer to 64
> [  302.914050] reserve_memtype added 0xefb08000-0xefb0c000, track uncached-minus, req uncached-minus, ret uncached-minus
> [  302.933839] reserve_memtype added 0xefb28000-0xefb29000, track uncached-minus, req uncached-minus, ret uncached-minus
> [  302.940367]   alloc irq_desc for 265 on node 4
> [  302.956874]   alloc kstat_irqs on node 4
> [  302.959452] alloc irq_2_iommu on node 0
> [  302.974328] igbvf 0000:81:10.4: irq 265 for MSI/MSI-X
> [  302.977778]   alloc irq_desc for 266 on node 4
> [  302.980347]   alloc kstat_irqs on node 4
> [  302.995312] free_memtype request 0xefb28000-0xefb29000
> [  302.998816] igbvf 0000:81:10.4: Failed to initialize MSI-X interrupts.
> 
> it turns out that when trying to enable msi-x.
> __assign_irq_vector(new, cfg_new, apic->target_cpus()) can not get vector
> because for x2apic target-cpus return cpumask_of(0)
> 
> update that to online_mask like xapic.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>


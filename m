Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZDDJVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZDDJVo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 05:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbZDDJVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 05:21:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:52930 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbZDDJVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 05:21:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,323,1235980800"; 
   d="scan'208";a="444984474"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'David Woodhouse'" <dwmw2@infradead.org>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'IOMMU'" <iommu@lists.linux-foundation.org>,
       "'LKML'" <linux-kernel@vger.kernel.org>
Date: Sat, 4 Apr 2009 17:21:26 +0800
Subject: RE: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
Thread-Topic: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
Thread-Index: Acm1Besrc3D7GBM6TdqEu2MDGfXs9gAAJUFQ
Message-ID: <715D42877B251141A38726ABF5CABF2C01A2F7C442@pdsmsx503.ccr.corp.intel.com>
References: <715D42877B251141A38726ABF5CABF2C01A2F7C3A7@pdsmsx503.ccr.corp.intel.com>
	 <1238781474.27006.7866.camel@localhost.localdomain>
	 <715D42877B251141A38726ABF5CABF2C01A2F7C435@pdsmsx503.ccr.corp.intel.com>
	 <1238833738.3560.14.camel@macbook.infradead.org>
	 <715D42877B251141A38726ABF5CABF2C01A2F7C440@pdsmsx503.ccr.corp.intel.com>
	 <1238836040.3560.17.camel@macbook.infradead.org>
 <1238836532.3560.19.camel@macbook.infradead.org>
In-Reply-To: <1238836532.3560.19.camel@macbook.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Sat, 2009-04-04 at 10:07 +0100, David Woodhouse wrote:
>> On Sat, 2009-04-04 at 16:48 +0800, Han, Weidong wrote:
>>> On linux head, I cannot find EIM_32BIT_APIC_ID in apic.c. I suspect
>>> iommu-2.6.git doesn't sync up with linux head on apic.c. I also
>>> fixed a bug which causes system hang due to queue invalidation is
>>> disabled when enable interrupt remapping. I will resend the
>>> patches. Do you want patches based on linux head or your
>>> iommu-2.6.git? BTW, I pull iommu-2.6.git very slow due to office
>>> proxy. But I can do it if you want.
>> 
>> The conflict is with Fenghua's suspend/resume patches:
>> http://git.infradead.org/iommu-2.6.git?a=commitdiff;h=b24696bc5
>> 
>> A simpler build fix is just to move the definitions of 
>> EIM_8BIT_APIC_ID and  EIM_32BIT_APIC_ID  outside #ifdef
>> CONFIG_X86_X2APIC. I'll try that and see if it boots.
> 
> ... which it doesn't. Same failure mode (the faults are normal; crappy
> BIOS lacks RMRRs):
> 
> [   34.061991] DMAR:DRHD (flags: 0x00000001)base: 0x00000000fe710000
> [   34.068076] DMAR:RMRR base: 0x00000000000e9000 end:
> 0x00000000000e9fff [   34.074592] DMAR:RMRR base: 0x00000000000ea000
> end: 0x00000000000eafff [   34.081105] DMAR:RMRR base:
> 0x00000000000eb000 end: 0x00000000000ebfff [   34.087618] DMAR:RMRR
> base: 0x00000000000e6000 end: 0x00000000000e6fff [   34.094131]
> DMAR:RMRR base: 0x00000000000e7000 end: 0x00000000000e7fff [  
> 34.100644] DMAR:RMRR base: 0x00000000000e8000 end: 0x00000000000e8fff
> [   34.107157] DMAR:Unknown DMAR structure type [   34.111413] IOAPIC
> id 8 under DRHD base 0xfe710000 [   34.116220] DRHD: handling fault
> status reg 2 [   34.120567] DMAR:[DMA Read] Request device [00:1a.2]
> fault addr ec000 [   34.120568] DMAR:[fault reason 06] PTE Read
> access is not set [   34.133298] DMAR:[DMA Read] Request device
> [00:1d.1] fault addr ec000 [   34.133298] DMAR:[fault reason 06] PTE
> Read access is not set [   34.145547] DMAR:[DMA Read] Request device
> [00:1a.1] fault addr ec000 [   34.145548] DMAR:[fault reason 06] PTE
> Read access is not set [   34.157796] DMAR:[DMA Read] Request device
> [00:1d.0] fault addr ec000 [   34.157796] DMAR:[fault reason 06] PTE
> Read access is not set [   34.170045] DMAR:[DMA Read] Request device
> [00:1a.0] fault addr ec000 [   34.170045] DMAR:[fault reason 06] PTE
> Read access is not set [   34.182294] DMAR:[DMA Read] Request device
> [00:1d.2] fault addr ec000 [   34.182295] DMAR:[fault reason 06] PTE
> Read access is not set [   34.194546] IOMMU 0xfe710000: using Queued
> invalidation 


Following patch fixes it. I tested it with different combinations, it works fine for me. pls try on your side. 


Subject: [PATCH] x86, dmar: check if it's initialized before disable queue invalidation

If queue invalidation is disabled after it's already initialized,
dmar_enable_qi won't re-enable it due to iommu->qi is allocated.
It may result in system hang when use queue invalidation. Add this
check to avoid this case.

Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 drivers/pci/intr_remapping.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index b041a40..5eb72e0 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -502,6 +502,13 @@ int __init enable_intr_remapping(int eim)
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
 
+		/* 
+		 * If the queued invalidation is already initialized,
+		 * shouldn't disable it.
+		 */
+		if (iommu->qi)
+			continue;
+
 		/*
 		 * Clear previous faults.
 		 */
-- 
1.6.0.4


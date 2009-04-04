Return-Path: <linux-kernel-owner+w=401wt.eu-S1761692AbZDDDiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761692AbZDDDiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 23:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbZDDDiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 23:38:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:11491 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764AbZDDDiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 23:38:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,322,1235980800"; 
   d="scan'208";a="503519522"
From: "Han, Weidong" <weidong.han@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       IOMMU <iommu@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Sat, 4 Apr 2009 11:37:56 +0800
Subject: RE: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
Thread-Topic: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
Thread-Index: Acm0hdgEU6/gdZPSTz6ULPtHNvJMDgAS/D+w
Message-ID: <715D42877B251141A38726ABF5CABF2C01A2F7C435@pdsmsx503.ccr.corp.intel.com>
References: <715D42877B251141A38726ABF5CABF2C01A2F7C3A7@pdsmsx503.ccr.corp.intel.com>
 <1238781474.27006.7866.camel@localhost.localdomain>
In-Reply-To: <1238781474.27006.7866.camel@localhost.localdomain>
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

Siddha, Suresh B wrote:
> On Fri, 2009-04-03 at 02:15 -0700, Han, Weidong wrote:
>> 
>> -#ifdef CONFIG_INTR_REMAP
>> +#ifdef CONFIG_X86_X2APIC
> 
> Weidong, Can we also fix these config options?
> 
> Today, selecting CONFIG_INTR_REMAP automatically selects
> CONFIG_X86_X2APIC. It should be the other way round.
> 
> i.e., turning on CONFIG_X86_X2APIC should automatically enable
> CONFIG_INTR_REMAP and just enabling CONFIG_INTR_REMAP shouldn't enable
> CONFIG_X86_X2APIC.
> 
> Also please make sure that the code compiles (and works :)) in
> different combinations of these config settings.


Thanks for your reminder. Following patch changes the config options selection. The code can compiles in different combinations.


Subject: [PATCH] Change X2APIC and INTR_REMAP config selection

Currently, selecting CONFIG_INTR_REMAP automatically selects
CONFIG_X86_X2APIC. It should be the other way round. i.e. selecting
CONFIG_X86_X2APIC automatically enables CONFIG_INTR_REMAP, but
selecting CONFIG_INTR_REMAP won't enable CONFIG_X86_X2APIC.

Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5696cec..0e522a4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -251,6 +251,7 @@ config SMP
 config X86_X2APIC
 	bool "Support x2apic"
 	depends on X86_LOCAL_APIC && X86_64
+	select INTR_REMAP
 	---help---
 	  This enables x2apic support on CPUs that have this feature.
 
@@ -1879,7 +1880,6 @@ config DMAR_FLOPPY_WA
 config INTR_REMAP
 	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
 	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
-	select X86_X2APIC
 	---help---
 	  Supports Interrupt remapping for IO-APIC and MSI devices.
 	  To use x2apic mode in the CPU's which support x2APIC enhancements or
-- 
1.6.0.4



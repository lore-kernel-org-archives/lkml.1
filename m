Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbXJWRmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbXJWRmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbXJWRmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:42:23 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:38559 "EHLO
	mail124-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753801AbXJWRmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:42:22 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 3/4] x86 gart: make some variables and functions static
Date: Tue, 23 Oct 2007 19:41:32 +0200
Message-ID: <11931612934125-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11931612933917-git-send-email-joerg.roedel@amd.com>
References: <11931612933917-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 23 Oct 2007 17:41:33.0759 (UTC)
 FILETIME=[F3FC94F0:01C8159B]
MIME-Version: 1.0
X-WSS-ID: 6B00EDE00QK8100-03-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes some functions and variables static in pci-gart_64.c which are
not used somewhere else.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 0e72abf..7097ef8 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -36,11 +36,11 @@
 #include <asm/dma.h>
 #include <asm/k8.h>
 
-unsigned long iommu_bus_base;	/* GART remapping area (physical) */
+static unsigned long iommu_bus_base;	/* GART remapping area (physical) */
 static unsigned long iommu_size; 	/* size of remapping area bytes */
 static unsigned long iommu_pages;	/* .. and in pages */
 
-u32 *iommu_gatt_base; 		/* Remapping table */
+static u32 *iommu_gatt_base; 		/* Remapping table */
 
 /* If this is disabled the IOMMU will use an optimized flushing strategy
    of only flushing when an mapping is reused. With it true the GART is flushed 
@@ -135,8 +135,8 @@ static void flush_gart(void)
 /* Debugging aid for drivers that don't free their IOMMU tables */
 static void **iommu_leak_tab; 
 static int leak_trace;
-int iommu_leak_pages = 20; 
-void dump_leak(void)
+static int iommu_leak_pages = 20;
+static void dump_leak(void)
 {
 	int i;
 	static int dump; 
-- 
1.5.2.5




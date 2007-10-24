Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbXJXKvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbXJXKvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbXJXKuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:50:14 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:31074 "EHLO
	mail63-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185AbXJXKuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:50:09 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 3/4] x86 gart: make some variables and functions static
Date: Wed, 24 Oct 2007 12:49:49 +0200
Message-ID: <11932229904109-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11932229902428-git-send-email-joerg.roedel@amd.com>
References: <11932229902428-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Oct 2007 10:49:50.0915 (UTC)
 FILETIME=[9A5B7930:01C8162B]
MIME-Version: 1.0
X-WSS-ID: 6B01FCDE2IW68030-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes some functions and variables static in pci-gart_64.c which are
not used somewhere else.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
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




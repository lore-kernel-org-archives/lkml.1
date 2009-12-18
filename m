Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbZLRULY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbZLRULY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbZLRULP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:11:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:55350 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640AbZLRULN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:11:13 -0500
Message-ID: <4B2BE189.9060708@kernel.org>
Date: Fri, 18 Dec 2009 12:09:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 4/7] x86/pci: use u64 instead of size_t in amd_bus.c -v2
References: <4B2BE063.4040704@kernel.org>
In-Reply-To: <4B2BE063.4040704@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


prepare to enable it for 32bit

-v2: remove not needed cast

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/amd_bus.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/pci/amd_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/amd_bus.c
+++ linux-2.6/arch/x86/pci/amd_bus.c
@@ -82,8 +82,8 @@ static int __init early_fill_mp_bus_info
 	struct pci_root_info *info;
 	u32 reg;
 	struct resource *res;
-	size_t start;
-	size_t end;
+	u64 start;
+	u64 end;
 	struct range range[RANGE_NUM];
 	u64 val;
 	u32 address;
@@ -173,7 +173,7 @@ static int __init early_fill_mp_bus_info
 
 		info = &pci_root_info[j];
 		printk(KERN_DEBUG "node %d link %d: io port [%llx, %llx]\n",
-		       node, link, (u64)start, (u64)end);
+		       node, link, start, end);
 
 		/* kernel only handle 16 bit only */
 		if (end > 0xffff)
@@ -207,7 +207,7 @@ static int __init early_fill_mp_bus_info
 	address = MSR_K8_TOP_MEM1;
 	rdmsrl(address, val);
 	end = (val & 0xffffff800000ULL);
-	printk(KERN_INFO "TOM: %016lx aka %ldM\n", end, end>>20);
+	printk(KERN_INFO "TOM: %016llx aka %lldM\n", end, end>>20);
 	if (end < (1ULL<<32))
 		subtract_range(range, RANGE_NUM, 0, end - 1);
 
@@ -246,7 +246,7 @@ static int __init early_fill_mp_bus_info
 		info = &pci_root_info[j];
 
 		printk(KERN_DEBUG "node %d link %d: mmio [%llx, %llx]",
-		       node, link, (u64)start, (u64)end);
+		       node, link, start, end);
 		/*
 		 * some sick allocation would have range overlap with fam10h
 		 * mmconf range, so need to update start and end.
@@ -272,13 +272,13 @@ static int __init early_fill_mp_bus_info
 				endx = fam10h_mmconf_start - 1;
 				update_res(info, start, endx, IORESOURCE_MEM, 0);
 				subtract_range(range, RANGE_NUM, start, endx);
-				printk(KERN_CONT " ==> [%llx, %llx]", (u64)start, endx);
+				printk(KERN_CONT " ==> [%llx, %llx]", start, endx);
 				start = fam10h_mmconf_end + 1;
 				changed = 1;
 			}
 			if (changed) {
 				if (start <= end) {
-					printk(KERN_CONT " %s [%llx, %llx]", endx?"and":"==>", (u64)start, (u64)end);
+					printk(KERN_CONT " %s [%llx, %llx]", endx?"and":"==>", start, end);
 				} else {
 					printk(KERN_CONT "%s\n", endx?"":" ==> none");
 					continue;
@@ -301,7 +301,7 @@ static int __init early_fill_mp_bus_info
 		address = MSR_K8_TOP_MEM2;
 		rdmsrl(address, val);
 		end = (val & 0xffffff800000ULL);
-		printk(KERN_INFO "TOM2: %016lx aka %ldM\n", end, end>>20);
+		printk(KERN_INFO "TOM2: %016llx aka %lldM\n", end, end>>20);
 		subtract_range(range, RANGE_NUM, 1ULL<<32, end - 1);
 	}
 


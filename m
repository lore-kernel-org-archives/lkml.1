Return-Path: <linux-kernel-owner+w=401wt.eu-S932604AbZLRUK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbZLRUK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZLRUKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:10:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:55332 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbZLRUKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:10:52 -0500
Message-ID: <4B2BE181.5090406@kernel.org>
Date: Fri, 18 Dec 2009 12:09:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 2/7] x86/pci: use resource_size_t in update_res -v2
References: <4B2BE063.4040704@kernel.org>
In-Reply-To: <4B2BE063.4040704@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



prepare to enable 32bit intel and amd bus

v2: change __init to __devinit

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/bus_numa.c |   16 ++++++++--------
 arch/x86/pci/bus_numa.h |    4 ++--
 2 files changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/pci/bus_numa.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/bus_numa.c
+++ linux-2.6/arch/x86/pci/bus_numa.c
@@ -51,8 +51,8 @@ void x86_pci_root_bus_res_quirks(struct
 	}
 }
 
-void __devinit update_res(struct pci_root_info *info, size_t start,
-			      size_t end, unsigned long flags, int merge)
+void __devinit update_res(struct pci_root_info *info, resource_size_t start,
+			  resource_size_t end, unsigned long flags, int merge)
 {
 	int i;
 	struct resource *res;
@@ -65,20 +65,20 @@ void __devinit update_res(struct pci_roo
 
 	/* try to merge it with old one */
 	for (i = 0; i < info->res_num; i++) {
-		size_t final_start, final_end;
-		size_t common_start, common_end;
+		resource_size_t final_start, final_end;
+		resource_size_t common_start, common_end;
 
 		res = &info->res[i];
 		if (res->flags != flags)
 			continue;
 
-		common_start = max((size_t)res->start, start);
-		common_end = min((size_t)res->end, end);
+		common_start = max(res->start, start);
+		common_end = min(res->end, end);
 		if (common_start > common_end + 1)
 			continue;
 
-		final_start = min((size_t)res->start, start);
-		final_end = max((size_t)res->end, end);
+		final_start = min(res->start, start);
+		final_end = max(res->end, end);
 
 		res->start = final_start;
 		res->end = final_end;
Index: linux-2.6/arch/x86/pci/bus_numa.h
===================================================================
--- linux-2.6.orig/arch/x86/pci/bus_numa.h
+++ linux-2.6/arch/x86/pci/bus_numa.h
@@ -22,6 +22,6 @@ extern int pci_root_num;
 extern struct pci_root_info pci_root_info[PCI_ROOT_NR];
 extern int found_all_numa_early;
 
-extern void update_res(struct pci_root_info *info, size_t start,
-			      size_t end, unsigned long flags, int merge);
+extern void update_res(struct pci_root_info *info, resource_size_t start,
+		      resource_size_t end, unsigned long flags, int merge);
 #endif


Return-Path: <linux-kernel-owner+w=401wt.eu-S935023AbZLKXjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935023AbZLKXjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935010AbZLKXhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:37:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:57339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935002AbZLKXhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:37:12 -0500
Message-ID: <4B22D73A.2010307@kernel.org>
Date: Fri, 11 Dec 2009 15:35:22 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 3/7] x86/pci: use resource_size_t in update_res
References: <4B22D4DA.2000104@kernel.org>
In-Reply-To: <4B22D4DA.2000104@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



prepare to enable 32bit intel and amd bus

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
 
-void __init update_res(struct pci_root_info *info, size_t start,
-			      size_t end, unsigned long flags, int merge)
+void __init update_res(struct pci_root_info *info, resource_size_t start,
+		       resource_size_t end, unsigned long flags, int merge)
 {
 	int i;
 	struct resource *res;
@@ -65,20 +65,20 @@ void __init update_res(struct pci_root_i
 
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


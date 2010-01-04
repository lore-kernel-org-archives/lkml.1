Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392Ab0ADDNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0ADDNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380Ab0ADDNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:13:42 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56423 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0ADDHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:07:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sun, 03 Jan 2010 19:04:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/29] x86/pci: use resource_size_t in update_res
In-reply-to: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1262574307-17040-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare to enable 32bit intel and amd bus

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/bus_numa.c |   16 ++++++++--------
 arch/x86/pci/bus_numa.h |    4 ++--
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index f939d60..30f65ce 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -51,8 +51,8 @@ void x86_pci_root_bus_res_quirks(struct pci_bus *b)
 	}
 }
 
-void __devinit update_res(struct pci_root_info *info, size_t start,
-			      size_t end, unsigned long flags, int merge)
+void __devinit update_res(struct pci_root_info *info, resource_size_t start,
+			  resource_size_t end, unsigned long flags, int merge)
 {
 	int i;
 	struct resource *res;
@@ -65,20 +65,20 @@ void __devinit update_res(struct pci_root_info *info, size_t start,
 
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
diff --git a/arch/x86/pci/bus_numa.h b/arch/x86/pci/bus_numa.h
index adbc23f..374ecc5 100644
--- a/arch/x86/pci/bus_numa.h
+++ b/arch/x86/pci/bus_numa.h
@@ -22,6 +22,6 @@ extern int pci_root_num;
 extern struct pci_root_info pci_root_info[PCI_ROOT_NR];
 extern int found_all_numa_early;
 
-extern void update_res(struct pci_root_info *info, size_t start,
-			      size_t end, unsigned long flags, int merge);
+extern void update_res(struct pci_root_info *info, resource_size_t start,
+		      resource_size_t end, unsigned long flags, int merge);
 #endif
-- 
1.6.4.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S934352AbXKPCey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352AbXKPCey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763869AbXKPCem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:34:42 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35181 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517AbXKPCem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:34:42 -0500
Message-Id: <473D015E.4030908@mxs.nes.nec.co.jp>
Date: Fri, 16 Nov 2007 11:33:02 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, kexec-ml <kexec@lists.infradead.org>
Subject: [PATCH 1/5] Rename vmcoreinfo's macros returning the size
References: <473CFE14.3010400@mxs.nes.nec.co.jp>
In-Reply-To: <473CFE14.3010400@mxs.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


VMCOREINFO_SIZE() should be renamed VMCOREINFO_STRUCT_SIZE() since it's always
returning the size of the struct with a given name. This change would allow
VMCOREINFO_TYPEDEF_SIZE() to simply become VMCOREINFO_SIZE() since it need not
be used exclusively for typedefs.

This discussion is the following:
http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0582.html

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Acked-by: David Rientjes <rientjes@google.com>
---
diff -rpuN a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c	2007-11-14 15:50:10.000000000 +0900
+++ b/arch/ia64/kernel/machine_kexec.c	2007-11-14 15:50:36.000000000 +0900
@@ -135,7 +135,7 @@ void arch_crash_save_vmcoreinfo(void)
 
 	VMCOREINFO_SYMBOL(node_memblk);
 	VMCOREINFO_LENGTH(node_memblk, NR_NODE_MEMBLKS);
-	VMCOREINFO_SIZE(node_memblk_s);
+	VMCOREINFO_STRUCT_SIZE(node_memblk_s);
 	VMCOREINFO_OFFSET(node_memblk_s, start_paddr);
 	VMCOREINFO_OFFSET(node_memblk_s, size);
 #endif
diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
--- a/include/linux/kexec.h	2007-11-14 15:50:09.000000000 +0900
+++ b/include/linux/kexec.h	2007-11-14 15:50:36.000000000 +0900
@@ -131,10 +131,10 @@ unsigned long paddr_vmcoreinfo_note(void
 	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
 #define VMCOREINFO_SIZE(name) \
 	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
-			      (unsigned long)sizeof(struct name))
-#define VMCOREINFO_TYPEDEF_SIZE(name) \
-	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
 			      (unsigned long)sizeof(name))
+#define VMCOREINFO_STRUCT_SIZE(name) \
+	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
+			      (unsigned long)sizeof(struct name))
 #define VMCOREINFO_OFFSET(name, field) \
 	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
 			      (unsigned long)&(((struct name *)0)->field))
diff -rpuN a/kernel/kexec.c b/kernel/kexec.c
--- a/kernel/kexec.c	2007-11-14 15:50:09.000000000 +0900
+++ b/kernel/kexec.c	2007-11-14 15:50:36.000000000 +0900
@@ -1376,15 +1376,15 @@ static int __init crash_save_vmcoreinfo_
 #ifdef CONFIG_SPARSEMEM
 	VMCOREINFO_SYMBOL(mem_section);
 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
-	VMCOREINFO_SIZE(mem_section);
+	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
 #endif
-	VMCOREINFO_SIZE(page);
-	VMCOREINFO_SIZE(pglist_data);
-	VMCOREINFO_SIZE(zone);
-	VMCOREINFO_SIZE(free_area);
-	VMCOREINFO_SIZE(list_head);
-	VMCOREINFO_TYPEDEF_SIZE(nodemask_t);
+	VMCOREINFO_STRUCT_SIZE(page);
+	VMCOREINFO_STRUCT_SIZE(pglist_data);
+	VMCOREINFO_STRUCT_SIZE(zone);
+	VMCOREINFO_STRUCT_SIZE(free_area);
+	VMCOREINFO_STRUCT_SIZE(list_head);
+	VMCOREINFO_SIZE(nodemask_t);
 	VMCOREINFO_OFFSET(page, flags);
 	VMCOREINFO_OFFSET(page, _count);
 	VMCOREINFO_OFFSET(page, mapping);
_


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbXITFbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbXITFbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbXITFbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:31:25 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:44457 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbXITFbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:31:25 -0400
Message-Id: <46F2056E.6080601@mxs.nes.nec.co.jp>
Date: Thu, 20 Sep 2007 14:30:22 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>
Subject: [PATCH 5/4] [-mm patch] Rename macros returning the size.
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp>	<46E9F942.5070007@mxs.nes.nec.co.jp> <20070914190350.011cdadb.akpm@linux-foundation.org> <46F204FD.6040303@mxs.nes.nec.co.jp>
In-Reply-To: <46F204FD.6040303@mxs.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH 5/4] [-mm patch] Rename macros returning the size.
 The #define SIZE() should be renamed STRUCT_SIZE() since it's always 
 returning the size of the struct with a given name.  This would allow 
 TYPEDEF_SIZE() to simply become SIZE() since it need not be used 
 exclusively for typedefs. This idea is David Rientjes's.
 http://www.ussg.iu.edu/hypermail/linux/kernel/0709.1/1964.html

Thanks
Ken'ichi Ohmichi

---
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>

---
diff -rpuN a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c	2007-09-18 15:22:19.000000000 +0900
+++ b/arch/ia64/kernel/machine_kexec.c	2007-09-18 15:22:41.000000000 +0900
@@ -137,7 +137,7 @@ void arch_crash_save_vmcoreinfo(void)
 
 	VMCOREINFO_SYMBOL(node_memblk);
 	VMCOREINFO_LENGTH(node_memblk, NR_NODE_MEMBLKS);
-	VMCOREINFO_SIZE(node_memblk_s);
+	VMCOREINFO_STRUCT_SIZE(node_memblk_s);
 	VMCOREINFO_OFFSET(node_memblk_s, start_paddr);
 	VMCOREINFO_OFFSET(node_memblk_s, size);
 #endif
diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
--- a/include/linux/kexec.h	2007-09-18 15:22:19.000000000 +0900
+++ b/include/linux/kexec.h	2007-09-18 15:23:22.000000000 +0900
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
--- a/kernel/kexec.c	2007-09-18 15:22:19.000000000 +0900
+++ b/kernel/kexec.c	2007-09-18 15:22:41.000000000 +0900
@@ -1210,15 +1210,15 @@ static int __init crash_save_vmcoreinfo_
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

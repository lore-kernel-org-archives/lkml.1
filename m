Return-Path: <linux-kernel-owner+w=401wt.eu-S1762667AbXGJDPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762667AbXGJDPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759108AbXGJDOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:14:54 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013AbXGJDOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:14:53 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 09/33] Make definitions for struct e820entry and struct e820map consistent
Date: Mon,  9 Jul 2007 19:51:48 -0700
Message-Id: <11840368791603-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840367741994-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
Message-Id: <361d0a8b7b7ea9d41d0c25664b3e2b30fd99e329.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Make definitions for struct e820entry and struct e820map consistent
between i386 and x86-64.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/kernel/e820.c   |    2 +-
 include/asm-i386/e820.h   |   14 ++++++++------
 include/asm-x86_64/e820.h |    6 ++++--
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/i386/kernel/e820.c b/arch/i386/kernel/e820.c
index 9645bb5..fc822a4 100644
--- a/arch/i386/kernel/e820.c
+++ b/arch/i386/kernel/e820.c
@@ -734,7 +734,7 @@ void __init print_memory_map(char *who)
 		case E820_NVS:
 				printk("(ACPI NVS)\n");
 				break;
-		default:	printk("type %lu\n", e820.map[i].type);
+		default:	printk("type %u\n", e820.map[i].type);
 				break;
 		}
 	}
diff --git a/include/asm-i386/e820.h b/include/asm-i386/e820.h
index 096a2a8..c03290c 100644
--- a/include/asm-i386/e820.h
+++ b/include/asm-i386/e820.h
@@ -25,13 +25,15 @@
 
 #ifndef __ASSEMBLY__
 
+struct e820entry {
+	u64 addr;	/* start of memory segment */
+	u64 size;	/* size of memory segment */
+	u32 type;	/* type of memory segment */
+} __attribute__((packed));
+
 struct e820map {
-    int nr_map;
-    struct e820entry {
-	unsigned long long addr;	/* start of memory segment */
-	unsigned long long size;	/* size of memory segment */
-	unsigned long type;		/* type of memory segment */
-    } map[E820MAX];
+	u32 nr_map;
+	struct e820entry map[E820MAX];
 };
 
 extern struct e820map e820;
diff --git a/include/asm-x86_64/e820.h b/include/asm-x86_64/e820.h
index 6216fa3..15eb8e2 100644
--- a/include/asm-x86_64/e820.h
+++ b/include/asm-x86_64/e820.h
@@ -11,7 +11,9 @@
 #ifndef __E820_HEADER
 #define __E820_HEADER
 
-#include <linux/mmzone.h>
+#ifndef _SETUP
+# include <linux/mmzone.h>
+#endif
 
 #define E820MAP	0x2d0		/* our map */
 #define E820MAX	128		/* number of entries in E820MAP */
@@ -30,7 +32,7 @@ struct e820entry {
 } __attribute__((packed));
 
 struct e820map {
-    int nr_map;
+	u32 nr_map;
 	struct e820entry map[E820MAX];
 };
 
-- 
1.5.2.2


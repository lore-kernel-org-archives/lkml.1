Return-Path: <linux-kernel-owner+w=401wt.eu-S933128AbXGKTWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128AbXGKTWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932125AbXGKTT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:28 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38273 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765423AbXGKTT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:26 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 09/33] Make definitions for struct e820entry and struct e820map consistent
Date: Wed, 11 Jul 2007 12:18:34 -0700
Message-Id: <11841815403678-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815391923-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
 <11841815393975-git-send-email-hpa@zytor.com>
 <11841815393014-git-send-email-hpa@zytor.com>
 <1184181539416-git-send-email-hpa@zytor.com>
 <118418153972-git-send-email-hpa@zytor.com>
 <11841815391923-git-send-email-hpa@zytor.com>
Message-Id: <e6a39812b9f6930a943ec96de73f270cb07cc2c2.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Make definitions for struct e820entry and struct e820map
consistent between i386 and x86-64.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/kernel/e820.c   |    2 +-
 include/asm-i386/e820.h   |   14 ++++++++------
 include/asm-x86_64/e820.h |    4 +---
 3 files changed, 10 insertions(+), 10 deletions(-)

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
index 6216fa3..3486e70 100644
--- a/include/asm-x86_64/e820.h
+++ b/include/asm-x86_64/e820.h
@@ -11,8 +11,6 @@
 #ifndef __E820_HEADER
 #define __E820_HEADER
 
-#include <linux/mmzone.h>
-
 #define E820MAP	0x2d0		/* our map */
 #define E820MAX	128		/* number of entries in E820MAP */
 #define E820NR	0x1e8		/* # entries in E820MAP */
@@ -30,7 +28,7 @@ struct e820entry {
 } __attribute__((packed));
 
 struct e820map {
-    int nr_map;
+	u32 nr_map;
 	struct e820entry map[E820MAX];
 };
 
-- 
1.5.2.2


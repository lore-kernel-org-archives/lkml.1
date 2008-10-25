Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbYJYDar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbYJYDar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 23:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYJYDaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 23:30:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:22575 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYJYDaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 23:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lmRvjdjUotiHusR5rdLf2iYJQ/lmP50bjyV9nlSSADcM+XxAx91CPjAm2aumgoH/JU
         zVU/HYmUL3C0D528x2b65RQ15RdaUX6eK1PAzP/mXnjPVIxRWElihKcYDS1Nv538GcCL
         HdzeVVXmkYxnfnzYWdWU3RhdU3PeZnI8SdBrk=
From: Joe Damato <ice799@gmail.com>
To: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Damato <ice799@gmail.com>
Subject: [PATCH 01/12] x86: Cleanup x86 descriptors, remove a/b fields from structs
Date: Fri, 24 Oct 2008 20:15:21 -0700
Message-Id: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1224904532-9586-1-git-send-email-ice799@gmail.com>
References: <>
 <1224904532-9586-1-git-send-email-ice799@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the single descriptor struct into an IDT struct and a struct for ldt/gdt/tss. This was done because the fields in IDTs are not the same or in the same order as ldt/gdt/tss descriptors. More meaningful field names were added and the a/b fields were removed.

Signed-off-by: Joe Damato <ice799@gmail.com>
---
 include/asm-x86/desc_defs.h |   32 +++++++++++++-------------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index b881db6..68abda4 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -11,27 +11,21 @@
 
 #include <linux/types.h>
 
-/*
- * FIXME: Acessing the desc_struct through its fields is more elegant,
- * and should be the one valid thing to do. However, a lot of open code
- * still touches the a and b acessors, and doing this allow us to do it
- * incrementally. We keep the signature as a struct, rather than an union,
- * so we can get rid of it transparently in the future -- glommer
- */
+/* 8 byte idt gate descriptor */
+struct gate_struct {
+	u16 base0;
+	u16 seg_sel;
+	u8 reserved;
+	unsigned type: 4, zero: 1, dpl: 2, p: 1;
+	u16 base1;
+} __attribute__((packed));
+
 /* 8 byte segment descriptor */
 struct desc_struct {
-	union {
-		struct {
-			unsigned int a;
-			unsigned int b;
-		};
-		struct {
-			u16 limit0;
-			u16 base0;
-			unsigned base1: 8, type: 4, s: 1, dpl: 2, p: 1;
-			unsigned limit: 4, avl: 1, l: 1, d: 1, g: 1, base2: 8;
-		};
-	};
+	u16 limit0;
+	u16 base0;
+	unsigned base1: 8, type: 4, s: 1, dpl: 2, p: 1;
+	unsigned limit: 4, avl: 1, l: 1, d: 1, g: 1, base2: 8;
 } __attribute__((packed));
 
 enum {
-- 
1.5.4.3


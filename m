Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbZATNP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbZATNP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbZATNPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:15:49 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:20932 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbZATNPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:15:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Oqw9E9XtvpCT2lPUTkHklipGjKFdvEsFPqHrc51B6yqGnSKSQDfgA5a49l/gld9NKB
         vXCkP1+Vd+Y/ZJAug8UoVRNJAdJsUF66GTwRA7tPYl2S3fJ+u5PMkQLevYIrxQ6wQMKT
         idz7AK6kwn4wi2sSneMxwtT3pmhEJczjtCZMY=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 1/6] x86: Clean up gdt_page definition
Date: Tue, 20 Jan 2009 08:15:40 -0500
Message-Id: <1232457345-12366-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move 64-bit GDT to page-aligned section and clean up comment
formatting.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/cpu/common.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3887fcf..a8f0ded 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -63,23 +63,23 @@ cpumask_t cpu_sibling_setup_map;
 
 static struct cpu_dev *this_cpu __cpuinitdata;
 
+DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 #ifdef CONFIG_X86_64
-/* We need valid kernel segments for data and code in long mode too
- * IRET will check the segment types  kkeil 2000/10/28
- * Also sysret mandates a special GDT layout
- */
-/* The TLS descriptors are currently at a different place compared to i386.
-   Hopefully nobody expects them at a fixed place (Wine?) */
-DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
+	/*
+	 * We need valid kernel segments for data and code in long mode too
+	 * IRET will check the segment types  kkeil 2000/10/28
+	 * Also sysret mandates a special GDT layout
+	 *
+	 * The TLS descriptors are currently at a different place compared to i386.
+	 * Hopefully nobody expects them at a fixed place (Wine?)
+	 */
 	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
 	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00af9b00 } } },
 	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9300 } } },
 	[GDT_ENTRY_DEFAULT_USER32_CS] = { { { 0x0000ffff, 0x00cffb00 } } },
 	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
 	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
-} };
 #else
-DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
 	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9200 } } },
 	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00cffa00 } } },
@@ -112,8 +112,8 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 
 	[GDT_ENTRY_ESPFIX_SS] = { { { 0x00000000, 0x00c09200 } } },
 	[GDT_ENTRY_PERCPU] = { { { 0x00000000, 0x00000000 } } },
-} };
 #endif
+} };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
 #ifdef CONFIG_X86_32
-- 
1.6.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1763956AbZAUIr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763956AbZAUIr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbZAUIqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:46:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:38077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbZAUIqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:46:39 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] x86: clean up gdt_page definition
Date: Wed, 21 Jan 2009 17:46:10 +0900
Message-Id: <1232527578-1960-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232527578-1960-1-git-send-email-tj@kernel.org>
References: <1232527578-1960-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:46:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Impact: cleanup && more compact percpu area layout with future changes

Move 64-bit GDT to page-aligned section and clean up comment
formatting.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
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
1.6.0.2


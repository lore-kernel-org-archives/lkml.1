Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab0BTAh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:37:28 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51052 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab0BTAhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LgDNOpHQCtcNhcDuzpBuPy8DARJMAgk/1FXm07BlIYoCVtqG0/6EhrX4CwBNu3N/HK
         RsLTYVIOGy5cpgxiHkoDPPYBMn4GKcMBmPEVwwdrP9wq07aC0eNIY0jSWr+2tkT2HhYf
         DVYSCzKG6HbSY49tqw13HCS2n5IvYF0jwOQrw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 12/24] Rename .data.vmpages and .data.vm0.xxx to .data..vmpages and .data..vm0.xxx.
Date: Sat, 20 Feb 2010 01:37:13 +0100
Message-Id: <1266626233-25658-3-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/parisc/kernel/init_task.c   |    6 +++---
 arch/parisc/kernel/vmlinux.lds.S |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/parisc/kernel/init_task.c b/arch/parisc/kernel/init_task.c
index d020eae..4a91e43 100644
--- a/arch/parisc/kernel/init_task.c
+++ b/arch/parisc/kernel/init_task.c
@@ -53,11 +53,11 @@ union thread_union init_thread_union __init_task_data
  * guarantee that global objects will be laid out in memory in the same order 
  * as the order of declaration, so put these in different sections and use
  * the linker script to order them. */
-pmd_t pmd0[PTRS_PER_PMD] __attribute__ ((__section__ (".data.vm0.pmd"), aligned(PAGE_SIZE)));
+pmd_t pmd0[PTRS_PER_PMD] __attribute__ ((__section__ (".data..vm0.pmd"), aligned(PAGE_SIZE)));
 #endif
 
-pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__ ((__section__ (".data.vm0.pgd"), aligned(PAGE_SIZE)));
-pte_t pg0[PT_INITIAL * PTRS_PER_PTE] __attribute__ ((__section__ (".data.vm0.pte"), aligned(PAGE_SIZE)));
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__ ((__section__ (".data..vm0.pgd"), aligned(PAGE_SIZE)));
+pte_t pg0[PT_INITIAL * PTRS_PER_PTE] __attribute__ ((__section__ (".data..vm0.pte"), aligned(PAGE_SIZE)));
 
 /*
  * Initial task structure.
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index 9dab4a4..33ec31d 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -105,10 +105,10 @@ SECTIONS
 	__bss_start = .;
 	/* page table entries need to be PAGE_SIZE aligned */
 	. = ALIGN(PAGE_SIZE);
-	.data.vmpages : {
-		*(.data.vm0.pmd)
-		*(.data.vm0.pgd)
-		*(.data.vm0.pte)
+	.data..vmpages : {
+		*(.data..vm0.pmd)
+		*(.data..vm0.pgd)
+		*(.data..vm0.pte)
 	}
 	.bss : {
 		*(.bss)
-- 
1.6.2.4


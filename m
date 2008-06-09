Return-Path: <linux-kernel-owner+w=401wt.eu-S1759876AbYFIOSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbYFIOSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYFIOS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYFIOS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:28 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 02/15] x86: don't use gdt_page openly.
Date: Mon,  9 Jun 2008 11:16:45 -0300
Message-Id: <1213021018-14159-3-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-2-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a macro available for that.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/traps_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index a92b0c7..9ad896d 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -1135,7 +1135,7 @@ void do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 
 unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
 {
-	struct desc_struct *gdt = __get_cpu_var(gdt_page).gdt;
+	struct desc_struct *gdt = get_cpu_gdt_table(smp_processor_id());
 	unsigned long base = (kesp - uesp) & -THREAD_SIZE;
 	unsigned long new_kesp = kesp - base;
 	unsigned long lim_pages = (new_kesp | (THREAD_SIZE - 1)) >> PAGE_SHIFT;
-- 
1.5.4.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbXLRK7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbXLRK7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbXLRK67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:58:59 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:28909 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbXLRK66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:58:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=paP6FxAyO+zdxm3Nw/d5VRP9zjS/gpYG1dn2Qe2J2BX2DPt4Sfk0xU/ck6LMe9c/bWRHRBApQFV44AbfEaHOGgIFZ29fWhiIE/7z72WEe1J5KgobE4rNed03NYsZI8B8vU6GlFBnksQJX2nCHOd8ecM8uzLAoLN+OOZLqVO5oJY=
Subject: [PATCH] x86: Use helper in fault_64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 02:58:55 -0800
Message-Id: <1197975535.7734.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the fixup_exception() helper in fault_64.c

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
This is only appropriate if CONFIG_PNP_BIOS cannot be set on
X86_64, which looks to be the case, but needs confirmation.

 arch/x86/mm/fault_64.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 121c7bd..3a94941 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -298,7 +298,6 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	struct mm_struct *mm;
 	struct vm_area_struct * vma;
 	unsigned long address;
-	const struct exception_table_entry *fixup;
 	int write, fault;
 	unsigned long flags;
 	siginfo_t info;
@@ -508,9 +507,7 @@ bad_area_nosemaphore:
 no_context:
 	
 	/* Are we prepared to handle this kernel fault?  */
-	fixup = search_exception_tables(regs->ip);
-	if (fixup) {
-		regs->ip = fixup->fixup;
+	if (fixup_exception(regs)) {
 		return;
 	}
 
-- 
1.5.4.rc0.1143.g1a8a




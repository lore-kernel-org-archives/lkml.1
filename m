Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbXLLUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbXLLUJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbXLLUIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:08:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:19645 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbXLLUIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:08:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M24bakvF15/+VHDo/6YyawLtXUgL7JkUwEkVN8LoWhyHPXOrOr4ftXjxvibqaH1S3ktqSqvSSZqZGimjo7zgxvanYq5SuipG1H3a/A4iCcBu3JdTCqbWWxPxg9MovWc3XiTJIOhnLIVsiqC1OetQFUr+9BZSWZFtOBgqoq4auU0=
Subject: [PATCH] x86: Remove last users of FASTCALL
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 12:05:55 -0800
Message-Id: <1197489955.21291.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FASTCALL() is always empty.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/acpi/sleep_32.c |    2 +-
 arch/x86/kernel/vm86_32.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep_32.c b/arch/x86/kernel/acpi/sleep_32.c
index 1069948..09f820d 100644
--- a/arch/x86/kernel/acpi/sleep_32.c
+++ b/arch/x86/kernel/acpi/sleep_32.c
@@ -17,7 +17,7 @@ unsigned long acpi_wakeup_address = 0;
 unsigned long acpi_realmode_flags;
 extern char wakeup_start, wakeup_end;
 
-extern unsigned long FASTCALL(acpi_copy_wakeup_routine(unsigned long));
+extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 
 /**
  * acpi_save_state_mem - save kernel state
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index e85bb44..5aa5e2f 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -120,7 +120,7 @@ static int copy_vm86_regs_from_user(struct kernel_vm86_regs *regs,
 	return ret;
 }
 
-struct pt_regs * FASTCALL(save_v86_state(struct kernel_vm86_regs * regs));
+struct pt_regs * save_v86_state(struct kernel_vm86_regs * regs);
 struct pt_regs * fastcall save_v86_state(struct kernel_vm86_regs * regs)
 {
 	struct tss_struct *tss;
-- 
1.5.3.7.2212.gd092



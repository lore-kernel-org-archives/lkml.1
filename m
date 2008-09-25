Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYIYL62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYIYL62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYIYLzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48531 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbYIYLze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 05/39] KVM: Simplify exception entries by using __ASM_SIZE and _ASM_PTR
Date: Thu, 25 Sep 2008 14:54:37 +0300
Message-Id: <1222343711-12508-6-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm_host.h |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 1161af1..982b6b2 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -734,15 +734,6 @@ enum {
 	TASK_SWITCH_GATE = 3,
 };
 
-
-#ifdef CONFIG_64BIT
-# define KVM_EX_ENTRY ".quad"
-# define KVM_EX_PUSH "pushq"
-#else
-# define KVM_EX_ENTRY ".long"
-# define KVM_EX_PUSH "pushl"
-#endif
-
 /*
  * Hardware virtualization extension instructions may fault if a
  * reboot turns off virtualization while processes are running.
@@ -754,11 +745,11 @@ asmlinkage void kvm_handle_fault_on_reboot(void);
 	"666: " insn "\n\t" \
 	".pushsection .fixup, \"ax\" \n" \
 	"667: \n\t" \
-	KVM_EX_PUSH " $666b \n\t" \
+	__ASM_SIZE(push) " $666b \n\t"	      \
 	"jmp kvm_handle_fault_on_reboot \n\t" \
 	".popsection \n\t" \
 	".pushsection __ex_table, \"a\" \n\t" \
-	KVM_EX_ENTRY " 666b, 667b \n\t" \
+	_ASM_PTR " 666b, 667b \n\t" \
 	".popsection"
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-- 
1.6.0.1


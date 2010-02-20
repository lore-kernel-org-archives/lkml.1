Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0BTAG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:06:58 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33964 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab0BTAEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i7nm44VqSDQl4Wc69D6Xn5Jo91VP9Ognkl7WkG74lqarSK8/PUeuOgsEpP0Hw6GBOv
         MCBsGIx/3sxVBWMoZAtTI5wgxkQUgRMP7vEAX0B8xpE/RnCajl5hn3RrJBxXbC1uhTdy
         jwUwHZpIcW/VQnWraVccizlziOdklS47ANJHY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Tim Abbott <tabbott@ksplice.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 14/24] Rename .text.ivt to .text..ivt.
Date: Sat, 20 Feb 2010 01:03:47 +0100
Message-Id: <1266624237-22372-15-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/ia64/kernel/ivt.S         |    2 +-
 arch/ia64/kernel/vmlinux.lds.S |    2 +-
 arch/ia64/kvm/vmm_ivt.S        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/ivt.S b/arch/ia64/kernel/ivt.S
index ec9a5fd..0c14512 100644
--- a/arch/ia64/kernel/ivt.S
+++ b/arch/ia64/kernel/ivt.S
@@ -83,7 +83,7 @@
 	mov r19=n;;			/* prepare to save predicates */		\
 	br.sptk.many dispatch_to_fault_handler
 
-	.section .text.ivt,"ax"
+	.section .text..ivt,"ax"
 
 	.align 32768	// align on 32KB boundary
 	.global ia64_ivt
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index b943eff..5c01d3c 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -8,7 +8,7 @@
 
 #define IVT_TEXT							\
 		VMLINUX_SYMBOL(__start_ivt_text) = .;			\
-		*(.text.ivt)						\
+		*(.text..ivt)						\
 		VMLINUX_SYMBOL(__end_ivt_text) = .;
 
 OUTPUT_FORMAT("elf64-ia64-little")
diff --git a/arch/ia64/kvm/vmm_ivt.S b/arch/ia64/kvm/vmm_ivt.S
index 40920c6..2401848 100644
--- a/arch/ia64/kvm/vmm_ivt.S
+++ b/arch/ia64/kvm/vmm_ivt.S
@@ -104,7 +104,7 @@ GLOBAL_ENTRY(kvm_vmm_panic)
 	br.call.sptk.many b6=vmm_panic_handler;
 END(kvm_vmm_panic)
 
-    .section .text.ivt,"ax"
+    .section .text..ivt,"ax"
 
     .align 32768    // align on 32KB boundary
     .global kvm_ia64_ivt
-- 
1.6.2.4


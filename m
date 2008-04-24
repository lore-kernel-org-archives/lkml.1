Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYDXOmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYDXOmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYDXOmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:42:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:3555 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYDXOmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=P5uvG8PzHtXpmAGzFffrzKVWGbjp3MdmqBVLZ21Rqr+eqtJ+wa7eLhOZFB3FaRzcfaTHy8pMdlH52LF8oc3PlFrHpH2KKjirmSMj2lp+RI+oZ+ByD4zB98CrmHJT4II50na0ZqlhC4v9exbKtPM9zAoVyw3Oa76TW4SBrv+JP/E=
Date: Thu, 24 Apr 2008 18:41:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: vm86 - hide X86_VM_MASK from userland programs v2
Message-ID: <20080424144120.GA7717@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86_VM_MASK is a kernel specific flag so lets hide it from userland programs
 
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/include/asm-x86/vm86.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/vm86.h	2008-04-23 22:38:58.000000000 +0400
+++ linux-2.6.git/include/asm-x86/vm86.h	2008-04-24 18:37:13.000000000 +0400
@@ -14,12 +14,6 @@
 
 #include <asm/processor-flags.h>
 
-#ifdef CONFIG_VM86
-#define X86_VM_MASK	X86_EFLAGS_VM
-#else
-#define X86_VM_MASK	0 /* No VM86 support */
-#endif
-
 #define BIOSSEG		0x0f000
 
 #define CPU_086		0
@@ -189,6 +183,8 @@ struct kernel_vm86_struct {
 
 #ifdef CONFIG_VM86
 
+#define X86_VM_MASK	X86_EFLAGS_VM
+
 void handle_vm86_fault(struct kernel_vm86_regs *, long);
 int handle_vm86_trap(struct kernel_vm86_regs *, long, int);
 struct pt_regs *save_v86_state(struct kernel_vm86_regs *);
@@ -198,6 +194,8 @@ void release_vm86_irqs(struct task_struc
 
 #else
 
+#define X86_VM_MASK	0 /* No VM86 support */
+
 #define handle_vm86_fault(a, b)
 #define release_vm86_irqs(a)
 

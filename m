Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZBMVyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZBMVyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZBMVyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:54:14 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:27893 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZBMVyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:54:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=ptFx3erdfFcFVJKJ1/cD3LzrF0gcCaINotRNS2XQTqSMwquPWhmu8NEX9yBzyfQDZ5
         riRnamrgIM4CEFEXxTTbi3vGdWfFDASbEcxP0rxvD3PfdmV+6m70gVJTO/lEn8pk5dm1
         RzL9xHPM3S5BaTciQ3oAZr4oLTtxgDuqyi/fQ=
Message-Id: <20090213215404.289039716@gmail.com>
User-Agent: quilt/0.47-1
Date: Sat, 14 Feb 2009 00:50:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, heukelum@fastmail.fm
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 2/6] x86: linkage - get rid of _X86 macros
References: <20090213215017.959278111@gmail.com>
Content-Disposition: inline; filename=x86-linkage-slim-it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

There was an attempt to bring build-time checking for
missed ENTRY_X86/END_X86 and KPROBE... pairs. Using
them will add messy in code. Get just rid of them.
This commit could be easily restored if the need appear
in future.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/linkage.h |   60 -----------------------------------------
 1 file changed, 60 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/linkage.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/linkage.h
+++ linux-2.6.git/arch/x86/include/asm/linkage.h
@@ -61,65 +61,5 @@
 #define __ALIGN_STR ".align 16,0x90"
 #endif
 
-/*
- * to check ENTRY_X86/END_X86 and
- * KPROBE_ENTRY_X86/KPROBE_END_X86
- * unbalanced-missed-mixed appearance
- */
-#define __set_entry_x86		.set ENTRY_X86_IN, 0
-#define __unset_entry_x86	.set ENTRY_X86_IN, 1
-#define __set_kprobe_x86	.set KPROBE_X86_IN, 0
-#define __unset_kprobe_x86	.set KPROBE_X86_IN, 1
-
-#define __macro_err_x86 .error "ENTRY_X86/KPROBE_X86 unbalanced,missed,mixed"
-
-#define __check_entry_x86	\
-	.ifdef ENTRY_X86_IN;	\
-	.ifeq ENTRY_X86_IN;	\
-	__macro_err_x86;	\
-	.abort;			\
-	.endif;			\
-	.endif
-
-#define __check_kprobe_x86	\
-	.ifdef KPROBE_X86_IN;	\
-	.ifeq KPROBE_X86_IN;	\
-	__macro_err_x86;	\
-	.abort;			\
-	.endif;			\
-	.endif
-
-#define __check_entry_kprobe_x86	\
-	__check_entry_x86;		\
-	__check_kprobe_x86
-
-#define ENTRY_KPROBE_FINAL_X86 __check_entry_kprobe_x86
-
-#define ENTRY_X86(name)			\
-	__check_entry_kprobe_x86;	\
-	__set_entry_x86;		\
-	.globl name;			\
-	__ALIGN;			\
-	name:
-
-#define END_X86(name)			\
-	__unset_entry_x86;		\
-	__check_entry_kprobe_x86;	\
-	.size name, .-name
-
-#define KPROBE_ENTRY_X86(name)		\
-	__check_entry_kprobe_x86;	\
-	__set_kprobe_x86;		\
-	.pushsection .kprobes.text, "ax"; \
-	.globl name;			\
-	__ALIGN;			\
-	name:
-
-#define KPROBE_END_X86(name)		\
-	__unset_kprobe_x86;		\
-	__check_entry_kprobe_x86;	\
-	.size name, .-name;		\
-	.popsection
-
 #endif /* _ASM_X86_LINKAGE_H */
 


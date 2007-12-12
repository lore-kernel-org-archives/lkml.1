Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbXLLPmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbXLLPmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759011AbXLLPj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:39:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758956AbXLLPj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:39:58 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 13/19] move constants to desc_defs.h
Date: Wed, 12 Dec 2007 10:53:58 -0200
Message-Id: <11974641243264-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11974641172402-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com> <11974640522688-git-send-email-gcosta@redhat.com> <1197464057242-git-send-email-gcosta@redhat.com> <11974640653022-git-send-email-gcosta@redhat.com> <1197464070228-git-send-email-gcosta@redhat.com> <11974640752137-git-send-email-gcosta@redhat.com> <11974640813511-git-send-email-gcosta@redhat.com> <11974640872474-git-send-email-gcosta@redhat.com> <11974640932406-git-send-email-gcosta@redhat.com> <11974640983333-git-send-email-gcosta@redhat.com> <11974641042757-git-send-email-gcosta@redhat.com> <11974641102691-git-send-email-gcosta@redhat.com> <11974641172402-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch moves constant definitions regarding descriptor types
from desc_32.h to desc_defs.h. The change from defines to enum
to comply with previous versions in desc_defs.h

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/desc_32.h   |    8 --------
 include/asm-x86/desc_defs.h |    5 +++++
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index 92a72b0..14238df 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -44,14 +44,6 @@ static inline void pack_gate(gate_desc *gate,
 	gate->b = (base & 0xffff0000) | ((type & 0xff) << 8) | (flags & 0xff);
 }
 
-#define DESCTYPE_LDT 	0x82	/* present, system, DPL-0, LDT */
-#define DESCTYPE_TSS 	0x89	/* present, system, DPL-0, 32-bit TSS */
-#define DESCTYPE_TASK	0x85	/* present, system, DPL-0, task gate */
-#define DESCTYPE_INT	0x8e	/* present, system, DPL-0, interrupt gate */
-#define DESCTYPE_TRAP	0x8f	/* present, system, DPL-0, trap gate */
-#define DESCTYPE_DPL3	0x60	/* DPL-3 */
-#define DESCTYPE_S	0x10	/* !system */
-
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index c4d7874..5ca416d 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -55,6 +55,11 @@ struct gate_struct64 {
 enum {
 	DESC_TSS = 0x9,
 	DESC_LDT = 0x2,
+	DESCTYPE_TASK = 0x85,   /* present, system, DPL-0, task gate */
+	DESCTYPE_INT =  0x8e,   /* present, system, DPL-0, interrupt gate */
+	DESCTYPE_TRAP = 0x8f,   /* present, system, DPL-0, trap gate */
+	DESCTYPE_DPL3 = 0x60,   /* DPL-3 */
+	DESCTYPE_S =	0x10,	/* !system */
 };
 
 // LDT or TSS descriptor in the GDT. 16 bytes.
-- 
1.5.0.6


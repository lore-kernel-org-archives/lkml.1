Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbXLLPjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbXLLPjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758121AbXLLPi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:38:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758050AbXLLPiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:38:55 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 07/19] introduce ldt_desc type.
Date: Wed, 12 Dec 2007 10:53:52 -0200
Message-Id: <11974640872474-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11974640813511-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com> <11974640522688-git-send-email-gcosta@redhat.com> <1197464057242-git-send-email-gcosta@redhat.com> <11974640653022-git-send-email-gcosta@redhat.com> <1197464070228-git-send-email-gcosta@redhat.com> <11974640752137-git-send-email-gcosta@redhat.com> <11974640813511-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch introduces ldt_desc type to account for the differences
in the ldt descriptor in x86_64 and i386

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/desc_64.h   |    2 +-
 include/asm-x86/desc_defs.h |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index ffc6c06..8fe1b4c 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
@@ -113,7 +113,7 @@ static inline void store_idt(struct desc_ptr *dtr)
 static inline void set_tssldt_descriptor(void *ptr, unsigned long tss,
 					 unsigned type, unsigned size)
 {
-	struct ldttss_desc d;
+	struct ldttss_desc64 d;
 
 	memset(&d, 0, sizeof(d));
 	d.limit0 = size & 0xFFFF;
diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index 05eff93..5a58fc1 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -58,7 +58,7 @@ enum {
 };
 
 // LDT or TSS descriptor in the GDT. 16 bytes.
-struct ldttss_desc {
+struct ldttss_desc64 {
 	u16 limit0;
 	u16 base0;
 	unsigned base1 : 8, type : 5, dpl : 2, p : 1;
@@ -69,8 +69,10 @@ struct ldttss_desc {
 
 #ifdef CONFIG_X86_64
 typedef struct gate_struct64 gate_desc;
+typedef struct ldttss_desc64 ldt_desc;
 #else
 typedef struct desc_struct gate_desc;
+typedef struct desc_struct ldt_desc;
 #endif
 
 struct desc_ptr {
-- 
1.5.0.6


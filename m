Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbXLRBgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbXLRBgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbXLRBg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:36:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbXLRBg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:36:27 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/21] move tsc definitions to were they belong
Date: Mon, 17 Dec 2007 20:52:24 -0200
Message-Id: <1197931971748-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979319641796-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wipes out the definitions of tsc_disable from processor_32.h 
and move it to tsc.h, were it belongs

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/processor_32.h |    7 -------
 include/asm-x86/tsc.h          |    6 ++++++
 2 files changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -22,9 +22,6 @@
 #include <asm/processor-flags.h>
 #include <asm/desc_defs.h>
 
-/* flag for disabling the tsc */
-extern int tsc_disable;
-
 static inline int desc_empty(const void *ptr)
 {
 	const u32 *desc = ptr;
@@ -206,8 +203,6 @@ extern int bootloader_type;
 
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 
-extern void disable_TSC(void);
-
 /*
  * Size of io_bitmap.
  */
Index: linux-2.6-x86/include/asm-x86/tsc.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/tsc.h
+++ linux-2.6-x86/include/asm-x86/tsc.h
@@ -16,6 +16,10 @@ typedef unsigned long long cycles_t;
 
 extern unsigned int cpu_khz;
 extern unsigned int tsc_khz;
+/* flag for disabling the tsc */
+extern int tsc_disable;
+
+extern void disable_TSC(void);
 
 static inline cycles_t get_cycles(void)
 {

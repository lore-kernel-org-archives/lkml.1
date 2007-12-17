Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXLRBhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXLRBhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXLRBga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:36:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbXLRBg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:36:28 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 3/21] [PATCH] move desc_empty to where they belong
Date: Mon, 17 Dec 2007 20:52:26 -0200
Message-Id: <11979319811234-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979319763641-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the (duplicated) desc_empty implementation to desc.h,
where the descriptor things belong.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/desc.h         |    6 ++++++
 include/asm-x86/processor_32.h |    6 ------
 include/asm-x86/processor_64.h |    6 ------
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 161a6d6..6c781bf 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -71,6 +71,12 @@ static inline void pack_gate(gate_desc *gate, unsigned char type,
 
 #endif
 
+static inline int desc_empty(const void *ptr)
+{
+	const u32 *desc = ptr;
+	return !(desc[0] | desc[1]);
+}
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index b9dbe46..cadeffb 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -21,12 +21,6 @@
 #include <linux/init.h>
 #include <asm/desc_defs.h>
 
-static inline int desc_empty(const void *ptr)
-{
-	const u32 *desc = ptr;
-	return !(desc[0] | desc[1]);
-}
-
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
diff --git a/include/asm-x86/processor_64.h b/include/asm-x86/processor_64.h
index a5d06d7..6207292 100644
--- a/include/asm-x86/processor_64.h
+++ b/include/asm-x86/processor_64.h
@@ -20,12 +20,6 @@
 #include <linux/cpumask.h>
 #include <asm/desc_defs.h>
 
-static inline int desc_empty(const void *ptr)
-{
-	const u32 *desc = ptr;
-	return !(desc[0] | desc[1]);
-}
-
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
-- 
1.4.4.2


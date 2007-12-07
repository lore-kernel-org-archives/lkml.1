Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbXLGTHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbXLGTHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbXLGTHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:07:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbXLGTG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:06:58 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/3] [PATCH] put get_kernel_rpl in a common location
Date: Fri,  7 Dec 2007 14:22:40 -0200
Message-Id: <11970445742522-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <119704456265-git-send-email-gcosta@redhat.com>
References: <119704456265-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is useful for both i386 and x86_64, so put it in a common
location, where both arches can grab it.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/segment.h    |    9 +++++++++
 include/asm-x86/segment_32.h |    3 ---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/segment.h b/include/asm-x86/segment.h
index 6050682..b3a7a3e 100644
--- a/include/asm-x86/segment.h
+++ b/include/asm-x86/segment.h
@@ -1,5 +1,14 @@
+#ifndef _ASM_X86_SEGMENT_H_
+#define _ASM_X86_SEGMENT_H_
+
 #ifdef CONFIG_X86_32
 # include "segment_32.h"
 #else
 # include "segment_64.h"
 #endif
+
+#ifndef CONFIG_PARAVIRT
+#define get_kernel_rpl()  0
+#endif
+
+#endif
diff --git a/include/asm-x86/segment_32.h b/include/asm-x86/segment_32.h
index 597a47c..ff186e3 100644
--- a/include/asm-x86/segment_32.h
+++ b/include/asm-x86/segment_32.h
@@ -129,9 +129,6 @@
 #define SEGMENT_LDT		0x4
 #define SEGMENT_GDT		0x0
 
-#ifndef CONFIG_PARAVIRT
-#define get_kernel_rpl()  0
-#endif
 /*
  * Matching rules for certain types of segments.
  */
-- 
1.4.4.2


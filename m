Return-Path: <linux-kernel-owner+w=401wt.eu-S1762299AbYJJSuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762299AbYJJSuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbYJJSuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:50:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:57224 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbYJJSuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=EI5XvIc8K96A2l7qd89TXnhSIN2PAICJb53c2NR1hou8NfTBpFFB5oGwG5NamCfoIn
         DEyMaIpH20tYbkgpWBPv+vlOzNVKpWM9Cg+nYaiIZgwnFtan/5mQOL2fihoobJfZrFpR
         DmmW7D9Ra+wEmLdfBC18BijB5C5BK6QZF0Z4k=
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86: fix APIC_DEBUG with inquire_remote_apic
Date: Fri, 10 Oct 2008 11:49:24 -0700
Message-Id: <1223664564-25714-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APIC_DEBUG is always 2.
need to update inquire_remote_apic to check apic_verbosity with
it instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/asm-x86/es7000/wakecpu.h            |    9 ++++-----
 include/asm-x86/mach-default/mach_wakecpu.h |    9 ++++-----
 2 files changed, 8 insertions(+), 10 deletions(-)

Index: linux-2.6/include/asm-x86/es7000/wakecpu.h
===================================================================
--- linux-2.6.orig/include/asm-x86/es7000/wakecpu.h
+++ linux-2.6/include/asm-x86/es7000/wakecpu.h
@@ -50,10 +50,9 @@ static inline void restore_NMI_vector(un
 {
 }
 
-#if APIC_DEBUG
- #define inquire_remote_apic(apicid) __inquire_remote_apic(apicid)
-#else
- #define inquire_remote_apic(apicid) {}
-#endif
+#define inquire_remote_apic(apicid) do {		\
+		if (apic_verbosity >= APIC_DEBUG)	\
+			__inquire_remote_apic(apicid);	\
+	} while (0)
 
 #endif /* __ASM_MACH_WAKECPU_H */
Index: linux-2.6/include/asm-x86/mach-default/mach_wakecpu.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-default/mach_wakecpu.h
+++ linux-2.6/include/asm-x86/mach-default/mach_wakecpu.h
@@ -33,10 +33,9 @@ static inline void restore_NMI_vector(un
 {
 }
 
-#if APIC_DEBUG
- #define inquire_remote_apic(apicid) __inquire_remote_apic(apicid)
-#else
- #define inquire_remote_apic(apicid) {}
-#endif
+#define inquire_remote_apic(apicid) do {		\
+		if (apic_verbosity >= APIC_DEBUG)	\
+			__inquire_remote_apic(apicid);	\
+	} while (0)
 
 #endif /* ASM_X86__MACH_DEFAULT__MACH_WAKECPU_H */

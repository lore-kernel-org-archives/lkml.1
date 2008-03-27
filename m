Return-Path: <linux-kernel-owner+w=401wt.eu-S1761762AbYC0RMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761762AbYC0RMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759249AbYC0RLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:11:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758008AbYC0RLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:11:03 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 2/9] [PATCH] x86: provide bogus hard_smp_processor_id
Date: Thu, 27 Mar 2008 14:05:57 -0300
Message-Id: <12066375731377-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12066375644061-git-send-email-gcosta@redhat.com>
References: <12066375644061-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We provide a bogus macro for x86_64 in case CONFIG_X86_LOCAL_APIC
is not set. It will always be set for x86_64, so the effect
is just to make the code equal to i386.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp_64.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index 2520633..c46585e 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -46,6 +46,8 @@ static inline int num_booting_cpus(void)
 
 #define safe_smp_processor_id()		smp_processor_id()
 
+#ifdef CONFIG_X86_LOCAL_APIC
+
 static inline int logical_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
@@ -63,5 +65,13 @@ static inline int hard_smp_processor_id(void)
 }
 # endif /* APIC_DEFINITION */
 
+#else /* CONFIG_X86_LOCAL_APIC */
+
+# ifndef CONFIG_SMP
+#  define hard_smp_processor_id()	0
+# endif
+
+#endif /* CONFIG_X86_LOCAL_APIC */
+
 #endif
 
-- 
1.5.0.6


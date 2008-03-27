Return-Path: <linux-kernel-owner+w=401wt.eu-S1761566AbYC0RMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566AbYC0RMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbYC0RLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:11:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758685AbYC0RLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:11:03 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 1/9] [PATCH] x86: surround hard_smp_processor_id in APIC_DEFINITION
Date: Thu, 27 Mar 2008 14:05:56 -0300
Message-Id: <12066375694072-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12066375644061-git-send-email-gcosta@redhat.com>
References: <12066375644061-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APIC_DEFINITION is not defined in x86_64, so in practice, we keep
our old code here. But as a nice side effect, the code is now
equal to smp_32.h.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp_64.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index c53a011..2520633 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -52,12 +52,16 @@ static inline int logical_smp_processor_id(void)
 	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
 }
 
-#include <mach_apicdef.h>
+# ifdef APIC_DEFINITION
+extern int hard_smp_processor_id(void);
+# else
+#  include <mach_apicdef.h>
 static inline int hard_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
 	return GET_APIC_ID(*(u32 *)(APIC_BASE + APIC_ID));
 }
+# endif /* APIC_DEFINITION */
 
 #endif
 
-- 
1.5.0.6


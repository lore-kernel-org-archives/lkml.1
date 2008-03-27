Return-Path: <linux-kernel-owner+w=401wt.eu-S1762310AbYC0RNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762310AbYC0RNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760662AbYC0RLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:11:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760160AbYC0RLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:11:20 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 6/9] [PATCH] x86: split safe_smp_processor_id
Date: Thu, 27 Mar 2008 14:06:01 -0300
Message-Id: <1206637589786-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12066375644061-git-send-email-gcosta@redhat.com>
References: <12066375644061-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implementation in x86_64 is clean and consistent, but we
sacrifice it for the sake of being equal to i386 (since the other
way around would be harder).

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp_64.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index eead92e..8ea4952 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -27,12 +27,12 @@ static inline int num_booting_cpus(void)
 	return cpus_weight(cpu_callout_map);
 }
 
+#define safe_smp_processor_id()		smp_processor_id()
 #else /* CONFIG_SMP */
 #define stack_smp_processor_id() 0
-
+#define safe_smp_processor_id() 0
 #endif /* !CONFIG_SMP */
 
-#define safe_smp_processor_id()		smp_processor_id()
 
 #endif
 
-- 
1.5.0.6


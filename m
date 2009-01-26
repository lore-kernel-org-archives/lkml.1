Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZAZGTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZAZGTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZAZGPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:49 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:4033 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZAZGPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IMQzz0oyidg/TJyWWWIh5LJQSJkqIM7LhLlLfZoKEL3N26W9Ee0b+hKahMjac0cCLE
         ZXBrVvPatJlwvufAruSAMPzXKFXYmxKltxFLS7ESUT1DCNW+oDRfT8W40JeMKEUansdq
         Ols+GQLWr2IAVOvd6hNcwR/g/D5AzwcfX1Fnk=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] x86: Remove extra barriers from load_gs_base()
Date: Mon, 26 Jan 2009 01:15:31 -0500
Message-Id: <1232950532-22923-11-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: optimization

mb() generates an mfence instruction, which is not needed here.  Only
a compiler barrier is needed, and that is handled by the memory clobber
in the wrmsrl function.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/processor.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 32c30b0..794234e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -397,10 +397,7 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 
 static inline void load_gs_base(int cpu)
 {
-	/* Memory clobbers used to order pda/percpu accesses */
-	mb();
 	wrmsrl(MSR_GS_BASE, (unsigned long)per_cpu(irq_stack_union.gs_base, cpu));
-	mb();
 }
 #endif
 
-- 
1.6.1


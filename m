Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZKEMPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZKEMPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 07:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZKEMPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 07:15:40 -0500
Received: from ozlabs.org ([203.10.76.45]:55135 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbZKEMPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 07:15:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 5 Nov 2009 22:45:41 +1030
Subject: [PATCH] cpumask: use struct cpumask rather than the deprecated cpumask_t
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911052245.41803.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the declarations match the definitions, which already use
'struct cpumask'.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/msr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 9a00219..5bef931 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -264,12 +264,12 @@ static inline int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	wrmsr(msr_no, l, h);
 	return 0;
 }
-static inline void rdmsr_on_cpus(const cpumask_t *m, u32 msr_no,
+static inline void rdmsr_on_cpus(const struct cpumask *m, u32 msr_no,
 				struct msr *msrs)
 {
        rdmsr_on_cpu(0, msr_no, &(msrs[0].l), &(msrs[0].h));
 }
-static inline void wrmsr_on_cpus(const cpumask_t *m, u32 msr_no,
+static inline void wrmsr_on_cpus(const struct cpumask *m, u32 msr_no,
 				struct msr *msrs)
 {
        wrmsr_on_cpu(0, msr_no, msrs[0].l, msrs[0].h);
-- 
1.6.3.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbZKHLHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbZKHLHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZKHLHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:07:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:42268 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbZKHLHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:07:32 -0500
Date: Sun, 8 Nov 2009 11:06:56 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, tglx@linutronix.de, borislav.petkov@amd.com,
       mingo@elte.hu
In-Reply-To: <200911052245.41803.rusty@rustcorp.com.au>
References: <200911052245.41803.rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, msr, cpumask: Use struct cpumask rather than the deprecated cpumask_t
Message-ID: <tip-0d0fbbddcc27c062815732b38c44b544e656c799@git.kernel.org>
Git-Commit-ID: 0d0fbbddcc27c062815732b38c44b544e656c799
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d0fbbddcc27c062815732b38c44b544e656c799
Gitweb:     http://git.kernel.org/tip/0d0fbbddcc27c062815732b38c44b544e656c799
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Thu, 5 Nov 2009 22:45:41 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 11:58:38 +0100

x86, msr, cpumask: Use struct cpumask rather than the deprecated cpumask_t

This makes the declarations match the definitions, which already
use 'struct cpumask'.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <200911052245.41803.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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

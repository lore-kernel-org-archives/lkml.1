Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZKOK3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZKOK3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZKOK3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:29:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:46967 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbZKOK3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:29:14 -0500
Date: Sun, 15 Nov 2009 10:28:06 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258199198-16657-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1258199198-16657-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: Move iommu_shutdown_noop to x86_init.c
Message-ID: <tip-94a15564ac63af6bb2ff8d4d04f86d5e7ee0278a@git.kernel.org>
Git-Commit-ID: 94a15564ac63af6bb2ff8d4d04f86d5e7ee0278a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94a15564ac63af6bb2ff8d4d04f86d5e7ee0278a
Gitweb:     http://git.kernel.org/tip/94a15564ac63af6bb2ff8d4d04f86d5e7ee0278a
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Sat, 14 Nov 2009 20:46:37 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Nov 2009 09:03:10 +0100

x86: Move iommu_shutdown_noop to x86_init.c

iommu_init_noop() is in arch/x86/kernel/x86_init.c but
iommu_shutdown_noop() in arch/x86/include/asm/iommu.h.

This moves iommu_shutdown_noop() to x86_init.c for consistency.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
LKML-Reference: <1258199198-16657-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/iommu.h |    1 -
 arch/x86/kernel/x86_init.c   |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index df42a71..345c99c 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_IOMMU_H
 #define _ASM_X86_IOMMU_H
 
-static inline void iommu_shutdown_noop(void) {}
 extern struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index c46984d..80f3ae2 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -20,6 +20,7 @@ void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
 void __init x86_init_pgd_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
+void __init iommu_shutdown_noop(void) { }
 
 /*
  * The platform setup functions are preset with the default functions

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbZKPJEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbZKPJEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 04:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZKPJEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 04:04:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:49829 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbZKPJEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 04:04:22 -0500
Date: Mon, 16 Nov 2009 09:03:46 GMT
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B00BC8E.50801@ct.jp.nec.com>
References: <4B00BC8E.50801@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: Don't put iommu_shutdown_noop() in init section
Message-ID: <tip-62ad33f67003b9a7b6013f0511579b9805e11626@git.kernel.org>
Git-Commit-ID: 62ad33f67003b9a7b6013f0511579b9805e11626
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62ad33f67003b9a7b6013f0511579b9805e11626
Gitweb:     http://git.kernel.org/tip/62ad33f67003b9a7b6013f0511579b9805e11626
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Mon, 16 Nov 2009 11:44:30 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Nov 2009 08:58:51 +0100

x86: Don't put iommu_shutdown_noop() in init section

It causes kernel panic on shutdown or reboot.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
LKML-Reference: <4B00BC8E.50801@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/x86_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 80f3ae2..d11c5ff 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -20,7 +20,7 @@ void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
 void __init x86_init_pgd_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
-void __init iommu_shutdown_noop(void) { }
+void iommu_shutdown_noop(void) { }
 
 /*
  * The platform setup functions are preset with the default functions

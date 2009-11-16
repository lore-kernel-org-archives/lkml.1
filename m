Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZKPCtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZKPCtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 21:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZKPCtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 21:49:03 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34885 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbZKPCtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 21:49:02 -0500
Message-ID: <4B00BC8E.50801@ct.jp.nec.com>
Date: Mon, 16 Nov 2009 11:44:30 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Don't put iommu_shutdown_noop() in init section
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

It causes kernel panic on shutdown or reboot.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
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
-- 
1.6.3.3


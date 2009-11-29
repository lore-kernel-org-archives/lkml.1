Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbZK2LzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbZK2LzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 06:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZK2LzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 06:55:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:59459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbZK2LzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 06:55:18 -0500
Subject: [PATCH -tip] mce: headers_check fix: arch/x86/include/asm/mce.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <borislav.petkov@amd.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 29 Nov 2009 17:24:54 +0530
Message-Id: <1259495694.3477.2.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make headers_check' warning:

  usr/include/asm/mce.h:111: userspace cannot call function or variable defined in the kernel

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mce.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 858baa0..1d80f9d 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -108,8 +108,6 @@ struct mce_log {
 #define K8_MCE_THRESHOLD_BANK_5    (MCE_THRESHOLD_BASE + 5 * 9)
 #define K8_MCE_THRESHOLD_DRAM_ECC  (MCE_THRESHOLD_BANK_4 + 0)
 
-extern struct atomic_notifier_head x86_mce_decoder_chain;
-
 #ifdef __KERNEL__
 
 #include <linux/percpu.h>
@@ -119,6 +117,8 @@ extern struct atomic_notifier_head x86_mce_decoder_chain;
 extern int mce_disabled;
 extern int mce_p5_enabled;
 
+extern struct atomic_notifier_head x86_mce_decoder_chain;
+
 #ifdef CONFIG_X86_MCE
 int mcheck_init(void);
 void mcheck_cpu_init(struct cpuinfo_x86 *c);
-- 
1.6.5.3



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZBINm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZBINm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbZBINku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:40:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:37851 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723AbZBINkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:49 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/11] x86: stackprotector.h misc update
Date: Mon,  9 Feb 2009 22:39:52 +0900
Message-Id: <1234186798-16820-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: misc udpate

* wrap content with CONFIG_CC_STACK_PROTECTOR so that other arch files
  can include it directly

* add missing includes

This will help future changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/stackprotector.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index 36a700a..ee275e9 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -1,8 +1,12 @@
 #ifndef _ASM_STACKPROTECTOR_H
 #define _ASM_STACKPROTECTOR_H 1
 
+#ifdef CONFIG_CC_STACKPROTECTOR
+
 #include <asm/tsc.h>
 #include <asm/processor.h>
+#include <asm/percpu.h>
+#include <linux/random.h>
 
 /*
  * Initialize the stackprotector canary value.
@@ -35,4 +39,5 @@ static __always_inline void boot_init_stack_canary(void)
 	percpu_write(irq_stack_union.stack_canary, canary);
 }
 
-#endif
+#endif	/* CC_STACKPROTECTOR */
+#endif	/* _ASM_STACKPROTECTOR_H */
-- 
1.6.0.2


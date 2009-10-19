Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbZJSJMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbZJSJMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZJSJL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:11:59 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:33593 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899AbZJSJL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 05:11:58 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Cree <mcree@orcon.net.nz>
Subject: [PATCH] Wire up preadv and pwritev on Alpha.
Date: Mon, 19 Oct 2009 21:11:08 +1300
Message-Id: <1255939868-5050-2-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255939868-5050-1-git-send-email-mcree@orcon.net.nz>
References: <1255939868-5050-1-git-send-email-mcree@orcon.net.nz>
X-DSPAM-Check: by mx3.orcon.net.nz on Mon, 19 Oct 2009 21:11:32 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Oct 19 21:11:32 2009
X-DSPAM-Confidence: 0.9931
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/alpha/include/asm/unistd.h |    4 +++-
 arch/alpha/kernel/systbls.S     |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index 5b5c174..bba503a 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -433,10 +433,12 @@
 #define __NR_signalfd			476
 #define __NR_timerfd			477
 #define __NR_eventfd			478
+#define __NR_preadv			479
+#define __NR_pwritev			480
 
 #ifdef __KERNEL__
 
-#define NR_SYSCALLS			479
+#define NR_SYSCALLS			481
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index 95c9aef..8182792 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -497,6 +497,8 @@ sys_call_table:
 	.quad sys_signalfd
 	.quad sys_ni_syscall
 	.quad sys_eventfd
+	.quad sys_preadv
+	.quad sys_pwritev			/* 480 */
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
-- 
1.6.3.3


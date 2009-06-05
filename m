Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbZFEI0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbZFEI0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbZFEIHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:15 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37596 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbZFEIGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 60/62] Blackfin: export the last exception cause via debugfs
Date: Fri,  5 Jun 2009 04:05:09 -0400
Message-Id: <1244189111-19639-61-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

We have some test code that runs in userspace that exercises the exception
handling of the Blackfin pretty thoroughly.  Part of the validation process
is checking the exact exception triggered, so export the last one seen to
userspace via debugfs when debugging is enabled for the test code to check.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 331027a..5547795 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -70,6 +70,10 @@
 	({ if (0) printk(fmt, ##arg); 0; })
 #endif
 
+#ifdef CONFIG_DEBUG_MMRS
+u32 last_seqstat;
+#endif
+
 /* Initiate the event table handler */
 void __init trap_init(void)
 {
@@ -247,6 +251,9 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	unsigned long trapnr = fp->seqstat & SEQSTAT_EXCAUSE;
 
 	trace_buffer_save(j);
+#ifdef CONFIG_DEBUG_MMRS
+	last_seqstat = (u32)fp->seqstat;
+#endif
 
 	/* Important - be very careful dereferncing pointers - will lead to
 	 * double faults if the stack has become corrupt
-- 
1.6.3.1


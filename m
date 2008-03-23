Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbYCWIXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbYCWIXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759345AbYCWIJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:10 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2270 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758899AbYCWIJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:06 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 065/148] include/asm-x86/mc146818rtc.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:40 -0700
Message-Id: <1206259443-13210-66-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mc146818rtc.h |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/mc146818rtc.h b/include/asm-x86/mc146818rtc.h
index cdd9f96..daf1ccd 100644
--- a/include/asm-x86/mc146818rtc.h
+++ b/include/asm-x86/mc146818rtc.h
@@ -42,7 +42,7 @@ extern volatile unsigned long cmos_lock;
 static inline void lock_cmos(unsigned char reg)
 {
 	unsigned long new;
-	new = ((smp_processor_id()+1) << 8) | reg;
+	new = ((smp_processor_id() + 1) << 8) | reg;
 	for (;;) {
 		if (cmos_lock) {
 			cpu_relax();
@@ -57,22 +57,26 @@ static inline void unlock_cmos(void)
 {
 	cmos_lock = 0;
 }
+
 static inline int do_i_have_lock_cmos(void)
 {
-	return (cmos_lock >> 8) == (smp_processor_id()+1);
+	return (cmos_lock >> 8) == (smp_processor_id() + 1);
 }
+
 static inline unsigned char current_lock_cmos_reg(void)
 {
 	return cmos_lock & 0xff;
 }
-#define lock_cmos_prefix(reg) \
+
+#define lock_cmos_prefix(reg)			\
 	do {					\
 		unsigned long cmos_flags;	\
 		local_irq_save(cmos_flags);	\
 		lock_cmos(reg)
-#define lock_cmos_suffix(reg) \
-		unlock_cmos();			\
-		local_irq_restore(cmos_flags);	\
+
+#define lock_cmos_suffix(reg)			\
+	unlock_cmos();				\
+	local_irq_restore(cmos_flags);		\
 	} while (0)
 #else
 #define lock_cmos_prefix(reg) do {} while (0)
-- 
1.5.4.rc2


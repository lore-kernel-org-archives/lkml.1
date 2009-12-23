Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbZLWVoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbZLWVoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbZLWVnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:43:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:48168 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091AbZLWVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:43:42 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 37/37] kgdbts,sh: Add in breakpoint pc offset for superh
Date: Wed, 23 Dec 2009 15:43:04 -0600
Message-Id: <1261604584-5796-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261604584-5796-4-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-33-git-send-email-jason.wessel@windriver.com>
 <1261604584-5796-1-git-send-email-jason.wessel@windriver.com>
 <1261604584-5796-2-git-send-email-jason.wessel@windriver.com>
 <1261604584-5796-3-git-send-email-jason.wessel@windriver.com>
 <1261604584-5796-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:43:18.0841 (UTC) FILETIME=[F0DA7290:01CA8418]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kgdb test suite mimics the behavior of gdb.  For the sh
architecture the pc must be decremented by 2 for software breakpoint.

CC: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/misc/kgdbts.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index fcb6ec1..7245023 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -295,6 +295,10 @@ static int check_and_rewind_pc(char *put_str, char *arg)
 	/* On x86 a breakpoint stop requires it to be decremented */
 	if (addr + 1 == kgdbts_regs.ip)
 		offset = -1;
+#elif defined(CONFIG_SUPERH)
+	/* On SUPERH a breakpoint stop requires it to be decremented */
+	if (addr + 2 == kgdbts_regs.pc)
+		offset = -2;
 #endif
 	if (strcmp(arg, "silent") &&
 		instruction_pointer(&kgdbts_regs) + offset != addr) {
@@ -305,6 +309,8 @@ static int check_and_rewind_pc(char *put_str, char *arg)
 #ifdef CONFIG_X86
 	/* On x86 adjust the instruction pointer if needed */
 	kgdbts_regs.ip += offset;
+#elif defined(CONFIG_SUPERH)
+	kgdbts_regs.pc += offset;
 #endif
 	return 0;
 }
-- 
1.6.4.rc1


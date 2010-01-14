Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943Ab0ANPDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab0ANPDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843Ab0ANPCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:02:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:47970 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab0ANPCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:02:05 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 38/40] kgdbts,sh: Add in breakpoint pc offset for superh
Date: Thu, 14 Jan 2010 08:59:34 -0600
Message-Id: <1263481176-1897-39-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:01:25.0429 (UTC) FILETIME=[713A4650:01CA952A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kgdb test suite mimics the behavior of gdb.  For the sh
architecture the pc must be decremented by 2 for software breakpoint.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
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
1.6.3.1.9.g95405b


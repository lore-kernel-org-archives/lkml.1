Return-Path: <linux-kernel-owner+w=401wt.eu-S1751515AbZHRGHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbZHRGHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 02:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbZHRGHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 02:07:46 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37077 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZHRGHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 02:07:46 -0400
Message-ID: <4A8A44CA.2020701@ct.jp.nec.com>
Date: Tue, 18 Aug 2009 15:06:02 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] task_struct: stack_canary is not needed without CC_STACKPROTECTOR
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The field stack_canary is only used with CC_STACKPROTECTOR.
This patch reduces task_struct size without CC_STACKPROTECTOR.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/sched.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index af1e328..962e457 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1247,8 +1247,10 @@ struct task_struct {
 	pid_t pid;
 	pid_t tgid;
 
+#ifdef CONFIG_CC_STACKPROTECTOR
 	/* Canary value for the -fstack-protector gcc feature */
 	unsigned long stack_canary;
+#endif
 
 	/* 
 	 * pointers to (original) parent process, youngest child, younger sibling,
-- 
1.6.3.3


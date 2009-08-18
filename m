Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbZHRNtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbZHRNtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbZHRNtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:49:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:37203 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758865AbZHRNtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:49:14 -0400
Date: Tue, 18 Aug 2009 13:48:37 GMT
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A8A44CA.2020701@ct.jp.nec.com>
References: <4A8A44CA.2020701@ct.jp.nec.com>
Subject: [tip:sched/core] sched, task_struct: stack_canary is not needed without CC_STACKPROTECTOR
Message-ID: <tip-1314562a9ae5f39f6f595656023c1baf970831ef@git.kernel.org>
Git-Commit-ID: 1314562a9ae5f39f6f595656023c1baf970831ef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 13:48:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1314562a9ae5f39f6f595656023c1baf970831ef
Gitweb:     http://git.kernel.org/tip/1314562a9ae5f39f6f595656023c1baf970831ef
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Tue, 18 Aug 2009 15:06:02 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 15:45:11 +0200

sched, task_struct: stack_canary is not needed without CC_STACKPROTECTOR

The field stack_canary is only used with CC_STACKPROTECTOR.
This patch reduces task_struct size without CC_STACKPROTECTOR.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
LKML-Reference: <4A8A44CA.2020701@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 195d72d..7bc2d92 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1237,8 +1237,10 @@ struct task_struct {
 	pid_t pid;
 	pid_t tgid;
 
+#ifdef CONFIG_CC_STACKPROTECTOR
 	/* Canary value for the -fstack-protector gcc feature */
 	unsigned long stack_canary;
+#endif
 
 	/* 
 	 * pointers to (original) parent process, youngest child, younger sibling,

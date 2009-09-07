Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926AbZIGUiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbZIGUiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 16:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZIGUiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 16:38:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:50478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbZIGUiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 16:38:08 -0400
Date: Mon, 7 Sep 2009 20:37:41 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: enable SD_WAKE_IDLE
Message-ID: <tip-a8fae3ec5f118dc92517dcbed3ecf69ddb641d0f@git.kernel.org>
Git-Commit-ID: a8fae3ec5f118dc92517dcbed3ecf69ddb641d0f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 07 Sep 2009 20:37:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8fae3ec5f118dc92517dcbed3ecf69ddb641d0f
Gitweb:     http://git.kernel.org/tip/a8fae3ec5f118dc92517dcbed3ecf69ddb641d0f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 7 Sep 2009 18:32:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Sep 2009 22:00:17 +0200

sched: enable SD_WAKE_IDLE

Now that SD_WAKE_IDLE doesn't make pipe-test suck anymore,
enable it by default for MC, CPU and NUMA domains.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/topology.h |    2 +-
 include/linux/topology.h        |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index ef7bc7f..26d06e0 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -152,7 +152,7 @@ extern unsigned long node_remap_size[];
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 1*SD_SERIALIZE			\
-				| 0*SD_WAKE_IDLE_FAR			\
+				| 1*SD_WAKE_IDLE_FAR			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 66774fd..85e8cf7 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -129,7 +129,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_IDLE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_WAKE_BALANCE			\
 				| 0*SD_SHARE_CPUPOWER			\
@@ -163,7 +163,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_IDLE			\
 				| 0*SD_WAKE_AFFINE			\
 				| 1*SD_WAKE_BALANCE			\
 				| 0*SD_SHARE_CPUPOWER			\
@@ -198,7 +198,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 1*SD_SERIALIZE			\
-				| 0*SD_WAKE_IDLE_FAR			\
+				| 1*SD_WAKE_IDLE_FAR			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\

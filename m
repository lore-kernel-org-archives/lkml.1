Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbZJNNOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbZJNNOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 09:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932728AbZJNNOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 09:14:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:57444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724AbZJNNOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 09:14:44 -0400
Date: Wed, 14 Oct 2009 13:13:25 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, yanmin_zhang@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1255083400.8802.15.camel@laptop>
References: <1255083400.8802.15.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Disable SD_PREFER_LOCAL for MC/CPU domains
Message-ID: <tip-799e2205ec65e174f752b558c62a92c4752df313@git.kernel.org>
Git-Commit-ID: 799e2205ec65e174f752b558c62a92c4752df313
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 13:13:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  799e2205ec65e174f752b558c62a92c4752df313
Gitweb:     http://git.kernel.org/tip/799e2205ec65e174f752b558c62a92c4752df313
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 9 Oct 2009 12:16:40 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 15:02:34 +0200

sched: Disable SD_PREFER_LOCAL for MC/CPU domains

Yanmin reported that both tbench and hackbench were significantly
hurt by trying to keep tasks local on these domains, esp on small
cache machines.

So disable it in order to promote spreading outside of the cache
domains.

Reported-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1255083400.8802.15.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/topology.h |    1 +
 include/linux/topology.h        |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 25a9284..d823c24 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -143,6 +143,7 @@ extern unsigned long node_remap_size[];
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
diff --git a/include/linux/topology.h b/include/linux/topology.h
index fc0bf3e..57e6357 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -129,7 +129,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_PREFER_LOCAL			\
+				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
@@ -162,7 +162,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_PREFER_LOCAL			\
+				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\

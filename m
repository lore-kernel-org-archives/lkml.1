Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZKCHEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZKCHEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbZKCHEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:04:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:39460 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbZKCHEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:04:21 -0500
Date: Tue, 3 Nov 2009 07:03:43 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, yanmin_zhang@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Disable SD_PREFER_LOCAL at node level
Message-ID: <tip-6b9de613ae9c79b637e070136585dde029578065@git.kernel.org>
Git-Commit-ID: 6b9de613ae9c79b637e070136585dde029578065
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b9de613ae9c79b637e070136585dde029578065
Gitweb:     http://git.kernel.org/tip/6b9de613ae9c79b637e070136585dde029578065
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Mon, 2 Nov 2009 20:36:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Nov 2009 07:24:07 +0100

sched: Disable SD_PREFER_LOCAL at node level

Yanmin Zhang reported that SD_PREFER_LOCAL induces an order of
magnitude increase in select_task_rq_fair() overhead while
running heavy wakeup benchmarks (tbench and vmark).

Since SD_BALANCE_WAKE is off at node level, turn SD_PREFER_LOCAL
off as well pending further investigation.

Reported-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/topology.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index d823c24..40e37b1 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -143,7 +143,7 @@ extern unsigned long node_remap_size[];
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_PREFER_LOCAL			\
+				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\

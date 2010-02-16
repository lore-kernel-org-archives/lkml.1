Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0BPOQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:16:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:53587 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab0BPOQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:16:32 -0500
Date: Tue, 16 Feb 2010 14:15:43 GMT
From: tip-bot for Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, svaidy@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, svaidy@linux.vnet.ibm.com
In-Reply-To: <20100208100555.GD2931@dirshya.in.ibm.com>
References: <20100208100555.GD2931@dirshya.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix sched_mv_power_savings for !SMT
Message-ID: <tip-28f5318167adf23b16c844b9c2253f355cb21796@git.kernel.org>
Git-Commit-ID: 28f5318167adf23b16c844b9c2253f355cb21796
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Feb 2010 14:15:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28f5318167adf23b16c844b9c2253f355cb21796
Gitweb:     http://git.kernel.org/tip/28f5318167adf23b16c844b9c2253f355cb21796
Author:     Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
AuthorDate: Mon, 8 Feb 2010 15:35:55 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Feb 2010 15:13:59 +0100

sched: Fix sched_mv_power_savings for !SMT

Fix for sched_mc_powersavigs for pre-Nehalem platforms.
Child sched domain should clear SD_PREFER_SIBLING if parent will have
SD_POWERSAVINGS_BALANCE because they are contradicting.

Sets the flags correctly based on sched_mc_power_savings.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100208100555.GD2931@dirshya.in.ibm.com>
Cc: stable@kernel.org [2.6.32.x]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78efe7c..1f5fa53 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -878,7 +878,10 @@ static inline int sd_balance_for_mc_power(void)
 	if (sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return SD_PREFER_SIBLING;
+	if (!sched_mc_power_savings)
+		return SD_PREFER_SIBLING;
+
+	return 0;
 }
 
 static inline int sd_balance_for_package_power(void)

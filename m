Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZKUNjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZKUNjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZKUNjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:39:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:36490 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbZKUNjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:39:43 -0500
Date: Sat, 21 Nov 2009 13:39:09 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <1258114575-32655-1-git-send-email-fweisbec@gmail.com>
References: <1258114575-32655-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoints: Fix build on !perf architectures
Message-ID: <tip-688bcaff291cf2fe2734e43f2793d4d05b850518@git.kernel.org>
Git-Commit-ID: 688bcaff291cf2fe2734e43f2793d4d05b850518
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  688bcaff291cf2fe2734e43f2793d4d05b850518
Gitweb:     http://git.kernel.org/tip/688bcaff291cf2fe2734e43f2793d4d05b850518
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 14 Nov 2009 01:12:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Nov 2009 01:29:17 +0100

hw-breakpoints: Fix build on !perf architectures

the arch/alpha build fails with:

 In file included from tip/kernel/exit.c:52:
 tip/include/linux/hw_breakpoint.h: In function 'hw_breakpoint_addr':
 tip/include/linux/hw_breakpoint.h:21: error: 'struct perf_event' has no member named 'attr'
 [...]

Move these helper inlines inside the CONFIG_HAVE_HW_BREAKPOINT ifdef.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <1258114575-32655-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/hw_breakpoint.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 18710e0..0b98cbf 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -16,6 +16,8 @@ enum {
 	HW_BREAKPOINT_X = 4,
 };
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
 {
 	return bp->attr.bp_addr;
@@ -31,7 +33,6 @@ static inline int hw_breakpoint_len(struct perf_event *bp)
 	return bp->attr.bp_len;
 }
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
 extern struct perf_event *
 register_user_hw_breakpoint(unsigned long addr,
 			    int len,

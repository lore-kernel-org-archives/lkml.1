Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbZCENmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbZCENmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbZCENij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:38:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:49992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbZCENii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:38:38 -0500
Date: Thu, 5 Mar 2009 13:38:09 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-12-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-12-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: ifdef 32-bit and 64-bit NR_RANGE_MR for save_mr() unification
Message-ID: <tip-b47e3418c52b26f6143fc696326ae52a21324551@git.kernel.org>
Git-Commit-ID: b47e3418c52b26f6143fc696326ae52a21324551
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:38:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b47e3418c52b26f6143fc696326ae52a21324551
Gitweb:     http://git.kernel.org/tip/b47e3418c52b26f6143fc696326ae52a21324551
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:55:03 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:16 +0100

x86: ifdef 32-bit and 64-bit NR_RANGE_MR for save_mr() unification

Impact: cleanup

As a trivial preparation for moving common code to arc/x86/mm/init.c,
ifdef the 32-bit and 64-bit versions of NR_RANGE_MR.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-12-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |    4 ++++
 arch/x86/mm/init_64.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 34760e4..f59e9b8 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -900,7 +900,11 @@ struct map_range {
 	unsigned page_size_mask;
 };
 
+#ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
+#else /* CONFIG_X86_64 */
+#define NR_RANGE_MR 5
+#endif
 
 static int save_mr(struct map_range *mr, int nr_range,
 		   unsigned long start_pfn, unsigned long end_pfn,
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d99bc6a..d101990 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -660,7 +660,11 @@ struct map_range {
 	unsigned page_size_mask;
 };
 
+#ifdef CONFIG_X86_32
+#define NR_RANGE_MR 3
+#else /* CONFIG_X86_64 */
 #define NR_RANGE_MR 5
+#endif
 
 static int save_mr(struct map_range *mr, int nr_range,
 		   unsigned long start_pfn, unsigned long end_pfn,

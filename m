Return-Path: <linux-kernel-owner+w=401wt.eu-S1764681AbYBOU46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764681AbYBOU46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762079AbYBOUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:55:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:55876 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761900AbYBOUzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:55:46 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 4/7] kgdb-light-v10: print breakpoint removed on exception
Date: Fri, 15 Feb 2008 14:55:55 -0600
Message-Id: <1203108958-1818-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1203108958-1818-4-git-send-email-jason.wessel@windriver.com>
References: <1203108958-1818-1-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-2-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-3-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 15 Feb 2008 20:55:35.0562 (UTC) FILETIME=[1C8BFEA0:01C87015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kgdb does remove a breakpoint that had a problem on the recursion
check, it should also print the address of the breakpoint.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kgdb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 9d42e0a..b516de0 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1309,7 +1309,8 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 		exception_level = 0;
 		kgdb_skipexception(ks->ex_vector, ks->linux_regs);
 		kgdb_activate_sw_breakpoints();
-		printk(KERN_CRIT "KGDB: re-enter error: breakpoint removed\n");
+		printk(KERN_CRIT "KGDB: re-enter error: breakpoint removed %lx\n",
+			addr);
 		WARN_ON_ONCE(1);
 
 		return 1;
-- 
1.5.4


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZBIF4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZBIF4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 00:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZBIF4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 00:56:04 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:49432 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbZBIF4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 00:56:03 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] generic BUG: printk "cut here" headers at appropriate levels
Date: Mon, 09 Feb 2009 18:56:01 +1300
Message-ID: <87r628noge.fsf@burly.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many machines, mine included, are configured to route syslog
messages at level "emerg" to all terminals.  It seems kind of
silly to emit the least meaningful part of a BUG-style report at
the highest possible priority.

Signed-off-by: Paul Collins <paul@ondioline.org>
---
 lib/bug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/bug.c b/lib/bug.c
index 300e41a..c35f4d8 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -136,8 +136,6 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 
 	bug = find_bug(bugaddr);
 
-	printk(KERN_EMERG "------------[ cut here ]------------\n");
-
 	file = NULL;
 	line = 0;
 	warning = 0;
@@ -156,6 +154,7 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 
 	if (warning) {
 		/* this is a WARN_ON rather than BUG/BUG_ON */
+		printk(KERN_ERR "------------[ cut here ]------------\n");
 		if (file)
 			printk(KERN_ERR "Badness at %s:%u\n",
 			       file, line);
@@ -169,6 +168,7 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 		return BUG_TRAP_TYPE_WARN;
 	}
 
+	printk(KERN_CRIT "------------[ cut here ]------------\n");
 	if (file)
 		printk(KERN_CRIT "kernel BUG at %s:%u!\n",
 		       file, line);

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood

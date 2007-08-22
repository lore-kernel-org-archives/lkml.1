Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbXHVS4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbXHVS4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbXHVSz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:55:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXHVSzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:55:55 -0400
Date: Wed, 22 Aug 2007 14:55:48 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, akpm@linux-foundation.org,
       gbeshers@sgi.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070822185548.14528.25255.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Stop bogus softlockup warnings in debug_show_all_locks
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent bogus softlockup warnings when dumping lock debug info during a
sysrq-t.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 734da57..376b398 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3183,8 +3183,10 @@ retry:
 	printk("\n");
 	printk("=============================================\n\n");
 
-	if (unlock)
+	if (unlock) {
+		touch_all_softlockup_watchdogs();
 		read_unlock(&tasklist_lock);
+	}
 }
 
 EXPORT_SYMBOL_GPL(debug_show_all_locks);

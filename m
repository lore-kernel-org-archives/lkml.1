Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbXIEOLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbXIEOLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 10:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbXIEOLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 10:11:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbXIEOLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 10:11:37 -0400
Date: Wed, 5 Sep 2007 10:11:34 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gbeshers@sgi.com,
       mingo@redhat.com, mingo@elte.hu
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070905141134.25743.98581.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Stop bogus softlockup warnings in debug_show_all_locks (2nd try)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trying this again with a wider audience.

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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbYAQTu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbYAQTu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYAQTuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:50:17 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39362 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYAQTuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:50:14 -0500
Subject: [PATCH 3/4]JBD2: user of the jiffies rounding code
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20080115155914.c72aaea9.akpm@linux-foundation.org>
References: <12004403661489-git-send-email-jonas.bonn@gmail.com>
	 <20080115155914.c72aaea9.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 17 Jan 2008 11:48:17 -0800
Message-Id: <1200599297.4134.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ported from JBD changes from Arjan van de Ven <arjan@linux.intel.com>
-------------------------------------------
Date: Sun, 10 Dec 2006 10:21:26 +0000 (-0800)
Subject: [PATCH] user of the jiffies rounding code: JBD
X-Git-Tag: v2.6.20-rc1~15^2~43
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=44d306e1508fef6fa7a6eb15a1aba86ef68389a6

[PATCH] user of the jiffies rounding code: JBD

This patch introduces a user: of the round_jiffies() function; the "5 second"
ext3/jbd wakeup.

While "every 5 seconds" doesn't sound as a problem, there can be many of these
(and these timers do add up over all the kernel).  The "5 second" wakeup isn't
really timing sensitive; in addition even with rounding it'll still happen
every 5 seconds (with the exception of the very first time, which is likely to
be rounded up to somewhere closer to 6 seconds)

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---

---
 fs/jbd2/transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.24-rc7/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.24-rc7.orig/fs/jbd2/transaction.c	2008-01-16 15:41:14.000000000 -0800
+++ linux-2.6.24-rc7/fs/jbd2/transaction.c	2008-01-16 17:49:48.000000000 -0800
@@ -54,7 +54,7 @@ jbd2_get_transaction(journal_t *journal,
 	spin_lock_init(&transaction->t_handle_lock);
 
 	/* Set up the commit timer for the new transaction. */
-	journal->j_commit_timer.expires = transaction->t_expires;
+	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
 	add_timer(&journal->j_commit_timer);
 
 	J_ASSERT(journal->j_running_transaction == NULL);

 




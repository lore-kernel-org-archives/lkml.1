Return-Path: <linux-kernel-owner+w=401wt.eu-S1161148AbXDNIsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161148AbXDNIsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030842AbXDNIsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:48:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:41098 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030840AbXDNIsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:48:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=oOIzPfgmDOQO1ul/VGShzNLSKXUKgeGNeFGwDahinyPmffzC6VXqCE0faLNfNR7EvKx4kwQVGE4A3rJ2n9Qjp8FGqzm1BM++xE0c+F4bpEH07aiOOLaCtPCTWQWi2LO0QD0Qt2mQECaot741nq3YAd0Pl6KuF6WDbMAnXNGszF0=
Date: Sat, 14 Apr 2007 14:20:11 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org, reiserfs-list@namesys.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       reiserfs-dev@namesys.com
Subject: [KJ][PATCH 04/04]use set_current_state in fs
Message-ID: <20070414085011.GE14084@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use set_current_state(TASK_*) instead of current->state = TASK_*, in fs/reiserfs

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---

 journal.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 7280a23..864b15a 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2918,7 +2918,7 @@ static void queue_log_writer(struct super_block *s)
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	if (test_bit(J_WRITERS_QUEUED, &journal->j_state))
 		schedule();
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&journal->j_join_wait, &wait);
 }
 

-- 
Milind Arun Choudhary

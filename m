Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbZEaOv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbZEaOv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759277AbZEaOug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:50:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:14831 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272AbZEaOuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jfqEBbOPaCk6jGAFK3vLwKPymW0Hv1JwGSxztWJnwPvlzU1P8Zwt/opT1fyolC2i3t
         1qZ35FUJvuDLc4kKWlwv4iVHRwMXhlpfnJ/TxQNypVTyinPK69yaBVmocPye8VpytKGI
         lwSXofovgRyMCj7er4Hex9pm3Ey0GUiut/Xyc=
From: tom.leiming@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 7/8] kernel:lockdep: update memory usage introduced by BFS
Date: Sun, 31 May 2009 22:49:24 +0800
Message-Id: <1243781365-26814-8-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1243781365-26814-7-git-send-email-tom.leiming@gmail.com>
References: <yes>
 <1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-2-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-3-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-4-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-5-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-6-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-7-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>


Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 6e31e4b..faa39cb 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3429,7 +3429,8 @@ void __init lockdep_info(void)
 		sizeof(struct list_head) * CLASSHASH_SIZE +
 		sizeof(struct lock_list) * MAX_LOCKDEP_ENTRIES +
 		sizeof(struct lock_chain) * MAX_LOCKDEP_CHAINS +
-		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024);
+		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024 +
+		sizeof(struct circular_queue) + sizeof(bfs_accessed));
 
 	printk(" per task-struct memory footprint: %lu bytes\n",
 		sizeof(struct held_lock) * MAX_LOCK_DEPTH);
-- 
1.6.0.GIT


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbZF1PHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbZF1PHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbZF1PGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:06:07 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58849 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126AbZF1PGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:06:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OZQLivTNNt52E1PtnS5eDEjcuGWOvnrk56svaOtEhgKsBcqpT4GsoF58NKD8gyS0uq
         kU+RnVHgumWGjf6kUT3erX+U/3xdmzywuAlOeU2j+h6l4AO6eQ07/Y0CQ8qTnkKdjJdK
         WjPNUPM3EuZUWyOGPdllQQP5Awrj8syN4Nprs=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       Ming Lei <tom.leiming@gmail.com>
Subject: [RESEND PATCH 08/11] kernel:lockdep: update memory usage introduced by BFS
Date: Sun, 28 Jun 2009 23:04:43 +0800
Message-Id: <1246201486-7308-9-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1246201486-7308-8-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-4-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-5-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-6-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-7-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-8-git-send-email-tom.leiming@gmail.com>
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


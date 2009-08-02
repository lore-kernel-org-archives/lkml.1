Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZHBNnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZHBNnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZHBNnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:43:41 -0400
Received: from mail-px0-f201.google.com ([209.85.216.201]:58819 "EHLO
	mail-px0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZHBNnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iME5c5hvpAoDw9zhOgdH1RxZN1YtDlaO03NhmwsJqt9s52+ZUhJs0Y5CfD0wWAUrP5
         r/eJvvD3hXCDN8wIs5AWISXeCt0cSwajYXEoC6ZWjZkbW4ttMMvdjatQcSXEVSu7HOzC
         Vfu4FdeSnpJcFwrlY5QHxUADn94mUBPCx1noA=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org, davem@davemloft.net,
       Ming Lei <tom.leiming@gmail.com>
Subject: [tip:core/locking] lockdep: fix memory usage info of BFS
Date: Sun,  2 Aug 2009 21:43:36 +0800
Message-Id: <1249220616-7190-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

The unit is KB, so sizeof(struct circular_queue) should be divided by 1024.
This patch fixes it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2b443b5..0843584 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3603,10 +3603,11 @@ void __init lockdep_info(void)
 		sizeof(struct list_head) * CLASSHASH_SIZE +
 		sizeof(struct lock_list) * MAX_LOCKDEP_ENTRIES +
 		sizeof(struct lock_chain) * MAX_LOCKDEP_CHAINS +
-		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024
+		sizeof(struct list_head) * CHAINHASH_SIZE
 #ifdef CONFIG_PROVE_LOCKING
 		+ sizeof(struct circular_queue)
 #endif
+		) / 1024
 		);
 
 	printk(" per task-struct memory footprint: %lu bytes\n",
-- 
1.6.0.GIT


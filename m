Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYHRA2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYHRA2U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 20:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYHRA2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 20:28:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:62530 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYHRA2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 20:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TLuNu6TnP7DU5yW3LuXb8DpOiOTE41OFbOXuGp93vMfVSN37WaJ6pthah0FPv+d3Nj
         hx4ftV5QaoG7CUF5ai8+K9la48wm04JaOOfCUVXnWkazJ5lsTsGepDHyltF3KGBfhO/x
         z3jvIaBkX4E/LqdUmRv7Pjn7HXFJ3+D462HGI=
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@redhat.com,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: [PATCH] lockdep: fix spurious 'inconsistent lock state' warning
Date: Mon, 18 Aug 2008 04:26:37 +0400
Message-Id: <1219019197-17744-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since f82b217e3513fe3af342c0f3ee1494e86250c21c lockdep can output spurious
warnings related to hwirqs due to hardirq_off shrinkage from int to bit-sized
flag. Guard it with double negation to fix the warning.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1aa91fd..b298888 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2584,7 +2584,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->trylock = trylock;
 	hlock->read = read;
 	hlock->check = check;
-	hlock->hardirqs_off = hardirqs_off;
+	hlock->hardirqs_off = !!hardirqs_off;
 #ifdef CONFIG_LOCK_STAT
 	hlock->waittime_stamp = 0;
 	hlock->holdtime_stamp = sched_clock();
-- 
1.5.6.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYHJVwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYHJVwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 17:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYHJVwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 17:52:05 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53874 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbYHJVwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 17:52:03 -0400
Date: Mon, 11 Aug 2008 00:50:22 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] ipc/sem.c: make free_un() static
Message-ID: <20080810215022.GD5480@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global free_un() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4d674b52ad86936fcc96601fd37c04fb7343c0b8 
diff --git a/ipc/sem.c b/ipc/sem.c
index bf1bc36..0821224 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -504,7 +504,7 @@ static int count_semzcnt (struct sem_array * sma, ushort semnum)
 	return semzcnt;
 }
 
-void free_un(struct rcu_head *head)
+static void free_un(struct rcu_head *head)
 {
 	struct sem_undo *un = container_of(head, struct sem_undo, rcu);
 	kfree(un);


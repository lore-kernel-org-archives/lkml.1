Return-Path: <linux-kernel-owner+w=401wt.eu-S1762227AbXKNCJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762227AbXKNCJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761715AbXKNCFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:05:38 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4788 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759368AbXKNCFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:36 -0500
Subject: [PATCH] - [14/15] - remove defconfig ptr comparisons to 0 - kernel
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:05:37 -0800
Message-Id: <1195005937.5163.100.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/kernel/futex.c b/kernel/futex.c
index 9dc591a..ea119d3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -276,7 +276,7 @@ static int get_futex_key(u32 __user *uaddr, struct rw_semaphore *fshared,
  */
 static void get_futex_key_refs(union futex_key *key)
 {
-	if (key->both.ptr == 0)
+	if (!key->both.ptr)
 		return;
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 		case FUT_OFF_INODE:
diff --git a/kernel/pid.c b/kernel/pid.c
index d1db36b..1b3f842 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -563,7 +563,7 @@ static struct pid_namespace *create_pid_namespace(int level)
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
 
 	for (i = 1; i < PIDMAP_ENTRIES; i++) {
-		ns->pidmap[i].page = 0;
+		ns->pidmap[i].page = NULL;
 		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
 	}
 



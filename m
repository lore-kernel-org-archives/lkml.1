Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbXIUJk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbXIUJk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbXIUJkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:40:21 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:4027 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbXIUJkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:40:19 -0400
Date: Fri, 21 Sep 2007 13:40:10 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH 3/3] user.c: #ifdef ->mq_bytes
Message-ID: <20070921094010.GC6812@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

for those who deselect POSIX message queues.

Reduces SLAB size of user_struct from 64 to 32 bytes here,
SLUB size -- from 40 bytes to 32 bytes.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 include/linux/sched.h |    2 ++
 kernel/user.c         |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -583,8 +583,10 @@ struct user_struct {
 	atomic_t inotify_watches; /* How many inotify watches does this user have? */
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
 #endif
+#ifdef CONFIG_POSIX_MQUEUE
 	/* protected by mq_lock	*/
 	unsigned long mq_bytes;	/* How many bytes can be allocated to mqueue? */
+#endif
 	unsigned long locked_shm; /* How many pages of mlocked shm ? */
 
 #ifdef CONFIG_KEYS
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -44,7 +44,6 @@ struct user_struct root_user = {
 	.processes	= ATOMIC_INIT(1),
 	.files		= ATOMIC_INIT(0),
 	.sigpending	= ATOMIC_INIT(0),
-	.mq_bytes	= 0,
 	.locked_shm     = 0,
 #ifdef CONFIG_KEYS
 	.uid_keyring	= &root_user_keyring,


Return-Path: <linux-kernel-owner+w=401wt.eu-S1763840AbXHXMof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763840AbXHXMof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbXHXMo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:44:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:59972 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396AbXHXMoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=kLZq2/BgrkaJcQwO3pacReynXjknniUTbHDxAleVI12L4Z+DJzJh0eF04COG1h6ekpsGNbDECbPFyEHLD4ozUZdNshGdF9Uh2v8/YwokxfWvveZF+LvTS/AGynjmnsBx4q7/UH5WSHXgkwyBqEk0czMeL18ivSaqUh7+64xz76Y=
Message-ID: <46CED2A5.7090307@gmail.com>
Date: Fri, 24 Aug 2007 21:44:21 +0900
From: Kentaro Takeda <k.takeda26@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: [TOMOYO 01/15] Allow use of namespace_sem from LSM module.
References: <46CED214.6050505@gmail.com>
In-Reply-To: <46CED214.6050505@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux uses pathnames for auditing and controlling file access.
Therefore, namespace_sem is needed.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/namespace.c                |    2 +-
 include/linux/mnt_namespace.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.orig/fs/namespace.c	2007-08-23 21:25:13.000000000 +0900
+++ linux-2.6/fs/namespace.c	2007-08-24 15:51:34.000000000 +0900
@@ -38,7 +38,7 @@ static int event;
 static struct list_head *mount_hashtable __read_mostly;
 static int hash_mask __read_mostly, hash_bits __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
-static struct rw_semaphore namespace_sem;
+struct rw_semaphore namespace_sem;
 
 /* /sys/fs */
 decl_subsys(fs, NULL, NULL);
--- linux-2.6.orig/include/linux/mnt_namespace.h	2007-08-23 21:25:13.000000000 +0900
+++ linux-2.6/include/linux/mnt_namespace.h	2007-08-24 15:51:34.000000000 +0900
@@ -6,6 +6,8 @@
 #include <linux/sched.h>
 #include <linux/nsproxy.h>
 
+extern struct rw_semaphore namespace_sem;
+
 struct mnt_namespace {
 	atomic_t		count;
 	struct vfsmount *	root;


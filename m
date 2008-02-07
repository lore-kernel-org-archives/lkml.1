Return-Path: <linux-kernel-owner+w=401wt.eu-S932534AbYBGGYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534AbYBGGYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYBGGS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbYBGGSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:07 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denis Cheng <crquan@gmail.com>
Subject: [PATCH 16/16] dlm: add __init and __exit marks to init and exit functions
Date: Thu,  7 Feb 2008 00:09:19 -0600
Message-Id: <1202364559-9201-17-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

it moves 365 bytes from .text to .init.text, and 30 bytes from .text to
.exit.text, saves memory.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/config.c    |    2 +-
 fs/dlm/debug_fs.c  |    2 +-
 fs/dlm/lockspace.c |    2 +-
 fs/dlm/memory.c    |    2 +-
 fs/dlm/netlink.c   |    4 ++--
 fs/dlm/user.c      |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 2f8e3c8..c3ad1df 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -604,7 +604,7 @@ static struct clusters clusters_root = {
 	},
 };
 
-int dlm_config_init(void)
+int __init dlm_config_init(void)
 {
 	config_group_init(&clusters_root.subsys.su_group);
 	mutex_init(&clusters_root.subsys.su_mutex);
diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 52b1196..8fc24f4 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -541,7 +541,7 @@ void dlm_delete_debug_file(struct dlm_ls *ls)
 		debugfs_remove(ls->ls_debug_locks_dentry);
 }
 
-int dlm_register_debugfs(void)
+int __init dlm_register_debugfs(void)
 {
 	mutex_init(&debug_buf_lock);
 	dlm_root = debugfs_create_dir("dlm", NULL);
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index b180fdc..b64e55e 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -191,7 +191,7 @@ static int do_uevent(struct dlm_ls *ls, int in)
 }
 
 
-int dlm_lockspace_init(void)
+int __init dlm_lockspace_init(void)
 {
 	ls_count = 0;
 	mutex_init(&ls_lock);
diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index 65e41e5..54c14c6 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -18,7 +18,7 @@
 static struct kmem_cache *lkb_cache;
 
 
-int dlm_memory_init(void)
+int __init dlm_memory_init(void)
 {
 	int ret = 0;
 
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index 90374b8..7145936 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -78,7 +78,7 @@ static struct genl_ops dlm_nl_ops = {
 	.doit		= user_cmd,
 };
 
-int dlm_netlink_init(void)
+int __init dlm_netlink_init(void)
 {
 	int rv;
 
@@ -95,7 +95,7 @@ int dlm_netlink_init(void)
 	return rv;
 }
 
-void dlm_netlink_exit(void)
+void __exit dlm_netlink_exit(void)
 {
 	genl_unregister_ops(&family, &dlm_nl_ops);
 	genl_unregister_family(&family);
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 70b31b9..ebbcf38 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -902,7 +902,7 @@ static struct miscdevice ctl_device = {
 	.minor = MISC_DYNAMIC_MINOR,
 };
 
-int dlm_user_init(void)
+int __init dlm_user_init(void)
 {
 	int error;
 
-- 
1.5.3.3


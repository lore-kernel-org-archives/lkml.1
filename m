Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYBARyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYBARyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYBARx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:53:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:9895 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYBARx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:53:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dZCABq9znfp7oBZwBV8ftFbCIM9bKqHDGps/9KcEcjngq3PNwzyyt2+ulO5NPEJoGow3c8noXOvFincn1do7o6bqTy0x6/bHBbMGBfm4gWEtBbzLepfxUIZuavkTdN96Hw+1FOV50Y92y8Aj8lY4RMW5/A/k5RHjy/SByccZm7A=
From: Denis Cheng <crquan@gmail.com>
To: David Teigland <teigland@redhat.com>,
       Patrick Caulfeld <pcaulfie@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/dlm/: add __init and __exit marks to init and exit functions
Date: Sat,  2 Feb 2008 01:53:46 +0800
Message-Id: <1201888426-29675-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it moves 365 bytes from .text to .init.text, and 30 bytes from .text to
.exit.text, saves memory.

Signed-off-by: Denis Cheng <crquan@gmail.com>
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
index 12c3bfd..d2f98d8 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -543,7 +543,7 @@ void dlm_delete_debug_file(struct dlm_ls *ls)
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
index f778386..6273109 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -18,7 +18,7 @@
 static struct kmem_cache *lkb_cache;
 
 
-int dlm_memory_init(void)
+int __init dlm_memory_init(void)
 {
 	int ret = 0;
 
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index 863b87d..745218c 100644
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
index 7cbc682..0bf8dfe 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -907,7 +907,7 @@ static struct miscdevice ctl_device = {
 	.minor = MISC_DYNAMIC_MINOR,
 };
 
-int dlm_user_init(void)
+int __init dlm_user_init(void)
 {
 	int error;
 
-- 
1.5.3.8


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYJQAeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYJQAeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYJQAeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:34:22 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:35882 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbYJQAeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QTYhiE7Yen10CQV2B2mbbuZXW2L0RlPwLR7YB8rojbN5QDuS5Vbl2dtCp1F0c1Q14M
         nPHOf2+58PBHAf0woePGVRURNhh9EwxlQPGoAc6+bgg7W41AMoTm86tYhMgKfjVHtTQp
         KKyDgbJ+WaujTxizbdJisOAHT48D5vq75OPDU=
Date: Fri, 17 Oct 2008 04:37:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: spread __init
Message-ID: <20081017003722.GA12740@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/proc_devtree.c |    3 ++-
 fs/proc/proc_sysctl.c  |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -4,6 +4,7 @@
  * Copyright 1997 Paul Mackerras
  */
 #include <linux/errno.h>
+#include <linux/init.h>
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
@@ -214,7 +215,7 @@ void proc_device_tree_add_node(struct device_node *np,
 /*
  * Called on initialization to set up the /proc/device-tree subtree
  */
-void proc_device_tree_init(void)
+void __init proc_device_tree_init(void)
 {
 	struct device_node *root;
 	if ( !have_of )
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1,7 +1,7 @@
 /*
  * /proc/sys support
  */
-
+#include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
@@ -395,7 +395,7 @@ static struct dentry_operations proc_sys_dentry_operations = {
 	.d_compare	= proc_sys_compare,
 };
 
-int proc_sys_init(void)
+int __init proc_sys_init(void)
 {
 	struct proc_dir_entry *proc_sys_root;
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbYDHL1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbYDHL1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYDHLTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:52 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:34024 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbYDHLTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:50 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 2/29] nfsd: use proc_create to setup de->proc_fops
Date: Tue,  8 Apr 2008 15:19:09 +0400
Message-Id: <1207653576-12640-2-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create() to make sure that ->proc_fops be setup before gluing
PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Trond.Myklebust@netapp.com
---
 fs/nfsd/nfsctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 613bcb8..b5163a3 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -160,6 +160,7 @@ static const struct file_operations exports_operations = {
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.owner		= THIS_MODULE,
 };
 
 /*----------------------------------------------------------------------------*/
@@ -736,10 +737,9 @@ static int create_proc_exports_entry(void)
 	entry = proc_mkdir("fs/nfs", NULL);
 	if (!entry)
 		return -ENOMEM;
-	entry = create_proc_entry("fs/nfs/exports", 0, NULL);
+	entry = proc_create("exports", 0, entry, &exports_operations);
 	if (!entry)
 		return -ENOMEM;
-	entry->proc_fops =  &exports_operations;
 	return 0;
 }
 #else /* CONFIG_PROC_FS */
-- 
1.5.3.rc5


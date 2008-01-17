Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbYAQWvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbYAQWvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759805AbYAQWhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:37:40 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11349 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbYAQWhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:37:12 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>
Subject: [PATCH 22/30] ocfs2: Use generic_file_llseek
Date: Thu, 17 Jan 2008 14:35:48 -0800
Message-Id: <1200609356-17788-23-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

We should use generic_file_llseek() and not default_llseek() so that
s_maxbytes gets properly checked when seeking.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/file.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index caefd57..6ebc9f9 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2233,6 +2233,7 @@ const struct inode_operations ocfs2_special_file_iops = {
 };
 
 const struct file_operations ocfs2_fops = {
+	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.mmap		= ocfs2_mmap,
@@ -2251,6 +2252,7 @@ const struct file_operations ocfs2_fops = {
 };
 
 const struct file_operations ocfs2_dops = {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ocfs2_readdir,
 	.fsync		= ocfs2_sync_file,
-- 
1.5.3.6


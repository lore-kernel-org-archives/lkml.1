Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZEUA3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZEUA3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbZEUA22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:28:28 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37139 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbZEUA2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:28:16 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 05/20] sysfs: Rename sysfs_d_iput to sysfs_dentry_iput
Date: Wed, 20 May 2009 17:27:59 -0700
Message-Id: <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
 <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Using dentry instead of d in the function name is what
several other filesystems are doing and it seems to be
a more readable convention.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 50702b3..01b1e40 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -294,7 +294,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 		goto repeat;
 }
 
-static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
+static void sysfs_dentry_iput(struct dentry * dentry, struct inode * inode)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
 
@@ -303,7 +303,7 @@ static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
 }
 
 static const struct dentry_operations sysfs_dentry_ops = {
-	.d_iput		= sysfs_d_iput,
+	.d_iput		= sysfs_dentry_iput,
 };
 
 struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
-- 
1.6.1.2.350.g88cc


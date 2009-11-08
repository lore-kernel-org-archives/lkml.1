Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbZKHH10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbZKHH10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 02:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZKHH1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 02:27:25 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46876 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZKHH1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 02:27:24 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 02/15] sysfs: Rename sysfs_d_iput to sysfs_dentry_iput
Date: Sat,  7 Nov 2009 23:27:00 -0800
Message-Id: <1257665233-12468-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1pr7tmqb4.fsf@fess.ebiederm.org>
References: <m1pr7tmqb4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
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

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e020183..130dfc3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -298,7 +298,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 		goto repeat;
 }
 
-static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
+static void sysfs_dentry_iput(struct dentry * dentry, struct inode * inode)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
 
@@ -307,7 +307,7 @@ static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
 }
 
 static const struct dentry_operations sysfs_dentry_ops = {
-	.d_iput		= sysfs_d_iput,
+	.d_iput		= sysfs_dentry_iput,
 };
 
 struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
-- 
1.6.5.2.143.g8cc62


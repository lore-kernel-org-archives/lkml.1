Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbZE2UV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbZE2UV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763445AbZE2UUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:20:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45183 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763062AbZE2UTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:53 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:17 -0700
Message-Id: <1243628376-22905-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=2 Fuz1=2 Fuz2=2 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=2 Fuz1=2 Fuz2=2]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 07/26] sysfs: Rename sysfs_d_iput to sysfs_dentry_iput
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Using dentry instead of d in the function name is what
several other filesystems are doing and it seems to be
a more readable convention.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 3e3a87f..f9f32b8 100644
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
1.6.3.1.54.g99dd.dirty


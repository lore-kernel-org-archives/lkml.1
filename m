Return-Path: <linux-kernel-owner+w=401wt.eu-S1764591AbZE2UYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764591AbZE2UYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763443AbZE2UUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:20:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45251 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763431AbZE2UT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:57 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:33 -0700
Message-Id: <1243628376-22905-23-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=2 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0355]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=2]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 23/26] sysfs: Rename sysfs_mv_dir sysfs_rename
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

It turns out that sysfs_mv_dir actually makes no assumptions that what
is being renamed is a directory.   So rename sysfs_mv_dir to sysfs_rename to
reflect the functions general utility.  Later we will use it rename symlinks
in sysfs.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c   |    6 +++---
 fs/sysfs/sysfs.h |    3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 97ca5bf..7da42fb 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -686,7 +686,7 @@ void sysfs_remove_dir(struct kobject * kobj)
 	__sysfs_remove_dir(sd);
 }
 
-static int sysfs_mv_dir(struct sysfs_dirent *sd,
+int sysfs_rename(struct sysfs_dirent *sd,
 	struct sysfs_dirent *new_parent_sd, const char *new_name)
 {
 	const char *dup_name = NULL;
@@ -732,12 +732,12 @@ static int sysfs_mv_dir(struct sysfs_dirent *sd,
 
 int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 {
-	return sysfs_mv_dir(kobj->sd, kobj->sd->s_parent, new_name);
+	return sysfs_rename(kobj->sd, kobj->sd->s_parent, new_name);
 }
 
 int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 {
-	return sysfs_mv_dir(kobj->sd, new_parent_kobj->sd, kobj->sd->s_name);
+	return sysfs_rename(kobj->sd, new_parent_kobj->sd, kobj->sd->s_name);
 }
 
 /* Relationship between s_mode and the DT_xxx types */
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 5dd8168..be1d932 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -109,6 +109,9 @@ int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd);
 void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
+int sysfs_rename(struct sysfs_dirent *sd,
+	struct sysfs_dirent *new_parent_sd, const char *new_name);
+
 static inline struct sysfs_dirent *__sysfs_get(struct sysfs_dirent *sd)
 {
 	if (sd) {
-- 
1.6.3.1.54.g99dd.dirty


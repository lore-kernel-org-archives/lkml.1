Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZEWUN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZEWUN6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 16:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZEWUNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 16:13:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55163 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZEWUNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 16:13:41 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Sat, 23 May 2009 13:13:07 -0700
Message-Id: <1243109591-21611-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1bppofm9k.fsf@fess.ebiederm.org>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0142]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 21/20] sysfs: Rename sysfs_mv_dir sysfs_rename
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
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
index 7aa8890..4da20a3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -660,7 +660,7 @@ void sysfs_remove_dir(struct kobject * kobj)
 	remove_dir(sd);
 }
 
-static int sysfs_mv_dir(struct sysfs_dirent *sd,
+int sysfs_rename(struct sysfs_dirent *sd,
 	struct sysfs_dirent *new_parent_sd, const char *new_name)
 {
 	const char *dup_name = NULL;
@@ -706,12 +706,12 @@ static int sysfs_mv_dir(struct sysfs_dirent *sd,
 
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


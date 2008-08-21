Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYHUGo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYHUGo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbYHUGoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:44:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50418 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbYHUGn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:43:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
References: <m1y74iiidz.fsf_-_@frodo.ebiederm.org>
	<m1tzf6ihlz.fsf_-_@frodo.ebiederm.org>
	<m1prpuihjb.fsf_-_@frodo.ebiederm.org>
	<m1lk0iihhp.fsf_-_@frodo.ebiederm.org>
	<m1hcb6ihfz.fsf_-_@frodo.ebiederm.org>
	<m1d4luihea.fsf_-_@frodo.ebiederm.org>
	<m18wwiihbn.fsf_-_@frodo.ebiederm.org>
	<m14p76ih9a.fsf_-_@frodo.ebiederm.org>
	<m1zloyh2mb.fsf_-_@frodo.ebiederm.org>
	<m1vdzmh2jr.fsf_-_@frodo.ebiederm.org>
	<20080820021754.GA25182@kroah.com>
	<m1od3m282j.fsf_-_@frodo.ebiederm.org>
	<m1hc9e27ya.fsf_-_@frodo.ebiederm.org>
	<m1d4k227wg.fsf_-_@frodo.ebiederm.org>
	<m18wuq27uj.fsf_-_@frodo.ebiederm.org>
Date: Wed, 20 Aug 2008 23:36:32 -0700
In-Reply-To: <m18wuq27uj.fsf_-_@frodo.ebiederm.org> (Eric W. Biederman's
	message of "Wed, 20 Aug 2008 23:35:48 -0700")
Message-ID: <m14p5e27tb.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 5/8] sysfs: Remove sysfs_create_link_nowarn
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


All of the uses have been replaced by sysfs_rename_link which
is a clearer primitive to is also needed for the tagged directory
support.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/symlink.c    |   15 ---------------
 include/linux/sysfs.h |   10 ----------
 2 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 2a64645..3c7a338 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -90,21 +90,6 @@ int sysfs_create_link(struct kobject *kobj, struct kobject *target,
 }
 
 /**
- *	sysfs_create_link_nowarn - create symlink between two objects.
- *	@kobj:	object whose directory we're creating the link in.
- *	@target:	object we're pointing to.
- *	@name:		name of the symlink.
- *
- *	This function does the same as sysf_create_link(), but it
- *	doesn't warn if the link already exists.
- */
-int sysfs_create_link_nowarn(struct kobject *kobj, struct kobject *target,
-			     const char *name)
-{
-	return sysfs_do_create_link(kobj, target, name, 0);
-}
-
-/**
  *	sysfs_delete_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
  *	@targ:	object we're pointing to.
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 1204d45..4e1bfdb 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -112,9 +112,6 @@ void sysfs_remove_bin_file(struct kobject *kobj, struct bin_attribute *attr);
 
 int __must_check sysfs_create_link(struct kobject *kobj, struct kobject *target,
 				   const char *name);
-int __must_check sysfs_create_link_nowarn(struct kobject *kobj,
-					  struct kobject *target,
-					  const char *name);
 void sysfs_remove_link(struct kobject *kobj, const char *name);
 
 int sysfs_rename_link(struct kobject *kobj, struct kobject *target,
@@ -211,13 +208,6 @@ static inline int sysfs_create_link(struct kobject *kobj,
 	return 0;
 }
 
-static inline int sysfs_create_link_nowarn(struct kobject *kobj,
-					   struct kobject *target,
-					   const char *name)
-{
-	return 0;
-}
-
 static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
 {
 }
-- 
1.5.3.rc6.17.g1911


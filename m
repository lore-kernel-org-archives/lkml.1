Return-Path: <linux-kernel-owner+w=401wt.eu-S937546AbXHGViK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937546AbXHGViK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936828AbXHGVMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:12:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55262 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936822AbXHGVMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:12:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 05/25] sysfs: In sysfs_lookup don't open code sysfs_find_dirent
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>
	<m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>
	<m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com>
	<m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:12:02 -0600
In-Reply-To: <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:11:16 -0600")
Message-ID: <m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a small cleanup patch that makes the code just
a little bit cleaner.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 39df3ce..2721e36 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -754,9 +754,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	mutex_lock(&sysfs_mutex);
 
-	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling)
-		if (sysfs_type(sd) && !strcmp(sd->s_name, dentry->d_name.name))
-			break;
+	sd = sysfs_find_dirent(parent_sd, dentry->d_name.name);
 
 	/* no such entry */
 	if (!sd)
-- 
1.5.1.1.181.g2de0


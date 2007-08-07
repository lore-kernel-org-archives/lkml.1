Return-Path: <linux-kernel-owner+w=401wt.eu-S965275AbXHGVgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275AbXHGVgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936600AbXHGVLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:11:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55245 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935419AbXHGVLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:11:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 03/25] sysfs: Use kill_anon_super
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>
	<m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:10:27 -0600
In-Reply-To: <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:08:50 -0600")
Message-ID: <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since sysfs no longer stores fs directory information in the dcache
on a permanent basis kill_litter_super it is inappropriate and actively
wrong.  It will decrement the count on all dentries left in the
dcache before trying to free them.

At the moment this is not biting us only because we never unmount sysfs.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/mount.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 919eaaf..d1094c6 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -72,7 +72,7 @@ static int sysfs_get_sb(struct file_system_type *fs_type,
 static struct file_system_type sysfs_fs_type = {
 	.name		= "sysfs",
 	.get_sb		= sysfs_get_sb,
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 };
 
 int __init sysfs_init(void)
-- 
1.5.1.1.181.g2de0


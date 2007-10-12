Return-Path: <linux-kernel-owner+w=401wt.eu-S1759951AbXJLQCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951AbXJLQCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbXJLQBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:01:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbXJLQBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:01:39 -0400
Message-Id: <20071012155020.197228145@hasse.suse.de>
References: <20071012155019.747515889@hasse.suse.de>
User-Agent: quilt/0.46-62.1
Date: Fri, 12 Oct 2007 17:50:21 +0200
From: Jan Blunck <jblunck@suse.de>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [patch 2/2] r/o bind mounts: Accept passing a mnt NULL pointer to mnt_drop_write()
Content-Disposition: inline; filename=vfs/r-o-bind-mnt_drop_write-mnt-NULL-fix.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In case of somebody opens a file with dentry_open(dentry, NULL, ...) we don't
want to stumble on the NULL pointer mnt in struct file.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namespace.c |    3 +++
 1 file changed, 3 insertions(+)

Index: b/fs/namespace.c
===================================================================
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -253,6 +253,9 @@ void mnt_drop_write(struct vfsmount *mnt
 	int must_check_underflow = 0;
 	struct mnt_writer *cpu_writer;
 
+	if (!mnt)
+		return;
+
 	cpu_writer = &get_cpu_var(mnt_writers);
 	spin_lock(&cpu_writer->lock);
 

-- 


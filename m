Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbZEKSBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbZEKSBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZEKSAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:00:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38155 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbZEKSAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:00:47 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/3] IMA: open all files O_LARGEFILE
To: zohar@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org
Date: Mon, 11 May 2009 13:59:22 -0400
Message-ID: <20090511175922.7719.32980.stgit@dhcp231-142.rdu.redhat.com>
In-Reply-To: <20090511175909.7719.94816.stgit@dhcp231-142.rdu.redhat.com>
References: <20090511175909.7719.94816.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If IMA tried to measure a file which was larger than 4G dentry_open would fail
with -EOVERFLOW since IMA wasn't passing O_LARGEFILE.  This patch passes
O_LARGEFILE to all IMA opens to avoid this problem.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/integrity/ima/ima_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 1987424..c4228c0 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -180,7 +180,8 @@ int ima_path_check(struct path *path, int mask)
 		struct dentry *dentry = dget(path->dentry);
 		struct vfsmount *mnt = mntget(path->mnt);
 
-		file = dentry_open(dentry, mnt, O_RDONLY, current_cred());
+		file = dentry_open(dentry, mnt, O_RDONLY | O_LARGEFILE,
+				   current_cred());
 		if (IS_ERR(file)) {
 			pr_info("%s dentry_open failed\n", dentry->d_name.name);
 			rc = PTR_ERR(file);


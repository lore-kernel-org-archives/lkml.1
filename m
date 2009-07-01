Return-Path: <linux-kernel-owner+w=401wt.eu-S1763840AbZGAAvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763840AbZGAAvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759036AbZGAAeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:23 -0400
Received: from kroah.org ([198.145.64.141]:60116 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759689AbZGAAeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:17 2009
Message-Id: <20090701002417.180909517@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 015/108] IMA: open all files O_LARGEFILE
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ima-open-all-files-o_largefile.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit 1a62e958fa4aaeeb752311b4f5e16b2a86737b23 upstream.

If IMA tried to measure a file which was larger than 4G dentry_open would fail
with -EOVERFLOW since IMA wasn't passing O_LARGEFILE.  This patch passes
O_LARGEFILE to all IMA opens to avoid this problem.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/integrity/ima/ima_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -192,7 +192,8 @@ int ima_path_check(struct path *path, in
 		struct dentry *dentry = dget(path->dentry);
 		struct vfsmount *mnt = mntget(path->mnt);
 
-		file = dentry_open(dentry, mnt, O_RDONLY, current_cred());
+		file = dentry_open(dentry, mnt, O_RDONLY | O_LARGEFILE,
+				   current_cred());
 		if (IS_ERR(file)) {
 			pr_info("%s dentry_open failed\n", dentry->d_name.name);
 			rc = PTR_ERR(file);



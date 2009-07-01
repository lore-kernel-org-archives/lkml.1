Return-Path: <linux-kernel-owner+w=401wt.eu-S1763768AbZGAAuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763768AbZGAAuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbZGAAeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:21 -0400
Received: from kroah.org ([198.145.64.141]:60094 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761240AbZGAAeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:16 2009
Message-Id: <20090701002416.135885567@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 013/108] IMA: use current_cred() instead of current->cred
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ima-use-current_cred-instead-of-current-cred.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit 37bcbf13d32e4e453e9def79ee72bd953b88302f upstream.

Proper invocation of the current credentials is to use current_cred() not
current->cred.  This patches makes IMA use the new method.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/integrity/ima/ima_audit.c |    2 +-
 security/integrity/ima/ima_main.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/security/integrity/ima/ima_audit.c
+++ b/security/integrity/ima/ima_audit.c
@@ -50,7 +50,7 @@ void integrity_audit_msg(int audit_msgno
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
 	audit_log_format(ab, "integrity: pid=%d uid=%u auid=%u ses=%u",
-			 current->pid, current->cred->uid,
+			 current->pid, current_cred()->uid,
 			 audit_get_loginuid(current),
 			 audit_get_sessionid(current));
 	audit_log_task_context(ab);
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -196,7 +196,7 @@ int ima_path_check(struct path *path, in
 		struct dentry *dentry = dget(path->dentry);
 		struct vfsmount *mnt = mntget(path->mnt);
 
-		file = dentry_open(dentry, mnt, O_RDONLY, current->cred);
+		file = dentry_open(dentry, mnt, O_RDONLY, current_cred());
 		rc = get_path_measurement(iint, file, dentry->d_name.name);
 	}
 out:



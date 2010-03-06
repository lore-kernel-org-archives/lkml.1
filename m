Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0CFLTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:19:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:47408 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0CFLTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=qebTE282W0j1tMNDBY2L43muwzM2I/ZPTmifWIW+Dt5Gox5QxL9AwXlwNgdTXBikxC
         azSorA63UEQSZG9EVgDPWwXUs4qpFH0OZJ6+0ZKHdpZ2Fu6O1B/gjbbee9R/+FKObRk3
         6euJ5iADa5VFpMsf4k8kOYtxwyvWbkGJfF2NM=
Date: Sat, 6 Mar 2010 14:19:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: akpm@linux-foundation.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       James Morris <jmorris@namei.org>, Oleg Nesterov <oleg@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, "Helight.Xu" <helight.xu@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [patch] proc: cleanup: remove unused assignments
Message-ID: <20100306111859.GM4958@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	James Morris <jmorris@namei.org>, Oleg Nesterov <oleg@redhat.com>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
	Serge Hallyn <serue@us.ibm.com>,
	"Helight.Xu" <helight.xu@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I removed 3 unused assignments.  The first two get reset on the first
statement of their functions.  For "err" in root.c we don't return an 
error and we don't use the variable again.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/proc/base.c b/fs/proc/base.c
index a731084..875d636 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2434,7 +2434,7 @@ static struct dentry *proc_base_instantiate(struct inode *dir,
 	const struct pid_entry *p = ptr;
 	struct inode *inode;
 	struct proc_inode *ei;
-	struct dentry *error = ERR_PTR(-EINVAL);
+	struct dentry *error;
 
 	/* Allocate the inode */
 	error = ERR_PTR(-ENOMEM);
@@ -2784,7 +2784,7 @@ out:
 
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
 {
-	struct dentry *result = ERR_PTR(-ENOENT);
+	struct dentry *result;
 	struct task_struct *task;
 	unsigned tgid;
 	struct pid_namespace *ns;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 757c069..4258384 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -110,7 +110,6 @@ void __init proc_root_init(void)
 	if (err)
 		return;
 	proc_mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
-	err = PTR_ERR(proc_mnt);
 	if (IS_ERR(proc_mnt)) {
 		unregister_filesystem(&proc_fs_type);
 		return;

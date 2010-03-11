Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0CKKMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:12:46 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:57114 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab0CKKMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:12:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=KKc7Hjhts8D0QRtOWlLUDgrR7Fpg24/d3Ww0IpacwQYg+trePAzzbi7VyOGOyRM3yW
         a2/vk/a8WfhGxJf29GMfrT9lrsWuk3Z73v+RV2pg5nt5xMLji4BrCKm02PDhMCmk901n
         JrJxBS9dKzpqn+of7NEItsajS+FCf3Pf3aZPU=
Message-ID: <4B98C356.9090306@gmail.com>
Date: Thu, 11 Mar 2010 18:17:58 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, akpm@linux-foundation.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       James Morris <jmorris@namei.org>, Oleg Nesterov <oleg@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, "Helight.Xu" <helight.xu@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] proc: cleanup: remove unused assignments
References: <20100306111859.GM4958@bicker>
In-Reply-To: <20100306111859.GM4958@bicker>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> I removed 3 unused assignments.  The first two get reset on the first
> statement of their functions.  For "err" in root.c we don't return an 
> error and we don't use the variable again.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index a731084..875d636 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2434,7 +2434,7 @@ static struct dentry *proc_base_instantiate(struct inode *dir,
>  	const struct pid_entry *p = ptr;
>  	struct inode *inode;
>  	struct proc_inode *ei;
> -	struct dentry *error = ERR_PTR(-EINVAL);
> +	struct dentry *error;
>  
>  	/* Allocate the inode */
>  	error = ERR_PTR(-ENOMEM);
>   
why not do it like this:

@@ -2434,7 +2434,7 @@ static struct dentry *proc_base_instantiate(struct inode *dir,
 	const struct pid_entry *p = ptr;
 	struct inode *inode;
 	struct proc_inode *ei;
-	struct dentry *error = ERR_PTR(-EINVAL);
+	struct dentry *error = ERR_PTR(-ENOMEM);
 
 	/* Allocate the inode */
-	error = ERR_PTR(-ENOMEM);



> @@ -2784,7 +2784,7 @@ out:
>  
>  struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
>  {
> -	struct dentry *result = ERR_PTR(-ENOENT);
> +	struct dentry *result;
>  	struct task_struct *task;
>  	unsigned tgid;
>  	struct pid_namespace *ns;
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 757c069..4258384 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -110,7 +110,6 @@ void __init proc_root_init(void)
>  	if (err)
>  		return;
>  	proc_mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
> -	err = PTR_ERR(proc_mnt);
>  	if (IS_ERR(proc_mnt)) {
>  		unregister_filesystem(&proc_fs_type);
>  		return;
>
>   


-- 
Zhenwen Xu - Seven Helight
Home Page: http://zhwen.org


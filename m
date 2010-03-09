Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab0CIDZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:25:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45571 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab0CIDZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:25:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dan Carpenter <error27@gmail.com>, akpm@linux-foundation.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       James Morris <jmorris@namei.org>, Oleg Nesterov <oleg@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, "Helight.Xu" <helight.xu@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] proc: cleanup: remove unused assignments
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100306111859.GM4958@bicker>
References: <20100306111859.GM4958@bicker>
Message-Id: <20100309122500.7CD8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Mar 2010 12:25:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I removed 3 unused assignments.  The first two get reset on the first
> statement of their functions.  For "err" in root.c we don't return an 
> error and we don't use the variable again.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Looks good.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

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




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0CGT5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 14:57:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab0CGT5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 14:57:03 -0500
Date: Sun, 7 Mar 2010 20:55:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dan Carpenter <error27@gmail.com>, akpm@linux-foundation.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       James Morris <jmorris@namei.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, "Helight.Xu" <helight.xu@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] proc: cleanup: remove unused assignments
Message-ID: <20100307195543.GB18616@redhat.com>
References: <20100306111859.GM4958@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306111859.GM4958@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06, Dan Carpenter wrote:
>
> I removed 3 unused assignments.  The first two get reset on the first
> statement of their functions.  For "err" in root.c we don't return an
> error and we don't use the variable again.

Looks like the obviously nice cleanup to me.

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


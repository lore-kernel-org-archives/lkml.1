Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0CKKiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:38:07 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34456 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab0CKKiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:38:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=rnLU6t7j78u9lbGbm7rIoiw/xhrkZbOEZramJ8ktod+22/9m+qALYjmIENFA3DIZM7
         IoH2S/nR3p9+6ju7gyOBGSmj6MYzpNyr9zKWs1qX9mVyYAyBkdK7NwJF5y/mM+egT6T6
         7fXDKpIJH00yHoCQ75lvaEhl2stjirOUzLS/w=
Date: Thu, 11 Mar 2010 13:29:51 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Helight.Xu" <helight.xu@gmail.com>
Cc: akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       James Morris <jmorris@namei.org>, Oleg Nesterov <oleg@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] proc: cleanup: remove unused assignments
Message-ID: <20100311102951.GL6321@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Helight.Xu" <helight.xu@gmail.com>, akpm@linux-foundation.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	James Morris <jmorris@namei.org>, Oleg Nesterov <oleg@redhat.com>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
	Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org
References: <20100306111859.GM4958@bicker> <4B98C356.9090306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B98C356.9090306@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 06:17:58PM +0800, Helight.Xu wrote:
> Dan Carpenter wrote:
>> I removed 3 unused assignments.  The first two get reset on the first
>> statement of their functions.  For "err" in root.c we don't return an  
>> error and we don't use the variable again.
>>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>>
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index a731084..875d636 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -2434,7 +2434,7 @@ static struct dentry *proc_base_instantiate(struct inode *dir,
>>  	const struct pid_entry *p = ptr;
>>  	struct inode *inode;
>>  	struct proc_inode *ei;
>> -	struct dentry *error = ERR_PTR(-EINVAL);
>> +	struct dentry *error;
>>   	/* Allocate the inode */
>>  	error = ERR_PTR(-ENOMEM);
>>   
> why not do it like this:
>
> @@ -2434,7 +2434,7 @@ static struct dentry *proc_base_instantiate(struct inode *dir,
> 	const struct pid_entry *p = ptr;
> 	struct inode *inode;
> 	struct proc_inode *ei;
> -	struct dentry *error = ERR_PTR(-EINVAL);
> +	struct dentry *error = ERR_PTR(-ENOMEM);
>
> 	/* Allocate the inode */
> -	error = ERR_PTR(-ENOMEM);
>

It's a personal preference.  If anyone read the code in initializers, I 
wouldn't have had had anything to clean up in the first place.  ;)

regards,
dan carpenter

>
>
>> @@ -2784,7 +2784,7 @@ out:
>>   struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * 
>> dentry, struct nameidata *nd)
>>  {
>> -	struct dentry *result = ERR_PTR(-ENOENT);
>> +	struct dentry *result;
>>  	struct task_struct *task;
>>  	unsigned tgid;
>>  	struct pid_namespace *ns;
>> diff --git a/fs/proc/root.c b/fs/proc/root.c
>> index 757c069..4258384 100644
>> --- a/fs/proc/root.c
>> +++ b/fs/proc/root.c
>> @@ -110,7 +110,6 @@ void __init proc_root_init(void)
>>  	if (err)
>>  		return;
>>  	proc_mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
>> -	err = PTR_ERR(proc_mnt);
>>  	if (IS_ERR(proc_mnt)) {
>>  		unregister_filesystem(&proc_fs_type);
>>  		return;
>>
>>   
>
>
> -- 
> Zhenwen Xu - Seven Helight
> Home Page: http://zhwen.org

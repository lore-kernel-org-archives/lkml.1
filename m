Return-Path: <linux-kernel-owner+w=401wt.eu-S1760019AbZEALwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019AbZEALwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbZEALwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:52:05 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49264 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927AbZEALwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:52:00 -0400
Date: Fri, 1 May 2009 12:41:09 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Kay Sievers <kay.sievers@vrfy.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
 tmpfs
In-Reply-To: <1241097822.2516.3.camel@poy>
Message-ID: <Pine.LNX.4.64.0905011235060.8513@blonde.anvils>
References: <1241097822.2516.3.camel@poy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Kay Sievers wrote:
...
> --- a/init/main.c
> +++ b/init/main.c
> @@ -64,6 +64,7 @@
>  #include <linux/idr.h>
>  #include <linux/ftrace.h>
>  #include <linux/async.h>
> +#include <linux/shmem_fs.h>
>  #include <trace/boot.h>
>  
>  #include <asm/io.h>
> @@ -778,6 +779,7 @@ static void __init do_basic_setup(void)
>  	init_workqueues();
>  	cpuset_init_smp();
>  	usermodehelper_init();
> +	init_tmpfs();
>  	driver_init();
>  	init_irq_proc();
>  	do_initcalls();
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2519,7 +2519,7 @@ static struct file_system_type tmpfs_fs_
>  	.kill_sb	= kill_litter_super,
>  };
>  
> -static int __init init_tmpfs(void)
> +int __init init_tmpfs(void)
>  {
>  	int error;
>  
> @@ -2687,5 +2687,3 @@ int shmem_zero_setup(struct vm_area_stru
>  	vma->vm_ops = &shmem_vm_ops;
>  	return 0;
>  }
> -
> -module_init(init_tmpfs)

I've no opinion on the big picture of your devtmpfs proposal.
But note that there's a second, !CONFIG_SHMEM, version of init_tmpfs()
also in mm/shmem.c - you'll want to take the "static " off that too,
for the tiny embedded case when ramfs is used to serve up tmpfs.

Hugh

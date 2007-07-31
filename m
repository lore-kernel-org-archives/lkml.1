Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbXGaLuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbXGaLuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbXGaLuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:50:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbXGaLuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:50:03 -0400
Subject: Re: [PATCH 3/3] fs/gfs2: also mark struct {dentry,vm}_operations
	const
From: Steven Whitehouse <swhiteho@redhat.com>
To: Denis Cheng <crquan@gmail.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org, chdebra@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1185877895769-git-send-email-crquan@gmail.com>
References: <1185873464.8765.564.camel@quoit>
	 <1185877873787-git-send-email-crquan@gmail.com>
	 <11858778843416-git-send-email-crquan@gmail.com>
	 <1185877895769-git-send-email-crquan@gmail.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 31 Jul 2007 12:47:12 +0100
Message-Id: <1185882433.8765.612.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2007-07-31 at 18:31 +0800, Denis Cheng wrote:
> these struct *_operations are all method tables, thus should be const.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  fs/gfs2/ops_dentry.c   |    3 +--
>  fs/gfs2/ops_dentry.h   |    2 +-
>  fs/gfs2/ops_vm.c       |    4 ++--
>  fs/gfs2/ops_vm.h       |    4 ++--
>  include/linux/dcache.h |    2 +-
>  include/linux/mm.h     |    2 +-
>  6 files changed, 8 insertions(+), 9 deletions(-)
> 
I've applied the first two patches in the series, but I'm still not
quite sure about this one. Even though it might not produce any warnings
there are still other filesystems to change, and I think it would be a
good plan to convert them all and CC the relevant maintainers.

Steve.



> diff --git a/fs/gfs2/ops_dentry.c b/fs/gfs2/ops_dentry.c
> index 793e334..1bdf016 100644
> --- a/fs/gfs2/ops_dentry.c
> +++ b/fs/gfs2/ops_dentry.c
> @@ -108,8 +108,7 @@ static int gfs2_dhash(struct dentry *dentry, struct qstr *str)
>  	return 0;
>  }
>  
> -struct dentry_operations gfs2_dops = {
> +const struct dentry_operations gfs2_dops = {
>  	.d_revalidate = gfs2_drevalidate,
>  	.d_hash = gfs2_dhash,
>  };
> -
> diff --git a/fs/gfs2/ops_dentry.h b/fs/gfs2/ops_dentry.h
> index 5caa3db..668a6bc 100644
> --- a/fs/gfs2/ops_dentry.h
> +++ b/fs/gfs2/ops_dentry.h
> @@ -12,6 +12,6 @@
>  
>  #include <linux/dcache.h>
>  
> -extern struct dentry_operations gfs2_dops;
> +extern const struct dentry_operations gfs2_dops;
>  
>  #endif /* __OPS_DENTRY_DOT_H__ */
> diff --git a/fs/gfs2/ops_vm.c b/fs/gfs2/ops_vm.c
> index 927d739..baa3b20 100644
> --- a/fs/gfs2/ops_vm.c
> +++ b/fs/gfs2/ops_vm.c
> @@ -159,11 +159,11 @@ out:
>  	return ret;
>  }
>  
> -struct vm_operations_struct gfs2_vm_ops_private = {
> +const struct vm_operations_struct gfs2_vm_ops_private = {
>  	.fault = gfs2_private_fault,
>  };
>  
> -struct vm_operations_struct gfs2_vm_ops_sharewrite = {
> +const struct vm_operations_struct gfs2_vm_ops_sharewrite = {
>  	.fault = gfs2_sharewrite_fault,
>  };
>  
> diff --git a/fs/gfs2/ops_vm.h b/fs/gfs2/ops_vm.h
> index 4ae8f43..cfefd2d 100644
> --- a/fs/gfs2/ops_vm.h
> +++ b/fs/gfs2/ops_vm.h
> @@ -12,7 +12,7 @@
>  
>  #include <linux/mm.h>
>  
> -extern struct vm_operations_struct gfs2_vm_ops_private;
> -extern struct vm_operations_struct gfs2_vm_ops_sharewrite;
> +extern const struct vm_operations_struct gfs2_vm_ops_private;
> +extern const struct vm_operations_struct gfs2_vm_ops_sharewrite;
>  
>  #endif /* __OPS_VM_DOT_H__ */
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index aab53df..9cd948e 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -104,7 +104,7 @@ struct dentry {
>  	struct list_head d_subdirs;	/* our children */
>  	struct list_head d_alias;	/* inode alias list */
>  	unsigned long d_time;		/* used by d_revalidate */
> -	struct dentry_operations *d_op;
> +	const struct dentry_operations *d_op;
>  	struct super_block *d_sb;	/* The root of the dentry tree */
>  	void *d_fsdata;			/* fs-specific data */
>  #ifdef CONFIG_PROFILING
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 655094d..c91b684 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -96,7 +96,7 @@ struct vm_area_struct {
>  	struct anon_vma *anon_vma;	/* Serialized by page_table_lock */
>  
>  	/* Function pointers to deal with this struct. */
> -	struct vm_operations_struct * vm_ops;
> +	const struct vm_operations_struct * vm_ops;
>  
>  	/* Information about our backing store: */
>  	unsigned long vm_pgoff;		/* Offset (within vm_file) in PAGE_SIZE


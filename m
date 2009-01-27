Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZA0N0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZA0N0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZA0N0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:26:13 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49731 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbZA0N0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:26:12 -0500
Subject: Re: [PATCH 11/20] fs/jfs: return f_fsid for statfs(2), v3
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, coly.li@suse.de
In-Reply-To: <4975F653.2000109@suse.de>
References: <4975F653.2000109@suse.de>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 07:26:06 -0600
Message-Id: <1233062766.3779.3.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,
Please take this version of the jfs patch, rather than the one you
currently have in the -mm tree (fs-jfs-return-f_fsid-for-statfs2.patch).

Thanks,
Shaggy

On Wed, 2009-01-21 at 00:05 +0800, Coly Li wrote:
> This patch makes jfs return f_fsid info for statfs(2). By Andreas' suggestion, this patch populates
> a persistent f_fsid between boots/mounts with help of on-disk uuid record.
> 
> Signed-off-by: Coly Li <coly.li@suse.de>
> Acked-By: Dave Kleikamp <shaggy@austin.ibm.com>
> ---
>  fs/jfs/super.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index b37d1f7..6ce1aac 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -29,6 +29,7 @@
>  #include <linux/posix_acl.h>
>  #include <linux/buffer_head.h>
>  #include <linux/exportfs.h>
> +#include <linux/crc32.h>
>  #include <asm/uaccess.h>
>  #include <linux/seq_file.h>
> 
> @@ -168,7 +169,10 @@ static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_files = maxinodes;
>  	buf->f_ffree = maxinodes - (atomic_read(&imap->im_numinos) -
>  				    atomic_read(&imap->im_numfree));
> -
> +	buf->f_fsid.val[0] = (u32)crc32_le(0, sbi->uuid, sizeof(sbi->uuid)/2);
> +	buf->f_fsid.val[1] = (u32)crc32_le(0, sbi->uuid + sizeof(sbi->uuid)/2,
> +					sizeof(sbi->uuid)/2);
> +
>  	buf->f_namelen = JFS_NAME_MAX;
>  	return 0;
>  }
> 
-- 
David Kleikamp
IBM Linux Technology Center


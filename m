Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbZATMfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbZATMfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZATMfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:35:23 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:34625 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbZATMfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:35:22 -0500
Subject: Re: [PATCH 11/20] fs/jfs: return f_fsid for statfs(2), v2
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: coly.li@suse.de
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49757804.4070305@suse.de>
References: <49757804.4070305@suse.de>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 06:35:20 -0600
Message-Id: <1232454920.23109.5.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One minor nit...

On Tue, 2009-01-20 at 15:06 +0800, Coly Li wrote:
> This patch makes jfs return f_fsid info for statfs(2). By Andreas' suggestion, this patch populates
> a persistent f_fsid between boots/mounts with help of on-disk uuid record.
> 
> Signed-off-by: Coly Li <coly.li@suse.de>

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

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

checkpatch.pl points out a trailing tab here

>  	buf->f_namelen = JFS_NAME_MAX;
>  	return 0;
>  }
> 
-- 
David Kleikamp
IBM Linux Technology Center


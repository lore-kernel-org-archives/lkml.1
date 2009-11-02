Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZKBMOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZKBMOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbZKBMOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:14:48 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:19668 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZKBMOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:14:47 -0500
Date: Mon, 2 Nov 2009 07:13:08 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Yan Zheng <zheng.yan@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/27] BKL: Remove BKL from btrfs
Message-ID: <20091102121308.GB882@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Yan Zheng <zheng.yan@oracle.com>,
	Al Viro <viro@zeniv.linux.org.uk>, Sage Weil <sage@newdream.net>,
	linux-btrfs@vger.kernel.org
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
 <1257156307-24175-13-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257156307-24175-13-git-send-email-jblunck@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4AEECD2F.00CA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:04:52AM +0100, Jan Blunck wrote:
> BKL is only used in get_sb. It is safe to remove it.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>

Acked-by: Chris Mason <chris.mason@oracle.com>

Thanks!

-chris

> ---
>  fs/btrfs/super.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index e5cd2cf..752a546 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -480,17 +480,13 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
>  	fmode_t mode = FMODE_READ;
>  	int error = 0;
>  
> -	lock_kernel();
> -
>  	if (!(flags & MS_RDONLY))
>  		mode |= FMODE_WRITE;
>  
>  	error = btrfs_parse_early_options(data, mode, fs_type,
>  					  &subvol_name, &fs_devices);
> -	if (error) {
> -		unlock_kernel();
> +	if (error)
>  		return error;
> -	}
>  
>  	error = btrfs_scan_one_device(dev_name, mode, fs_type, &fs_devices);
>  	if (error)
> @@ -559,7 +555,6 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
>  	mnt->mnt_root = root;
>  
>  	kfree(subvol_name);
> -	unlock_kernel();
>  	return 0;
>  
>  error_s:
> @@ -568,7 +563,6 @@ error_close_devices:
>  	btrfs_close_devices(fs_devices);
>  error_free_subvol_name:
>  	kfree(subvol_name);
> -	unlock_kernel();
>  	return error;
>  }
>  
> -- 
> 1.6.4.2
> 

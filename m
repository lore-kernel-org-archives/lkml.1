Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab0CDQw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:52:27 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:64747 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab0CDQwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:52:25 -0500
Date: Thu, 4 Mar 2010 08:50:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Josef Bacik <josef@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup __generic_block_fiemap and fix a few minor
 issues
Message-Id: <20100304085021.1b4e5c58.randy.dunlap@oracle.com>
In-Reply-To: <20100304162039.GA5722@localhost.localdomain>
References: <20100303163715.GB2215@localhost.localdomain>
	<alpine.LFD.2.00.1003040754150.7046@localhost.localdomain>
	<20100304162039.GA5722@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B8FE4F2.00BD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010 11:20:40 -0500 Josef Bacik wrote:

> Ahh yes thats much nicer, thank you.  Here is my updated patch with your
> suggestions.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/ioctl.c         |   81 +++++++++++++++++++++++++++++----------------------
>  include/linux/fs.h |    5 ++-
>  2 files changed, 49 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 6c75110..64fed0b 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -228,13 +228,22 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
>  
>  #ifdef CONFIG_BLOCK
>  
> -#define blk_to_logical(inode, blk) (blk << (inode)->i_blkbits)
> -#define logical_to_blk(inode, offset) (offset >> (inode)->i_blkbits);
> +static inline sector_t logical_to_blk(struct inode *inode, loff_t offset)
> +{
> +	return (offset >> inode->i_blkbits);
> +}
> +
> +static inline loff_t blk_to_logical(struct inode *inode, sector_t blk)
> +{
> +	return (blk << inode->i_blkbits);
> +}
>  
>  /**
>   * __generic_block_fiemap - FIEMAP for block based inodes (no locking)
>   * @inode - the inode to map
> - * @arg - the pointer to userspace where we copy everything to
> + * @fieinfo - the fiemap info struct that will be passed back to userspace
> + * @start - where to start mapping in the inode
> + * @len - how much space to map
>   * @get_block - the fs's get_block function
>   *
>   * This does FIEMAP for block based inodes.  Basically it will just loop

Please fix the kernel-doc notation.  Function parameter notation is like:

 * @start: where to start mapping in the inode

thanks,
---
~Randy

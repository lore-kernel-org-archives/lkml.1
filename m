Return-Path: <linux-kernel-owner+w=401wt.eu-S1765519AbYARTQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765519AbYARTQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761989AbYARTQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:16:37 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47250 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761237AbYARTQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:16:36 -0500
Subject: Re: [PATCH] Shrink ext3_inode_info by 8 bytes for !POSIX_ACL.
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Indan Zupancic <indan@nul.nu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1200170142-1151-1-git-send-email-indan@nul.nu>
References: <1200170142-1151-1-git-send-email-indan@nul.nu>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 18 Jan 2008 11:16:09 -0800
Message-Id: <1200683769.7261.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-01-12 at 21:35 +0100, Indan Zupancic wrote:
> i_file_acl and i_dir_acl aren't always needed.
> 
> With certain configs this makes 10 ext3_inode_cache objects fit in
> one slab instead of the current 9, as the size shrinks from 416 to
> 408 bytes for 32 bit, !POSIX_ACL and !EXT3_FS_XATTR configs.
> 
> Signed-off-by: Indan Zupancic <indan@nul.nu>
> ---
>  fs/ext3/ialloc.c          |    2 ++
>  fs/ext3/inode.c           |   29 +++++++++++++++++++----------
>  include/linux/ext3_fs_i.h |    2 ++
>  3 files changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
> index 1bc8cd8..01745bc 100644
> --- a/fs/ext3/ialloc.c
> +++ b/fs/ext3/ialloc.c
> @@ -574,8 +574,10 @@ got:
>  	ei->i_frag_no = 0;
>  	ei->i_frag_size = 0;
>  #endif
> +#ifdef CONFIG_EXT3_FS_POSIX_ACL
>  	ei->i_file_acl = 0;
>  	ei->i_dir_acl = 0;
> +#endif

For regular file, i_dir_acl is being reused as i_size_high to support
large file.

Mingming


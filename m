Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbZKSHjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbZKSHjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 02:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZKSHjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 02:39:17 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44856 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZKSHjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 02:39:16 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Date: Wed, 18 Nov 2009 23:34:46 -0800
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext2: Explicitly assign values to on-disk enum of filetypes
In-reply-to: <20091118162550.GP21750@bolzano.suse.de>
To: Jan Blunck <jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Message-id: <CE98E2AD-F6E2-4AC7-B43A-BE2893E384F8@sun.com>
X-Mailer: Apple Mail (2.936)
References: <20091118162550.GP21750@bolzano.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-11-18, at 08:25, Jan Blunck wrote:
> Here is an old patch that I found in my tree. Andreas, it seems that  
> this is something you proposed.
>
> Comments?

This is definitely my preferred coding style for constants that form a  
permanent part of the API/ABI/disk format.

The enum is useful because some debuggers can display the symbolic  
name of a constant if a named enum is present (though in this case it  
isn't), but it avoids the risk of someone accidentally inserting or  
removing a value in the middle of the enum.

For in-memory-only enums that isn't important at all, but for some  
developers it isn't always clear what is in-memory and what is on-disk  
or part of an API.  Also, the compiler will warn if the same value is  
assigned multiple times, which isn't necessarily a worry with the few  
values here, but for large lists of #defines like e.g.  
EXT2_FEATURE_INCOMPAT_* it is a real risk, and I've seen a few cases  
where the same value was #defined multiple times accidentally (e.g.  
with patches vs. upstream merges).

> From 290d3d969850ff9555bc213035b1c4e401ea9ada Mon Sep 17 00:00:00 2001
> From: Jan Blunck <jblunck@suse.de>
> Date: Wed, 18 Nov 2009 17:10:56 +0100
> Subject: [PATCH] ext2: Explicitly assign values to on-disk enum of  
> filetypes
>
> It is somewhat dangerous to use a straight enum here, because this  
> will
> reassign values of later variables if one of the earlier ones is  
> removed.
>
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Cc: Andreas Dilger <adilger@sun.com>
> ---
> include/linux/ext2_fs.h |   16 ++++++++--------
> 1 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
> index 121720d..2dfa707 100644
> --- a/include/linux/ext2_fs.h
> +++ b/include/linux/ext2_fs.h
> @@ -565,14 +565,14 @@ struct ext2_dir_entry_2 {
>  * other bits are reserved for now.
>  */
> enum {
> -	EXT2_FT_UNKNOWN,
> -	EXT2_FT_REG_FILE,
> -	EXT2_FT_DIR,
> -	EXT2_FT_CHRDEV,
> -	EXT2_FT_BLKDEV,
> -	EXT2_FT_FIFO,
> -	EXT2_FT_SOCK,
> -	EXT2_FT_SYMLINK,
> +	EXT2_FT_UNKNOWN		= 0,
> +	EXT2_FT_REG_FILE	= 1,
> +	EXT2_FT_DIR		= 2,
> +	EXT2_FT_CHRDEV		= 3,
> +	EXT2_FT_BLKDEV		= 4,
> +	EXT2_FT_FIFO		= 5,
> +	EXT2_FT_SOCK		= 6,
> +	EXT2_FT_SYMLINK		= 7,
> 	EXT2_FT_MAX
> };
>
> -- 
> 1.6.4.2
>


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


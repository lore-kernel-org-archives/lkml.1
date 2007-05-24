Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXEXNUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXEXNUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbXEXNUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:20:43 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57047 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595AbXEXNUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:20:41 -0400
Subject: Re: [RFC 2/5] inode reservation v0.1 (ext4 kernel patch)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: coly <colyli@gmail.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1179943606.4179.53.camel@coly-t43.site>
References: <1179943606.4179.53.camel@coly-t43.site>
Content-Type: text/plain
Date: Thu, 24 May 2007 08:20:37 -0500
Message-Id: <1180012837.11124.11.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 02:06 +0800, coly wrote:
> The patch is generated based on 2.6.20-ext4-2 branch. you can find the
> benchmark from other email.
> 
> DO NOT waste time on reading the patch :-) I post this patch here is to
> show that I really spent time on it and the patch can work (even not
> well).

I won't waste my time then.  I'm discouraged from trying by the lack of
indentation.  It looks like the tabs got converted to a single space
somehow.

> diff --git a/Makefile b/Makefile
> index 7e2750f..21d21e4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,8 +1,7 @@
> VERSION = 2
> PATCHLEVEL = 6
> SUBLEVEL = 20
> -EXTRAVERSION =
> -NAME = Homicidal Dwarf Hamster
> +EXTRAVERSION = inores
> 
> # *DOCUMENTATION*
> # To see a list of typical targets execute "make help"
> diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
> index 11e93c1..daf88b4 100644
> --- a/fs/ext4/bitmap.c
> +++ b/fs/ext4/bitmap.c
> @@ -30,3 +30,29 @@ unsigned long ext4_count_free (struct buffer_head *
> map, unsigned int numchars)
> 
> #endif  /*  EXT4FS_DEBUG  */
> 
> +/*
> + * Read the inode allocation bitmap for a given block_group, reading
> + * into the specified slot in the superblock's bitmap cache.
> + *
> + * Return buffer_head of bitmap on success or NULL.
> + */
> +struct buffer_head *
> +read_inode_bitmap(struct super_block * sb, unsigned long block_group)
> +{
> + struct ext4_group_desc *desc;
> + struct buffer_head *bh = NULL;
> +
> + desc = ext4_get_group_desc(sb, block_group, NULL);
> + if (!desc)
> + goto error_out;
> +
> + bh = sb_bread(sb, ext4_inode_bitmap(sb, desc));
> + if (!bh)
> + ext4_error(sb, "read_inode_bitmap",
> + "Cannot read inode bitmap - "
> + "block_group = %lu, inode_bitmap = %llu",
> + block_group, ext4_inode_bitmap(sb, desc));
> +error_out:
> + return bh;
> +}
> +

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbZASVpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbZASVpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZASVpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:45:10 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:4077 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZASVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:45:09 -0500
Date: Mon, 19 Jan 2009 16:44:56 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Coly Li <coly.li@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/20] fs/omfs: return f_fsid for statfs(2)
Message-ID: <20090119214456.GA21493@hash.localnet>
References: <4974B9CE.7020900@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4974B9CE.7020900@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 01:35:10AM +0800, Coly Li wrote:
> This patch makes omfs return f_fsid info for statfs(2).
> 
> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: Bob Copeland <me@bobcopeland.com>

Fine with me...

Acked-by: Bob Copeland <me@bobcopeland.com>

> @@ -262,14 +262,19 @@ static int omfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
>  	struct super_block *s = dentry->d_sb;
>  	struct omfs_sb_info *sbi = OMFS_SB(s);
> +	u64 id = huge_encode_dev(s->s_bdev->bd_dev);
> +
>  	buf->f_type = OMFS_MAGIC;
>  	buf->f_bsize = sbi->s_blocksize;
>  	buf->f_blocks = sbi->s_num_blocks;
>  	buf->f_files = sbi->s_num_blocks;
>  	buf->f_namelen = OMFS_NAMELEN;
> +	buf->f_fsid.val[0] = (u32)id;
> +	buf->f_fsid.val[1] = (u32)(id >> 32);
> 
>  	buf->f_bfree = buf->f_bavail = buf->f_ffree =
>  		omfs_count_free(s);
> +
>  	return 0;
>  }

-- 
Bob Copeland %% www.bobcopeland.com


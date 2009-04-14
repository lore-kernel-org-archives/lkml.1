Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZDNHoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZDNHoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZDNHn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:43:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZDNHn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:43:58 -0400
Date: Tue, 14 Apr 2009 09:43:57 +0200
From: Jan Kara <jack@suse.cz>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: fix missing mutex_unlock in error path
Message-ID: <20090414074356.GC398@duck.suse.cz>
References: <20090414073631.GA4145@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414073631.GA4145@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Tue 14-04-09 16:36:31, Akinobu Mita wrote:
> Add missing mutex_unlock in error path in ext2_quota_write()
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index f983225..5c4afe6 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1395,8 +1395,10 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
>  		blk++;
>  	}
>  out:
> -	if (len == towrite)
> +	if (len == towrite) {
> +		mutex_unlock(&inode->i_mutex);
>  		return err;
> +	}
>  	if (inode->i_size < off+len-towrite)
>  		i_size_write(inode, off+len-towrite);
>  	inode->i_version++;
  Thanks for the patch but I already have this patch in my quota tree from
Dan Carpenter...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0BKLZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 06:25:17 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48054 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab0BKLZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 06:25:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=rrIKzsa1urRxrzZnFrrJWtUU8+zo0JacordbZqTQPr/XAAfmpxIFyXOlUaXi/6Ypd7
         xWalLegMBK4HaUUvjc+v6LIi2Ih+MO9YVMH3D/es9dWB2IiUyROX8nbInNMdgP74jO1z
         anstcnrx8aBjYhOsi5d6j/qqS+NuSfoMONaIw=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/4] block: support compat discard mode by default.
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
	<1265885870-21858-1-git-send-email-dmonakhov@openvz.org>
Date: Thu, 11 Feb 2010 14:25:09 +0300
In-Reply-To: <1265885870-21858-1-git-send-email-dmonakhov@openvz.org> (Dmitry
	Monakhov's message of "Thu, 11 Feb 2010 13:57:50 +0300")
Message-ID: <87mxzgqaju.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> Currently there are many filesystems which has implemented
> discard support, but ssd discs not widely used yet.
> Let's allow user to use compat discard mode by default.
> After this feature is enabled by default for all devices which has
> no native discard support it will be possible to use this feature
> simply by passing appropriate mount option to fs (-odiscard in ext4)
BTW i've run tested ext4 with -odiscard option, and it survived more
24hour of stress tests test which consists of fsstress, compilation,
and etc
>
> This default option has many advantages:
> - Hope that this helps in real filesystem testing.
> - People who are crazy about data security whould be really happy.
> - Virtual machine developers also would like this feature.
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  include/linux/blkdev.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c762c9f..d7d028c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1010,7 +1010,7 @@ static inline int sb_issue_discard(struct super_block *sb,
>  	block <<= (sb->s_blocksize_bits - 9);
>  	nr_blocks <<= (sb->s_blocksize_bits - 9);
>  	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
> -				    DISCARD_FL_BARRIER);
> +				    DISCARD_FL_BARRIER|DISCARD_FL_COMPAT);
>  }
>  
>  extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);

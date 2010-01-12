Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959Ab0ALJsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0ALJsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865Ab0ALJsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:48:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab0ALJsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:48:21 -0500
Subject: Re: [PATCH] gfs2: Fix refcnt leak on gfs2_follow_link() error path
From: Steven Whitehouse <swhiteho@redhat.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <87iqb8jxo6.fsf@devron.myhome.or.jp>
References: <87iqb8jxo6.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 12 Jan 2010 09:51:05 +0000
Message-ID: <1263289865.2738.6.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the patch. I've pushed it into the GFS2 -fixes tree,

Steve.

On Tue, 2010-01-12 at 03:36 +0900, OGAWA Hirofumi wrote:
> If ->follow_link handler return the error, it should decrement
> nd->path refcnt.
> 
> This patch fix it.
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  fs/gfs2/ops_inode.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -puN fs/gfs2/ops_inode.c~namei-gfs2-follow_link-fix fs/gfs2/ops_inode.c
> --- linux-2.6/fs/gfs2/ops_inode.c~namei-gfs2-follow_link-fix	2010-01-12 00:15:12.000000000 +0900
> +++ linux-2.6-hirofumi/fs/gfs2/ops_inode.c	2010-01-12 00:15:12.000000000 +0900
> @@ -1086,7 +1086,8 @@ static void *gfs2_follow_link(struct den
>  		error = vfs_follow_link(nd, buf);
>  		if (buf != array)
>  			kfree(buf);
> -	}
> +	} else
> +		path_put(&nd->path);
>  
>  	return ERR_PTR(error);
>  }
> _
> 



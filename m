Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZBMNeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZBMNeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbZBMNeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:34:00 -0500
Received: from cet.com.ru ([195.178.208.66]:43273 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759399AbZBMNd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:33:59 -0500
Date: Fri, 13 Feb 2009 16:33:49 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next 1/2] pohmelfs: fix build breakage
Message-ID: <20090213133349.GH23879@ioremap.net>
References: <20090213125357.GA7003@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213125357.GA7003@orion>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 03:53:57PM +0300, Alexander Beregalov (a.beregalov@gmail.com) wrote:
> drivers/staging/pohmelfs/inode.c:982: error: implicit declaration of
> function 'DQUOT_TRANSFER'
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Looks good, thank you.

> ---
> 
>  drivers/staging/pohmelfs/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
> index 0980c3c..908fc64 100644
> --- a/drivers/staging/pohmelfs/inode.c
> +++ b/drivers/staging/pohmelfs/inode.c
> @@ -979,7 +979,7 @@ int pohmelfs_setattr_raw(struct inode *inode, struct iattr *attr)
>  
>  	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
>  	    (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
> -		err = DQUOT_TRANSFER(inode, attr) ? -EDQUOT : 0;
> +		err = vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
>  		if (err)
>  			goto err_out_exit;
>  	}

-- 
	Evgeniy Polyakov

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbZKDHGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbZKDHGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZKDHGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:06:17 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56079 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbZKDHGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:06:17 -0500
To: Jens Axboe <jens.axboe@oracle.com>
CC: yodor1@gmail.com, linux-kernel@vger.kernel.org
In-reply-to: <20091103104044.GC22235@kernel.dk> (message from Jens Axboe on
	Tue, 3 Nov 2009 11:40:44 +0100)
Subject: Re: kernel BUG at mm/highmem.c:259
References: <4AEF4181.9080100@gmail.com> <20091103104044.GC22235@kernel.dk>
Message-Id: <E1N5Zwf-0005r9-Fn@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Nov 2009 08:06:17 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009, Jens Axboe wrote:
> Looks like another victim of the confusing kmap() vs kmap_atomic() API
> differences.
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index a3492f7..8a219bd 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1599,7 +1599,7 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
>  			kaddr += copy;
>  		}
>  
> -		kunmap(map);
> +		kunmap(page);
>  	}
>  
>  	return 0;

Todor, thanks for the bug report!  Jens, can I add your Signed-off-by?

Thanks,
Miklos

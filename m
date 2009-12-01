Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbZLAQzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbZLAQzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZLAQzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:55:31 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52335 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbZLAQza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:55:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IZMeCT/e40kuts3GImwFgXTk8jLr2Rj8XVrqGajl/JxP+vHlkVI0u0sZirXIRufFMV
         Sl39p5tRLrswsaVHaKs8BIfAnB9ShTq/4VD0fqxup82fZOHMvL7gUQiXeCmpgy1O/EwP
         wLtumsLapScy69HyhcDI8xCE0dcbSwEgmfbfo=
Date: Tue, 1 Dec 2009 17:55:11 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [Patch] fs: remove a useless BUG()
Message-ID: <20091201165440.GA2688@joi.lan>
References: <20091201023714.3863.92566.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201023714.3863.92566.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 09:34:14PM -0500, Amerigo Wang wrote:
> This BUG() is suspicious, it makes its following statements
> unreachable, 
only when CONFIG_BUG=y

> and it seems to be useless, since the caller
> of this function already handles the failure properly.
because this function can return NULL in other codepath

> Remove it.
I don't know why this BUG() is there (and maybe it's not really
needed), but your rationale is wrong.

> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> 
> ---
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 6fa5302..ac111d7 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1041,7 +1041,6 @@ grow_dev_page(struct block_device *bdev, sector_t block,
>  	return page;
>  
>  failed:
> -	BUG();
>  	unlock_page(page);
>  	page_cache_release(page);
>  	return NULL;
> --

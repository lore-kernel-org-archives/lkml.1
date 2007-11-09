Return-Path: <linux-kernel-owner+w=401wt.eu-S1763196AbXKIP0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763196AbXKIP0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760358AbXKIP0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:26:39 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35723 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760130AbXKIP0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:26:38 -0500
Date: Fri, 9 Nov 2007 10:26:20 -0500
Message-Id: <200711091526.lA9FQKFe022018@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm] unionfs: clear partial read 
In-reply-to: Your message of "Fri, 09 Nov 2007 07:31:07 GMT."
             <Pine.LNX.4.64.0711090728130.22720@blonde.wat.veritas.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0711090728130.22720@blonde.wat.veritas.com>, Hugh Dickins writes:
> unionfs_do_readpage forgot to clear the rest of the page when vfs_read
> does not fill the page: fix that.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> 
>  fs/unionfs/mmap.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- 2.6.24-rc1-mm1/fs/unionfs/mmap.c	2007-11-04 13:48:02.000000000 +0000
> +++ linux/fs/unionfs/mmap.c	2007-11-06 13:51:02.000000000 +0000
> @@ -176,7 +176,8 @@ static int unionfs_do_readpage(struct fi
>  	err = vfs_read(lower_file, page_data, PAGE_CACHE_SIZE,
>  		       &lower_file->f_pos);
>  	set_fs(old_fs);
> -
> +	if (err >= 0 && err < PAGE_CACHE_SIZE)
> +		memset(page_data + err, 0, PAGE_CACHE_SIZE - err);
>  	kunmap(page);
>  
>  	if (err < 0)

Agreed.

Erez.

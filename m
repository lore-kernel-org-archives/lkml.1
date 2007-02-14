Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbXBNV6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbXBNV6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbXBNV6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:58:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48055 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658AbXBNV6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:58:03 -0500
Date: Wed, 14 Feb 2007 13:58:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] VM: invalidate_inode_pages2_range() should not exit
 early
Message-Id: <20070214135801.95f8bbdd.akpm@linux-foundation.org>
In-Reply-To: <20070213074335.24191.51525.stgit@heimdal.trondhjem.org>
References: <20070213074335.24191.51525.stgit@heimdal.trondhjem.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007 23:43:35 -0800
Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> Fix invalidate_inode_pages2_range() so that it does not immediately exit
> just because a single page in the specified range could not be removed.
> 

One man's "fix" is another man's "slow down" ;)

Could we please have a description of why this change is needed?

> ---
> 
>  mm/truncate.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index ebf3fcb..0f4b6d1 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -375,10 +375,10 @@ int invalidate_inode_pages2_range(struct
>  
>  	pagevec_init(&pvec, 0);
>  	next = start;
> -	while (next <= end && !ret && !wrapped &&
> +	while (next <= end && !wrapped &&
>  		pagevec_lookup(&pvec, mapping, next,
>  			min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
> -		for (i = 0; !ret && i < pagevec_count(&pvec); i++) {
> +		for (i = 0; i < pagevec_count(&pvec); i++) {
>  			struct page *page = pvec.pages[i];
>  			pgoff_t page_index;
>  

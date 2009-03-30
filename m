Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZC3IR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZC3IR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 04:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZC3IRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 04:17:14 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:1560 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752202AbZC3IRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 04:17:13 -0400
Message-ID: <49D07F4B.8060203@panasas.com>
Date: Mon, 30 Mar 2009 11:14:03 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH -next] exofs: fix printk format warnings
References: <20090326190130.54fc6fde.sfr@canb.auug.org.au> <49CBF73E.2010808@oracle.com>
In-Reply-To: <49CBF73E.2010808@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Mar 2009 08:15:55.0918 (UTC) FILETIME=[BFEA02E0:01C9B10F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2009 11:44 PM, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix exofs printk format warnings:
> 
> fs/exofs/inode.c:184: warning: format '%zx' expects type 'size_t', but argument 6 has type 'long unsigned int'
> fs/exofs/inode.c:291: warning: format '%zx' expects type 'size_t', but argument 6 has type 'long unsigned int'
> fs/exofs/inode.c:373: warning: format '%zx' expects type 'size_t', but argument 7 has type 'long unsigned int'
> fs/exofs/inode.c:461: warning: format '%zx' expects type 'size_t', but argument 6 has type 'long unsigned int'
> fs/exofs/inode.c:534: warning: format '%zx' expects type 'size_t', but argument 7 has type 'long unsigned int'
> fs/exofs/inode.c:610: warning: format '%zx' expects type 'size_t', but argument 5 has type 'long unsigned int'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Boaz Harrosh <bharrosh@panasas.com>

Thanks, much obliged.

Applied, it will be pushed to linux-next and for-linus branches as part of the
2.6.30 patchset. (Later today)

Boaz

> ---
>  fs/exofs/inode.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- linux-next-20090325.orig/fs/exofs/inode.c
> +++ linux-next-20090325/fs/exofs/inode.c
> @@ -182,7 +182,7 @@ static int __readpages_done(struct osd_r
>  		good_bytes = pcol->length - resid;
>  
>  	EXOFS_DBGMSG("readpages_done(%ld) good_bytes=%llx"
> -		     " length=%zx nr_pages=%u\n",
> +		     " length=%lx nr_pages=%u\n",
>  		     pcol->inode->i_ino, _LLU(good_bytes), pcol->length,
>  		     pcol->nr_pages);
>  
> @@ -288,7 +288,7 @@ static int read_exec(struct page_collect
>  
>  	atomic_inc(&pcol->sbi->s_curr_pending);
>  
> -	EXOFS_DBGMSG("read_exec obj=%llx start=%llx length=%zx\n",
> +	EXOFS_DBGMSG("read_exec obj=%llx start=%llx length=%lx\n",
>  		  obj.id, _LLU(i_start), pcol->length);
>  
>  	/* pages ownership was passed to pcol_copy */
> @@ -371,7 +371,7 @@ try_again:
>  	ret = pcol_add_page(pcol, page, len);
>  	if (ret) {
>  		EXOFS_DBGMSG("Failed pcol_add_page pages[i]=%p "
> -			  "len=%zx nr_pages=%u length=%zx\n",
> +			  "len=%zx nr_pages=%u length=%lx\n",
>  			  page, len, pcol->nr_pages, pcol->length);
>  
>  		/* split the request, and start again with current page */
> @@ -459,7 +459,7 @@ static void writepages_done(struct osd_r
>  		good_bytes = pcol->length - resid;
>  
>  	EXOFS_DBGMSG("writepages_done(%lx) good_bytes=%llx"
> -		     " length=%zx nr_pages=%u\n",
> +		     " length=%lx nr_pages=%u\n",
>  		     pcol->inode->i_ino, _LLU(good_bytes), pcol->length,
>  		     pcol->nr_pages);
>  
> @@ -531,7 +531,7 @@ static int write_exec(struct page_collec
>  	}
>  
>  	atomic_inc(&pcol->sbi->s_curr_pending);
> -	EXOFS_DBGMSG("write_exec(%lx, %lx) start=%llx length=%zx\n",
> +	EXOFS_DBGMSG("write_exec(%lx, %lx) start=%llx length=%lx\n",
>  		  pcol->inode->i_ino, pcol->pg_first, _LLU(i_start),
>  		  pcol->length);
>  	/* pages ownership was passed to pcol_copy */
> @@ -608,7 +608,7 @@ try_again:
>  	ret = pcol_add_page(pcol, page, len);
>  	if (unlikely(ret)) {
>  		EXOFS_DBGMSG("Failed pcol_add_page "
> -			     "nr_pages=%u total_length=%zx\n",
> +			     "nr_pages=%u total_length=%lx\n",
>  			     pcol->nr_pages, pcol->length);
>  
>  		/* split the request, next loop will start again */


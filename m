Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbXEUNYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbXEUNYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXEUNYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:24:10 -0400
Received: from pat.uio.no ([129.240.10.15]:47687 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334AbXEUNYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:24:09 -0400
Subject: Re: [PATCH] 2.6.21: nfs_readpages: Add missing braces
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64N.0705211402170.8263@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0705211402170.8263@blysk.ds.pg.gda.pl>
Content-Type: text/plain
Date: Mon, 21 May 2007 09:24:05 -0400
Message-Id: <1179753845.6535.9.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.095)
X-UiO-Scanned: 4BD674BE2DD855813B35AA7AAEFAD2CF4062EB7C
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 920 total 1850347 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 14:09 +0100, Maciej W. Rozycki wrote:
> A change a while ago added a call to gather statistics to a conditional 
> statement, but braces were missed on that occasion resulting in a change 
> of semanticts.  This a change to rectify.

So you are proposing this as a stable update? It won't apply on
2.6.22-rc2.

Cheers
  Trond

> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  It should be obvious -- please apply.
> 
>   Maciej
> 
> patch-mips-2.6.18-20060920-nfs_readpages-0
> diff -up --recursive --new-file linux-mips-2.6.18-20060920.macro/fs/nfs/read.c linux-mips-2.6.18-20060920/fs/nfs/read.c
> --- linux-mips-2.6.18-20060920.macro/fs/nfs/read.c	2006-09-20 14:20:24.000000000 +0000
> +++ linux-mips-2.6.18-20060920/fs/nfs/read.c	2007-05-20 15:01:31.000000000 +0000
> @@ -696,9 +696,10 @@ int nfs_readpages(struct file *filp, str
>  	ret = read_cache_pages(mapping, pages, readpage_async_filler, &desc);
>  	if (!list_empty(&head)) {
>  		int err = nfs_pagein_list(&head, server->rpages);
> -		if (!ret)
> +		if (!ret) {
>  			nfs_add_stats(inode, NFSIOS_READPAGES, err);
>  			ret = err;
> +		}
>  	}
>  	put_nfs_open_context(desc.ctx);
>  	return ret;


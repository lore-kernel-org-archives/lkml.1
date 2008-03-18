Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYCRL2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYCRL2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYCRL1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:27:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34751 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYCRL1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:27:50 -0400
Subject: Re: [patch 1/8] mm: bdi: export bdi_writeout_inc()
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080317191941.332720129@szeredi.hu>
References: <20080317191908.123631326@szeredi.hu>
	 <20080317191941.332720129@szeredi.hu>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 12:27:40 +0100
Message-Id: <1205839660.8514.340.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-17 at 20:19 +0100, Miklos Szeredi wrote:
> plain text document attachment (export_bdi_writeout_inc.patch)
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Fuse needs this for writable mmap support.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  include/linux/backing-dev.h |    2 ++
>  mm/page-writeback.c         |   10 ++++++++++
>  2 files changed, 12 insertions(+)
> 
> Index: linux/include/linux/backing-dev.h
> ===================================================================
> --- linux.orig/include/linux/backing-dev.h	2008-03-17 18:24:13.000000000 +0100
> +++ linux/include/linux/backing-dev.h	2008-03-17 18:24:36.000000000 +0100
> @@ -134,6 +134,8 @@ static inline s64 bdi_stat_sum(struct ba
>  	return sum;
>  }
>  
> +extern void bdi_writeout_inc(struct backing_dev_info *bdi);
> +
>  /*
>   * maximal error of a stat counter.
>   */
> Index: linux/mm/page-writeback.c
> ===================================================================
> --- linux.orig/mm/page-writeback.c	2008-03-17 18:24:13.000000000 +0100
> +++ linux/mm/page-writeback.c	2008-03-17 18:24:36.000000000 +0100
> @@ -168,6 +168,16 @@ static inline void __bdi_writeout_inc(st
>  			      bdi->max_prop_frac);
>  }
>  
> +void bdi_writeout_inc(struct backing_dev_info *bdi)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__bdi_writeout_inc(bdi);
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL(bdi_writeout_inc);
> +

May I ask to make this a _GPL export, please? 


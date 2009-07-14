Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZGNSZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZGNSZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZGNSZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:25:48 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:54234 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754774AbZGNSZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:25:48 -0400
X-Trace: 226139086/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.8.158/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.8.158
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAA9rXEpPRQie/2dsb2JhbACBUdEYgjWBUwU
X-IronPort-AV: E=Sophos;i="4.42,398,1243810800"; 
   d="scan'208";a="226139086"
Date: Tue, 14 Jul 2009 19:24:54 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] shmem: call set_page_dirty() with locked page
In-Reply-To: <20090714092926.GA23969@localhost>
Message-ID: <Pine.LNX.4.64.0907141918380.10805@sister.anvils>
References: <20090714092926.GA23969@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009, Wu Fengguang wrote:
> Here set_page_dirty() can be moved into the page lock.

Indeed it can, but you've forgotten to mention why you think
that would be a good thing?  All I can see is that it would
very very slightly increase the page's lock hold time, which
wouldn't be an improvement: what improvement are you making?

Hugh

> 
> CC: Hugh Dickins <hugh@veritas.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/shmem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux.orig/mm/shmem.c
> +++ linux/mm/shmem.c
> @@ -1630,8 +1630,8 @@ shmem_write_end(struct file *file, struc
>  	if (pos + copied > inode->i_size)
>  		i_size_write(inode, pos + copied);
>  
> -	unlock_page(page);
>  	set_page_dirty(page);
> +	unlock_page(page);
>  	page_cache_release(page);
>  
>  	return copied;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbXLJOEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbXLJOEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 09:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbXLJOE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 09:04:29 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:51258 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755141AbXLJOE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 09:04:27 -0500
Date: Mon, 10 Dec 2007 15:04:26 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 33/42] MM: extern for drop_pagecache_sb
Message-ID: <20071210140426.GL20441@stusta.de>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu> <1197254557468-git-send-email-ezk@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1197254557468-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 09:42:06PM -0500, Erez Zadok wrote:
> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> ---
>  include/linux/mm.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1b7b95c..fc61bd3 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
>...
> @@ -1135,6 +1136,7 @@ int drop_caches_sysctl_handler(struct ctl_table *, int, struct file *,
>  					void __user *, size_t *, loff_t *);
>  unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
>  			unsigned long lru_pages);
> +extern void drop_pagecache_sb(struct super_block *);
>  void drop_pagecache(void);
>  void drop_slab(void);

This breaks compilation (and therefore bisecting) until the function 
becomes non-static in patch #36.

Please merge patches #33 and #36 into one patch.

That's not terribly important now that you've sent the patches for 
review, but keep in mind that the tree should compile at all stages for 
making bisecting possible when preparing the final submission.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


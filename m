Return-Path: <linux-kernel-owner+w=401wt.eu-S932684AbZJOCWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbZJOCWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 22:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762074AbZJOCW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 22:22:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58368 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761371AbZJOCW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 22:22:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 15 Oct 2009 11:19:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/9] swap_info: miscellaneous minor cleanups
Message-Id: <20091015111924.01c6b36f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0910150149160.3291@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
	<Pine.LNX.4.64.0910150149160.3291@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 01:50:54 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> Move CONFIG_MIGRATION's swapdev_block() into the main CONFIG_MIGRATION
> block, remove extraneous whitespace and return, fix typo in a comment.
> 
CONFIG_HIBERNATION ?


> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> 
>  mm/swapfile.c |   51 ++++++++++++++++++++++--------------------------
>  1 file changed, 24 insertions(+), 27 deletions(-)
> 
> --- si3/mm/swapfile.c	2009-10-14 21:26:22.000000000 +0100
> +++ si4/mm/swapfile.c	2009-10-14 21:26:32.000000000 +0100
> @@ -519,9 +519,9 @@ swp_entry_t get_swap_page_of_type(int ty
>  	return (swp_entry_t) {0};
>  }
>  
> -static struct swap_info_struct * swap_info_get(swp_entry_t entry)
> +static struct swap_info_struct *swap_info_get(swp_entry_t entry)
>  {
> -	struct swap_info_struct * p;
> +	struct swap_info_struct *p;
>  	unsigned long offset, type;
>  
>  	if (!entry.val)
> @@ -599,7 +599,7 @@ static int swap_entry_free(struct swap_i
>   */
>  void swap_free(swp_entry_t entry)
>  {
> -	struct swap_info_struct * p;
> +	struct swap_info_struct *p;
>  
>  	p = swap_info_get(entry);
>  	if (p) {
> @@ -629,7 +629,6 @@ void swapcache_free(swp_entry_t entry, s
>  		}
>  		spin_unlock(&swap_lock);
>  	}
> -	return;
>  }
>  
>  /*
> @@ -783,6 +782,21 @@ int swap_type_of(dev_t device, sector_t
>  }
>  
>  /*
> + * Get the (PAGE_SIZE) block corresponding to given offset on the swapdev
> + * corresponding to given index in swap_info (swap type).
> + */
> +sector_t swapdev_block(int type, pgoff_t offset)
> +{
> +	struct block_device *bdev;
> +
> +	if ((unsigned int)type >= nr_swapfiles)
> +		return 0;
> +	if (!(swap_info[type]->flags & SWP_WRITEOK))
> +		return 0;
> +	return map_swap_page(swp_entry(type, offset), &bdev);
> +}
> +
> +/*
>   * Return either the total number of swap pages of given type, or the number
>   * of free pages of that type (depending on @free)
>   *
> @@ -805,7 +819,7 @@ unsigned int count_swap_pages(int type,
>  	spin_unlock(&swap_lock);
>  	return n;
>  }
> -#endif
> +#endif /* CONFIG_HIBERNATION */
>  
>  /*
>   * No need to decide whether this PTE shares the swap entry with others,
> @@ -1317,23 +1331,6 @@ sector_t map_swap_page(swp_entry_t entry
>  	}
>  }
>  
> -#ifdef CONFIG_HIBERNATION
> -/*
> - * Get the (PAGE_SIZE) block corresponding to given offset on the swapdev
> - * corresponding to given index in swap_info (swap type).
> - */
> -sector_t swapdev_block(int type, pgoff_t offset)
> -{
> -	struct block_device *bdev;
> -
> -	if ((unsigned int)type >= nr_swapfiles)
> -		return 0;
> -	if (!(swap_info[type]->flags & SWP_WRITEOK))
> -		return 0;
> -	return map_swap_page(swp_entry(type, offset), &bdev);
> -}
> -#endif /* CONFIG_HIBERNATION */
> -
>  /*
>   * Free all of a swapdev's extent information
>   */
> @@ -1525,12 +1522,12 @@ bad_bmap:
>  
>  SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  {
> -	struct swap_info_struct * p = NULL;
> +	struct swap_info_struct *p = NULL;
>  	unsigned short *swap_map;
>  	struct file *swap_file, *victim;
>  	struct address_space *mapping;
>  	struct inode *inode;
> -	char * pathname;
> +	char *pathname;
>  	int i, type, prev;
>  	int err;
>  
> @@ -1782,7 +1779,7 @@ late_initcall(max_swapfiles_check);
>   */
>  SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  {
> -	struct swap_info_struct * p;
> +	struct swap_info_struct *p;
>  	char *name = NULL;
>  	struct block_device *bdev = NULL;
>  	struct file *swap_file = NULL;
> @@ -2117,7 +2114,7 @@ void si_swapinfo(struct sysinfo *val)
>   */
>  static int __swap_duplicate(swp_entry_t entry, bool cache)
>  {
> -	struct swap_info_struct * p;
> +	struct swap_info_struct *p;
>  	unsigned long offset, type;
>  	int result = -EINVAL;
>  	int count;
> @@ -2186,7 +2183,7 @@ void swap_duplicate(swp_entry_t entry)
>  /*
>   * @entry: swap entry for which we allocate swap cache.
>   *
> - * Called when allocating swap cache for exising swap entry,
> + * Called when allocating swap cache for existing swap entry,
>   * This can return error codes. Returns 0 at success.
>   * -EBUSY means there is a swap cache.
>   * Note: return code is different from swap_duplicate().
> 


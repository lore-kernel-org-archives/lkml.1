Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0BOQBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:01:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:36404 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab0BOQBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:01:22 -0500
Date: Tue, 16 Feb 2010 03:01:08 +1100
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com
Subject: Re: [PATCH 1/3] radix-tree: Implement function
 radix_tree_gang_tag_if_tagged
Message-ID: <20100215160108.GT5723@laptop>
References: <1265929584-5080-1-git-send-email-jack@suse.cz>
 <1265929584-5080-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265929584-5080-2-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 12:06:22AM +0100, Jan Kara wrote:
> Implement function for setting one tag if another tag is set
> for each item in given range.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/linux/radix-tree.h |    3 ++
>  lib/radix-tree.c           |   82 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
> index c5da749..41fa087 100644
> --- a/include/linux/radix-tree.h
> +++ b/include/linux/radix-tree.h
> @@ -185,6 +185,9 @@ unsigned int
>  radix_tree_gang_lookup_tag_slot(struct radix_tree_root *root, void ***results,
>  		unsigned long first_index, unsigned int max_items,
>  		unsigned int tag);
> +unsigned long radix_tree_gang_tag_if_tagged(struct radix_tree_root *root,
> +		unsigned long first_index, unsigned long last_index,
> +		unsigned int fromtag, unsigned int totag);

Really minor thing here, I think I called my equivalent something
like radix_tree_tag_set_if_tagged. We don't use tag/untag naming
but tag_set/tag_clear.

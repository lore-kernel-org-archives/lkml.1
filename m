Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZFDEcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZFDEcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 00:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZFDEcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 00:32:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:21119 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZFDEcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 00:32:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,302,1241420400"; 
   d="scan'208";a="150464328"
Date: Thu, 4 Jun 2009 12:32:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "npiggin@suse.de" <npiggin@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [12/16] Refactor truncate to allow direct truncating
	of page
Message-ID: <20090604043208.GB15682@localhost>
References: <20090603846.816684333@firstfloor.org> <20090603184646.B915B1D0292@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603184646.B915B1D0292@basil.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 02:46:46AM +0800, Andi Kleen wrote:
> 
> From: Nick Piggin <npiggin@suse.de>
> 
> Extract out truncate_inode_page() out of the truncate path so that
> it can be used by memory-failure.c
> 
> [AK: description, headers, fix typos]
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/mm.h |    2 ++
>  mm/truncate.c      |   24 ++++++++++++------------
>  2 files changed, 14 insertions(+), 12 deletions(-)
> 
> Index: linux/mm/truncate.c
> ===================================================================
> --- linux.orig/mm/truncate.c	2009-06-03 19:37:38.000000000 +0200
> +++ linux/mm/truncate.c	2009-06-03 20:13:43.000000000 +0200
> @@ -135,6 +135,16 @@
>  	return ret;
>  }
>  
> +void truncate_inode_page(struct address_space *mapping, struct page *page)
> +{
> +	if (page_mapped(page)) {
> +		unmap_mapping_range(mapping,
> +		  (loff_t)page->index<<PAGE_CACHE_SHIFT,
> +		  PAGE_CACHE_SIZE, 0);
> +	}
> +	truncate_complete_page(mapping, page);
> +}
> +

Small style cleanup:

---
 mm/truncate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- sound-2.6.orig/mm/truncate.c
+++ sound-2.6/mm/truncate.c
@@ -139,8 +139,8 @@ void truncate_inode_page(struct address_
 {
 	if (page_mapped(page)) {
 		unmap_mapping_range(mapping,
-		  (loff_t)page->index<<PAGE_CACHE_SHIFT,
-		  PAGE_CACHE_SIZE, 0);
+				    (loff_t)page->index << PAGE_CACHE_SHIFT,
+				    PAGE_CACHE_SIZE, 0);
 	}
 	truncate_complete_page(mapping, page);
 }

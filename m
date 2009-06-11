Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbZFKFdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbZFKFdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZFKFdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:33:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41021 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbZFKFc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:32:59 -0400
Date: Thu, 11 Jun 2009 14:31:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.org.uk>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v3] swap: virtual swap readahead
Message-Id: <20090611143122.108468f1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090609190128.GA1785@cmpxchg.org>
References: <20090609190128.GA1785@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 21:01:28 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:
> [resend with lists cc'd, sorry]
> 
> +static int swap_readahead_ptes(struct mm_struct *mm,
> +			unsigned long addr, pmd_t *pmd,
> +			swp_entry_t *entries,
> +			unsigned long cluster)
> +{
> +	unsigned long window, min, max, limit;
> +	spinlock_t *ptl;
> +	pte_t *ptep;
> +	int i, nr;
> +
> +	window = cluster << PAGE_SHIFT;
> +	min = addr & ~(window - 1);
> +	max = min + cluster;

Johannes, I wonder there is no reason to use "alignment".
I think we just need to read "nearby" pages. Then, this function's
scan range should be

	[addr - window/2, addr + window/2)
or some.

And here, too
> +	if (!entries)	/* XXX: shmem case */
> +		return swapin_readahead_phys(entry, gfp_mask, vma, addr);
> +	pmin = swp_offset(entry) & ~(cluster - 1);
> +	pmax = pmin + cluster;

pmin = swp_offset(entry) - cluster/2.
pmax = swp_offset(entry) + cluster/2.

I'm sorry if I miss a reason for using "alignment".

Thanks,
-Kame



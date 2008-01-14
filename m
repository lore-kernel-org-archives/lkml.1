Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYANQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYANQsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYANQr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:47:57 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:46085 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYANQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:47:56 -0500
Date: Mon, 14 Jan 2008 09:47:55 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] rewrite rd
Message-ID: <20080114164754.GL18741@parisc-linux.org>
References: <20071204042628.GA26636@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204042628.GA26636@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 05:26:28AM +0100, Nick Piggin wrote:
> +static void copy_to_brd(struct brd_device *brd, const void *src,
> +			sector_t sector, size_t n)
> +{
> +	struct page *page;
> +	void *dst;
> +	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
> +	size_t copy;
> +
> +	copy = min((unsigned long)n, PAGE_SIZE - offset);
> +	page = brd_lookup_page(brd, sector);
> +	BUG_ON(!page);
> +
> +	dst = kmap_atomic(page, KM_USER1);
> +	memcpy(dst + offset, src, copy);
> +	kunmap_atomic(dst, KM_USER1);

You're using kmap_atomic, but I see no reason you can't be preempted.
Don't you need to at least disable preemption while you have stuff
atomically kmapped?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

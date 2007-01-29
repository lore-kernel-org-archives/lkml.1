Return-Path: <linux-kernel-owner+w=401wt.eu-S1751063AbXA2LLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063AbXA2LLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbXA2LLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:11:24 -0500
Received: from mail.suse.de ([195.135.220.2]:51458 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbXA2LLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:11:23 -0500
Date: Mon, 29 Jan 2007 12:11:15 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 9/9] mm: fix pagecache write deadlocks
Message-ID: <20070129111115.GA14504@wotan.suse.de>
References: <20070129081905.23584.97878.sendpatchset@linux.site> <20070129082030.23584.72376.sendpatchset@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129082030.23584.72376.sendpatchset@linux.site>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 11:33:03AM +0100, Nick Piggin wrote:
> +		} else {
> +			char *src, *dst;
> +			src = kmap(src_page);
> +			dst = kmap(page);
> +			memcpy(dst + offset,
> +				src + ((unsigned long)buf & ~PAGE_CACHE_MASK),
> +				bytes);
> +			kunmap(page);
> +			kunmap(src_page);
> +			copied = bytes;
> +		}
>  		flush_dcache_page(page);

Hmm, I guess these should use kmap_atomic with KM_USER[01]?

The kmap is from an earlier iteration that wanted to sleep
with the page mapped into kernel.

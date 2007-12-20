Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbXLTPpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbXLTPpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934513AbXLTPXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:23:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45875 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934508AbXLTPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:23:41 -0500
Subject: Re: [rfc][patch] mm: madvise(WILLNEED) for anonymous memory
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>, riel <riel@redhat.com>,
       Lennart Poettering <mztabzr@0pointer.de>
In-Reply-To: <1198163908.6821.33.camel@twins>
References: <1198155938.6821.3.camel@twins>
	 <Pine.LNX.4.64.0712201339010.18399@blonde.wat.veritas.com>
	 <1198162078.6821.27.camel@twins>  <1198162560.6821.30.camel@twins>
	 <1198163908.6821.33.camel@twins>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 16:23:39 +0100
Message-Id: <1198164219.6821.36.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 16:18 +0100, Peter Zijlstra wrote:

> +static int madvise_willneed_anon_pte(pte_t *ptep,
> +		unsigned long start, unsigned long end, void *arg)
> +{
> +	struct vm_area_struct *vma = arg;
> +	struct page *page;
> +
> +	page = read_swap_cache_async(pte_to_swp_entry(*ptep), GFP_KERNEL,

Argh, with HIGHPTE this is done inside a kmap_atomic.

/me goes complicate the code with page pre-allocation..



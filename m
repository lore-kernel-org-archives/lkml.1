Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbXLTO4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbXLTO4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXLTO4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:56:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43977 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbXLTO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:56:02 -0500
Subject: Re: [rfc][patch] mm: madvise(WILLNEED) for anonymous memory
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>, riel <riel@redhat.com>,
       Lennart Poettering <mztabzr@0pointer.de>
In-Reply-To: <1198162078.6821.27.camel@twins>
References: <1198155938.6821.3.camel@twins>
	 <Pine.LNX.4.64.0712201339010.18399@blonde.wat.veritas.com>
	 <1198162078.6821.27.camel@twins>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 15:56:00 +0100
Message-Id: <1198162560.6821.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 15:47 +0100, Peter Zijlstra wrote:
> On Thu, 2007-12-20 at 14:09 +0000, Hugh Dickins wrote:

> > Interesting divergence: make_pages_present faults in writable pages
> > in a writable vma, whereas the file case's force_page_cache_readahead
> > doesn't even insert the pages into the mm.
> 
> Yeah, the find_vma and write fault thing are the reason I didn't use
> make_pages_present.
> 
> I had noticed the difference in pte population between
> force_page_cache_readahead and make_pages_present, but it seemed to me
> that writing a function to walk the page tables and populate the
> swapcache but not populate the ptes wasn't worth the effort.

Ah, another, more important difference:

force_page_cache_readahead will not wait for the read to complete,
whereas get_user_pages() will be fully synchronous.

I think I'd better come up with something else then,..


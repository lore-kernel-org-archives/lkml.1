Return-Path: <linux-kernel-owner+w=401wt.eu-S1760484AbXERPmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760484AbXERPmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbXERPmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:42:36 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50652 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbXERPme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:42:34 -0400
Date: Fri, 18 May 2007 16:42:10 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
In-Reply-To: <20070518040854.GA15654@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0705181633240.24071@blonde.wat.veritas.com>
References: <20070518040854.GA15654@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 18 May 2007 15:42:33.0615 (UTC) FILETIME=[26DC91F0:01C79963]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AG5waWdnaW5Ac3VzZS5kZQBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnAGxpbnV4LWFyY2hAdmdlci5rZXJuZWwub3JnAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, Nick Piggin wrote:
> 
> If we add 8 bytes to struct page on 64-bit machines, it becomes 64 bytes,
> which is quite a nice number for cache purposes.
> 
> However we don't have to let those 8 bytes go to waste: we can use them
> to store the virtual address of the page, which kind of makes sense for
> 64-bit, because they can likely to use complicated memory models.

Sooner rather than later, don't we need those 8 bytes to expand from
atomic_t to atomic64_t _count and _mapcount?  Not that we really need
all 64 bits of both, but I don't know how to work atomically with less.

(Why do I have this sneaking feeling that you're actually wanting
to stick something into the lower bits of page->virtual?)

Hugh

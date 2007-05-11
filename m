Return-Path: <linux-kernel-owner+w=401wt.eu-S1760962AbXEKHnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962AbXEKHnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbXEKHm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:42:57 -0400
Received: from holomorphy.com ([66.93.40.71]:57110 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbXEKHm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:42:56 -0400
Date: Fri, 11 May 2007 00:43:36 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-ID: <20070511074336.GS19966@holomorphy.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com> <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com> <20070511000702.GI31925@holomorphy.com> <20070511010842.GJ31925@holomorphy.com> <Pine.LNX.4.64.0705102208390.15976@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705102208390.15976@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, William Lee Irwin III wrote:
>> Looking more closely at it, the entire attempt to avoid struct page
>> pointers is far beyond pointless. The freeing functions unconditionally
>> require struct page pointers to either be passed or computed and the
>> allocation function's virtual address it returns as a result is not
>> directly usable. The callers all have to do arithmetic on the result.
>> One might as well stash precomputed pfn's (if not paddrs) and vaddrs in
>> page->private and page->mapping, chain them with ->lru (use only .next
>> if you care to stay singly-linked), and handle struct page pointers

On Thu, May 10, 2007 at 10:09:32PM -0700, Christoph Lameter wrote:
> Well then you'd have to rewrite the existing ways of fiddling with page 
> structs. This way all is clear and you fiddle as you want. It just works. 
> Could we get this in? You acked it once already?

I guess I can say I'm microoptimizing things by getting rid of the
lock. I can also do without mucking with fields in the page or
generation numbers given a method of dumping the entire cache for such
catastrophic reorganizations, which is actually better because it makes
change_page_attr() and vmalloc_sync() bear the entire cost, apart from
the loss of the cache in their aftermath. I'll post one of those two in
a follow-up.


-- wli

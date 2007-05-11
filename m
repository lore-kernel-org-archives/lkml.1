Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbXEKFJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbXEKFJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 01:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXEKFJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 01:09:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54643 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754412AbXEKFJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 01:09:33 -0400
Date: Thu, 10 May 2007 22:09:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
In-Reply-To: <20070511010842.GJ31925@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0705102208390.15976@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
 <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com>
 <20070511000702.GI31925@holomorphy.com> <20070511010842.GJ31925@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, William Lee Irwin III wrote:

> Looking more closely at it, the entire attempt to avoid struct page
> pointers is far beyond pointless. The freeing functions unconditionally
> require struct page pointers to either be passed or computed and the
> allocation function's virtual address it returns as a result is not
> directly usable. The callers all have to do arithmetic on the result.
> One might as well stash precomputed pfn's (if not paddrs) and vaddrs in
> page->private and page->mapping, chain them with ->lru (use only .next
> if you care to stay singly-linked), and handle struct page pointers

Well then you'd have to rewrite the existing ways of fiddling with page 
structs. This way all is clear and you fiddle as you want. It just works. 
Could we get this in? You acked it once already?


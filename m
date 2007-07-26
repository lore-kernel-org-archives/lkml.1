Return-Path: <linux-kernel-owner+w=401wt.eu-S933698AbXGZSAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbXGZSAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932101AbXGZSAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:00:14 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:37996 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935498AbXGZSAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:00:11 -0400
Date: Thu, 26 Jul 2007 18:59:21 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       David Gibson <david@gibson.dropbear.id.au>,
       Ken Chen <kenchen@google.com>, Bill Irwin <wli@holomorphy.com>
Subject: Re: [PATCH] Check for compound pages in set_page_dirty()
In-Reply-To: <Pine.LNX.4.64.0707261042390.2335@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0707261855290.13876@blonde.wat.veritas.com>
References: <20070718141533.GA11657@kernel.dk>
 <Pine.LNX.4.64.0707181619200.23261@blonde.wat.veritas.com>
 <20070718182456.GE11657@kernel.dk> <20070718184006.GF11657@kernel.dk>
 <Pine.LNX.4.64.0707182052220.18926@blonde.wat.veritas.com>
 <20070719062934.GT11657@kernel.dk> <Pine.LNX.4.64.0707191720300.10512@blonde.wat.veritas.com>
 <20070723135416.44edc896@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0707261834200.592@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0707261042390.2335@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWdsQHVzLmlibS5jb20AY2xhbWV0ZXJAc2dpLmNvbQBqZW5zLmF4Ym9lQG9yYWNsZS5jb20AYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwB3bGlAaG9sb21vcnBoeS5jb20Aa2VuY2hlbkBnb29nbGUuY29tAGRhdmlkQGdpYnNvbi5kcm9wYmVhci5pZC5hdQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Christoph Lameter wrote:
> On Thu, 26 Jul 2007, Hugh Dickins wrote:
> 
> > I expect we could take that approach in the current kernel, yes
> > (though it would put those compound tests into the bio code that
> > Jens was preferring to remove).  But I think not if your variable
> > page_cache_size went in: imagine an mmap of the tail component page
> > of an order-1 page_cache_size page, and that pte only being dirtied:
> > wouldn't set_page_dirty on that page need to redirect to the head?
> 
> We would need to redirect all of the page state determinations and changes 
> to the head page anyways. So the memory.c code would have to deal with two 
> struct page pointers: One to the head where the state is kept and one to 
> the tail page that contains the actual chunk of data we are interested in. 
> The tail page pointer is only used for address determinations.
> 
> VM functions that manipulate the state of a page (like set_page_dirty) 
> could rely on only getting page heads.

Maybe.  Sounds ugly.  "would": so your patches remain just an RFC?

Hugh

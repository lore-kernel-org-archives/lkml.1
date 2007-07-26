Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbXGZRpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbXGZRpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762037AbXGZRo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:44:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47254 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751267AbXGZRo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:44:56 -0400
Date: Thu, 26 Jul 2007 10:44:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       David Gibson <david@gibson.dropbear.id.au>,
       Ken Chen <kenchen@google.com>, Bill Irwin <wli@holomorphy.com>
Subject: Re: [PATCH] Check for compound pages in set_page_dirty()
In-Reply-To: <Pine.LNX.4.64.0707261834200.592@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0707261042390.2335@schroedinger.engr.sgi.com>
References: <20070718141533.GA11657@kernel.dk>
 <Pine.LNX.4.64.0707181619200.23261@blonde.wat.veritas.com>
 <20070718182456.GE11657@kernel.dk> <20070718184006.GF11657@kernel.dk>
 <Pine.LNX.4.64.0707182052220.18926@blonde.wat.veritas.com>
 <20070719062934.GT11657@kernel.dk> <Pine.LNX.4.64.0707191720300.10512@blonde.wat.veritas.com>
 <20070723135416.44edc896@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0707261834200.592@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Hugh Dickins wrote:

> I expect we could take that approach in the current kernel, yes
> (though it would put those compound tests into the bio code that
> Jens was preferring to remove).  But I think not if your variable
> page_cache_size went in: imagine an mmap of the tail component page
> of an order-1 page_cache_size page, and that pte only being dirtied:
> wouldn't set_page_dirty on that page need to redirect to the head?

We would need to redirect all of the page state determinations and changes 
to the head page anyways. So the memory.c code would have to deal with two 
struct page pointers: One to the head where the state is kept and one to 
the tail page that contains the actual chunk of data we are interested in. 
The tail page pointer is only used for address determinations.

VM functions that manipulate the state of a page (like set_page_dirty) 
could rely on only getting page heads.


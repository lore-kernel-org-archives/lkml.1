Return-Path: <linux-kernel-owner+w=401wt.eu-S936082AbXGWUya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936082AbXGWUya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbXGWUyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:54:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49460 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933924AbXGWUyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:54:21 -0400
Date: Mon, 23 Jul 2007 13:54:16 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       David Gibson <david@gibson.dropbear.id.au>,
       Ken Chen <kenchen@google.com>, Bill Irwin <wli@holomorphy.com>
Subject: Re: [PATCH] Check for compound pages in set_page_dirty()
Message-ID: <20070723135416.44edc896@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707191720300.10512@blonde.wat.veritas.com>
References: <20070718141533.GA11657@kernel.dk>
	<Pine.LNX.4.64.0707181619200.23261@blonde.wat.veritas.com>
	<20070718182456.GE11657@kernel.dk>
	<20070718184006.GF11657@kernel.dk>
	<Pine.LNX.4.64.0707182052220.18926@blonde.wat.veritas.com>
	<20070719062934.GT11657@kernel.dk>
	<Pine.LNX.4.64.0707191720300.10512@blonde.wat.veritas.com>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 18:35:17 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> I didn't see any attention to set_page_dirty in Christoph's
> Large Blocksize (variable page_cachesize) patches, but I expect
> he'd also be wanting set_page_dirty to act on compound_head.

There is no need for special casing if set_page_dirty() is only
ever called for page heads. Make sure that direct I/O does not call
set_page_dirty for tail pages.

A VM_BUG_ON(PageTail(page)) could be used to make sure that this
does not happen in the future?

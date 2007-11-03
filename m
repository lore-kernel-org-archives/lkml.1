Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbXKCSbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbXKCSbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbXKCSbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:31:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43132 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756541AbXKCSbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:31:24 -0400
Date: Sat, 3 Nov 2007 11:31:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0711031127091.5395@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Hugh Dickins wrote:

> The culprit turns out to be __slab_alloc(), where it copes with the race
> that another task has assigned the cpu slab while we were allocating one.
> Don't rush off to load_freelist there: that assumes c->freelist is empty,
> and will lose all of its free slots when c->page->freelist is not empty.
> Instead just do a local allocation from c->freelist when it has one.

Hmmm.. Right. This will require some fixes to the optimizations in mm.

Acked-by: Christoph Lameter <clameter@sgi.com>

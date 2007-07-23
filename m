Return-Path: <linux-kernel-owner+w=401wt.eu-S1765864AbXGWShz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765864AbXGWShz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbXGWShr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:37:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754933AbXGWShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:37:47 -0400
Date: Mon, 23 Jul 2007 11:37:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERP to GFP_LEVEL_MASK
Message-Id: <20070723113712.c0ee29e5.akpm@linux-foundation.org>
In-Reply-To: <1185185020.8197.11.camel@twins>
References: <1185185020.8197.11.camel@twins>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 12:03:40 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Daniel recently spotted that __GFP_ZERO is not (and has never been)
> part of GFP_LEVEL_MASK. I could not find a reason for this in the
> original patch: 3977971c7f09ce08ed1b8d7a67b2098eb732e4cd in the -bk
> tree.

It doesn't make a lot of sense to be passing __GFP_ZERO into slab
allocation functions.  It's not really for the caller to be telling slab
how it should arrange for its new memory to get zeroed.

And the caller of slab functions will need to zero the memory anyway,
because you don't know whether your new object came direct from the page
allocator or if it is recycled memory from a partial slab.

I have a feeling that we did support passing __GFP_ZERO into the slab
allocation functions for a while, but took it out.

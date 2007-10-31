Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbXJaNJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbXJaNJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 09:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbXJaNIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 09:08:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33884 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbXJaNIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 09:08:50 -0400
Subject: Re: [PATCH 03/33] mm: slub: add knowledge of reserve pages
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
In-Reply-To: <1193835258.27652.199.camel@twins>
References: <20071030160401.296770000@chello.nl>
	 <200710312146.03351.nickpiggin@yahoo.com.au>
	 <1193833072.27652.167.camel@twins>
	 <200710312225.07249.nickpiggin@yahoo.com.au>
	 <1193835258.27652.199.camel@twins>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 14:08:43 +0100
Message-Id: <1193836123.27652.209.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-31 at 13:54 +0100, Peter Zijlstra wrote:
> On Wed, 2007-10-31 at 22:25 +1100, Nick Piggin wrote:

> > What I'm saying is that the slab allocator slowpath should always
> > just check watermarks against the current task. Instead of this
> > ->reserve stuff.
> 
> So what you say is to allocate a slab every time we take the slow path,
> even when we already have one?

BTW, a task that does not have reserve permissions will already attempt
to allocate a new slab - this is done to probe the current watermarks.
If this succeeds the reserve status is lifted.



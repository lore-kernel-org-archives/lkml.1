Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbXKJLxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbXKJLxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 06:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXKJLxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 06:53:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35593 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbXKJLxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 06:53:15 -0500
Subject: Re: [patch 1/2] mm: page trylock rename
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071110054343.GA17803@wotan.suse.de>
References: <20071110051222.GA16018@wotan.suse.de>
	 <20071110054343.GA17803@wotan.suse.de>
Content-Type: text/plain
Date: Sat, 10 Nov 2007 12:51:35 +0100
Message-Id: <1194695495.20832.27.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-11-10 at 06:43 +0100, Nick Piggin wrote:
> Here's a little something to make up for the occasional extra cacheline
> write in add_to_page_cache. Saves an atomic operation and 2 memory barriers
> for every add_to_page_cache().
> 
> I suspect lockdepifying the page lock will also barf without this, too...

Yeah, I had a rather ugly trylock_page() in there. Was planning on doing
something similar to this, never got round to actually doing it,
thanks! 

> ---
> Setting and clearing the page locked when inserting it into swapcache /
> pagecache when it has no other references can use non-atomic page flags
> operatoins because no other CPU may be operating on it at this time.
> 
> Also, remove comments in add_to_swap_cache that suggest the contrary, and
> rename it to add_to_swap_cache_lru(), better matching the filemap code,
> and which meaks it more clear that the page has no other references yet.
> 
> Also, the comments in add_to_page_cache aren't really correct. It is not
> just called for new pages, but for tmpfs pages as well. They are locked
> when called, so it is OK for atomic bitflag access, but we can't do
> non-atomic access. Split this into add_to_page_cache_locked, for tmpfs.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


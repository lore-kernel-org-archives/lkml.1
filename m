Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbYEEPYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbYEEPYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbYEEPYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:24:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbYEEPYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:24:15 -0400
Date: Mon, 5 May 2008 08:23:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [rfc][patch 0/3] bootmem2: a memory block-oriented boot time
 allocator
In-Reply-To: <20080505095938.326928514@symbol.fehenstaub.lan>
Message-ID: <alpine.LFD.1.10.0805050820000.32269@woody.linux-foundation.org>
References: <20080505095938.326928514@symbol.fehenstaub.lan>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 May 2008, Johannes Weiner wrote:
> 
> here is a bootmem allocator replacement that uses one bitmap for all
> available pages and works with a model of contiguous memory blocks
> that reside on nodes instead of nodes only as the current allocator
> does.

Won't this have problems with huge non-contiguous areas?

Some setups have traditionally had node memory separated in physical space 
by the high bits of the memory address, and using a single bitmap for such 
things would potentially be basically impossible - even with a single bit 
per page, the "span" of possible pages is potentially just too high, even 
if the nodes themselves don't have tons of memory, because the memory is 
just very spread out - and allocating the initial bitmap may not work 
reliably.

Now, admittedly I don't know if we even support that kind of thing or if 
people really do things that way any more, so maybe it's not an issue.

		Linus

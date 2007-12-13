Return-Path: <linux-kernel-owner+w=401wt.eu-S934066AbXLMWW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066AbXLMWW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761159AbXLMWWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:22:20 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50304 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757431AbXLMWWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:22:19 -0500
Date: Thu, 13 Dec 2007 14:22:18 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071211143336.GA17866@elte.hu>
Message-ID: <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <20071211143336.GA17866@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007, Ingo Molnar wrote:

>     hackbench-10:      1.12             2.99   (166%)
>     hackbench-20:      2.04             6.67   (226%)
>     hackbench-50:      5.03            17.50   (247%)
> 
> and hackbench overhead stands out, by a huge margin. Other stuff is 
> within measurement noise. Neither SLUB nor SLAB debugging was turned on, 
> all other debugging options were off too.

I just came back from vacation. The non linear growth of regression
indicates lock contention somewhere. Must be something special that was 
triggered by hackbench.

We have had a regression like that in 2.6.24 before due to order 1 allocs 
in the network layer. The .24 modifications for SLUB introduced page 
allocator pass through for allocations > PAGESIZE/2. Order 1 allocs could 
serialize on zone locks.

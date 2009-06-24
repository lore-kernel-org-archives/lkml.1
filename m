Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbZFXTQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbZFXTQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZFXTQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:16:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbZFXTQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:16:32 -0400
Date: Wed, 24 Jun 2009 12:16:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: penberg@cs.helsinki.fi, arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090624120617.1e6799b5.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org> <20090624094622.d0b0fd82.akpm@linux-foundation.org> <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com> <20090624105517.904f93da.akpm@linux-foundation.org> <4A426825.80905@cs.helsinki.fi>
 <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Andrew Morton wrote:
>
> My original patch was motiviated by the horror at discovering that
> we're using this thing (which was _never_ supposed to have new users)
> for order>0 allocations.  We've gone backwards.

Don't be silly.

We've always depended on order-1 allocations working. 

You're just totally misguided in your arguments, and you are 
FUNDAMENTALLY WRONG. Your argument is shit, BECAUSE IT IS NOT TRUE!

Lookie here. This is 2.6.0:mm/page_alloc.c:

        do_retry = 0;
        if (!(gfp_mask & __GFP_NORETRY)) {
                if ((order <= 3) || (gfp_mask & __GFP_REPEAT))
                        do_retry = 1;
                if (gfp_mask & __GFP_NOFAIL)
                        do_retry = 1;
        }
        if (do_retry) {
                blk_congestion_wait(WRITE, HZ/50);
                goto rebalance;
        }

Read that. Read if five times. Read it until you understand what it does.

			Linus

PS. Here's a clue: Look at that 'order <= 3' thing. Think about what 
happens EVEN IF __NOFAIL) was not even set!

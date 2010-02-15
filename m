Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0BOKW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 05:22:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:52030 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab0BOKW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 05:22:26 -0500
Date: Mon, 15 Feb 2010 21:22:21 +1100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com, rientjes@google.com
Subject: Re: [PATCH] [1/4] SLAB: Handle node-not-up case in
 fallback_alloc() v2
Message-ID: <20100215102221.GL5723@laptop>
References: <20100211953.850854588@firstfloor.org>
 <20100211205401.002CFB1978@basil.firstfloor.org>
 <20100215060400.GG5723@laptop>
 <20100215100712.GC21783@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215100712.GC21783@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 11:07:12AM +0100, Andi Kleen wrote:
> > This is a better way to go anyway because it really is a proper
> > "fallback" alloc. I think that possibly used to work (ie. kmem_getpages
> > would be able to pass -1 for the node there) but got broken along the
> > line.
> 
> Thanks for the review.
> 
> I should add there's still one open problem: in some cases 
> the oom killer kicks in on hotadd. Still working on that one.
> 
> In general hotadd was mighty bitrotted :/

Yes, that doesn't surprise me. I'm sure you can handle it, but send
some traces if you have problems.

 
> > Although it's not such a hot path to begin with, care to put a branch
> > annotation there?
> 
> pointer == NULL is already default unlikely in gcc
> 
> /* Pointers are usually not NULL.  */
> DEF_PREDICTOR (PRED_POINTER, "pointer", HITRATE (85), 0)
> DEF_PREDICTOR (PRED_TREE_POINTER, "pointer (on trees)", HITRATE (85), 0)

Well I still prefer to annotate it. I think builtin expect is 99%.


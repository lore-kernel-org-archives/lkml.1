Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbXGDHfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbXGDHfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 03:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXGDHfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 03:35:46 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:13986 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbXGDHfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 03:35:45 -0400
Subject: Re: [patch 1/5] avoid tlb gather restarts.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Hugh Dickins <hugh@veritas.com>
Cc: akpm@linux-foundation.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0707031829390.2111@blonde.wat.veritas.com>
References: <20070703111822.418649776@de.ibm.com>
	 <20070703121228.254110263@de.ibm.com>
	 <Pine.LNX.4.64.0707031829390.2111@blonde.wat.veritas.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 04 Jul 2007 09:37:51 +0200
Message-Id: <1183534671.1208.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 18:42 +0100, Hugh Dickins wrote:
> > If need_resched() is false in the inner loop of unmap_vmas it is
> > unnecessary to do a full blown tlb_finish_mmu / tlb_gather_mmu for
> > each ZAP_BLOCK_SIZE ptes. Do a tlb_flush_mmu() instead. That gives
> > architectures with a non-generic tlb flush implementation room for
> > optimization. The tlb_flush_mmu primitive is a available with the
> > generic tlb flush code, the ia64_tlb_flush_mm needs to be renamed
> > and a dummy function is added to arm and arm26.
> > 
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Acked-by: Hugh Dickins <hugh@veritas.com>
> 
> (Looking at it, I see that we could argue that there ought to be a
> need_resched() etc. check after your tlb_flush_mmu() in unmap_vmas,
> in case it's spent a long while in there on some arches; but I don't
> think we have the ZAP_BLOCK_SIZE tuned with any great precision, and
> you'd at worst be doubling the latency there, so let's not worry
> about it.  I write this merely in order to reserve myself an
> "I told you so" if anyone ever notices increased latency ;)

Hmm, we'd have to repeat the longish if statement to make sure we don't
miss a cond_resched after tlb_flush_mmu. I'd rather not do that.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.



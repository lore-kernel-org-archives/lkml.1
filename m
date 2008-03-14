Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbYCNFXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbYCNFXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbYCNFWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:22:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:47437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758699AbYCNFWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:22:41 -0400
From: Neil Brown <neilb@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 14 Mar 2008 16:22:27 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18394.2963.890847.4606@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 00/28] Swap over NFS -v16
In-Reply-To: message from Peter Zijlstra on Monday March 10
References: <20080220144610.548202000@chello.nl>
	<20080223000620.7fee8ff8.akpm@linux-foundation.org>
	<18371.43950.150842.429997@notabene.brown>
	<1204023042.6242.271.camel@lappy>
	<18372.64081.995262.986841@notabene.brown>
	<1204099113.6242.353.camel@lappy>
	<1837 <1204626509.6241.39.camel@lappy>
	<18384.46967.583615.711455@notabene.brown>
	<1204888675.8514.102.camel@twins>
	<18388.50188.552322.780524@notabene.brown>
	<1205140674.8514.152.camel@twins>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday March 10, a.p.zijlstra@chello.nl wrote:
> > 
> > Maybe that depends on the exact semantic of PG_emergency ??
> > I remember you being concerned that PG_emergency never changes between
> > allocation and freeing, and that wouldn't work well with slub.
> > My envisioned semantic has it possibly changing quite often.
> > What it means is:
> >    The last allocation done from this page was in a low-memory
> >    condition.
> 
> Yes, that works, except that we'd need to iterate all pages and clear
> PG_emergency - which would imply tracking all these pages etc..
> 

I don't see why you need to clear PG_emergency at all.
If the semantic is:

> >    The last allocation done from this page was in a low-memory
> >    condition.

Then you only need to (potentially) modify it's value when you
allocate it, or an element within it.

But if it doesn't fit well in the overall picture, then by all means
get rid of it.

> 
> Hmm, right. But for that purpose the names swap_* are a tad misleading.
> I remember hch mentioning this at some point. What would be a more
> suitable naming scheme so we can both use it?

One could argue that "swap" is already a misleading term.
Level 7 Unix used to do swapping.  It would write one process image
out to swap space, and read a different one in.  Moving whole
processes at a time was called swapping.
When this clever idea of only moving pages at a time was introduced (I
think in 4BSD, but possible in 2BSD and elsewhere) it was called
"demand paging" or just "paging".

So we don't have a swap partition any more.  We have a paging
partition.

But everyone calls it 'swap' and we know what it means.  I don't think
there would be a big cost in keeping the swap_ names but allowing them
to be used for occasional things other than swap.
And I suspect you would lose a lot if you tried to use a different
name that people didn't immediately identify with...

NeilBrown

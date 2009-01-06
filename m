Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbZAFInZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbZAFInZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 03:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZAFInR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 03:43:17 -0500
Received: from ns2.suse.de ([195.135.220.15]:34387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbZAFInQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 03:43:16 -0500
Date: Tue, 6 Jan 2009 09:43:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Klotz <peter.klotz@aon.at>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re: BUG: soft lockup - is this XFS problem?)
Message-ID: <20090106084312.GC16738@wotan.suse.de>
References: <49623384.2070801@aon.at> <20090105164135.GC32675@wotan.suse.de> <alpine.LFD.2.00.0901050859430.3057@localhost.localdomain> <20090105180008.GE32675@wotan.suse.de> <alpine.LFD.2.00.0901051027011.3057@localhost.localdomain> <20090105201258.GN6959@linux.vnet.ibm.com> <alpine.LFD.2.00.0901051224110.3057@localhost.localdomain> <20090105215727.GQ6959@linux.vnet.ibm.com> <20090106020550.GA819@wotan.suse.de> <49631877.3090803@aon.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49631877.3090803@aon.at>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 09:38:15AM +0100, Peter Klotz wrote:
> >Index: linux-2.6/include/linux/radix-tree.h
> >===================================================================
> >--- linux-2.6.orig/include/linux/radix-tree.h
> >+++ linux-2.6/include/linux/radix-tree.h
> >@@ -136,7 +136,7 @@ do {						 \
> >  */
> > static inline void *radix_tree_deref_slot(void **pslot)
> > {
> >-	void *ret = *pslot;
> >+	void *ret = rcu_dereference(*pslot);
> > 	if (unlikely(radix_tree_is_indirect_ptr(ret)))
> > 		ret = RADIX_TREE_RETRY;
> > 	return ret;
> >
> >
> 
> The patch above fixes my problem. I did two complete test runs that 
> normally fail rather quickly.

OK, thanks for reporting and testing. 

I think this patch is a candidate for -stable too.

Thanks,
Nick

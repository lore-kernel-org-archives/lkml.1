Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbZCZPqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbZCZPqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757857AbZCZPqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:46:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52757 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbZCZPqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:46:13 -0400
Date: Thu, 26 Mar 2009 16:46:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090326154610.GH27476@kernel.dk>
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA8ADA.3040709@redhat.com> <20090325195747.GC27476@kernel.dk> <Pine.LNX.4.64.0903252036130.8872@blonde.anvils> <20090326085748.GH27476@kernel.dk> <Pine.LNX.4.64.0903261430410.32095@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903261430410.32095@blonde.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26 2009, Hugh Dickins wrote:
> On Thu, 26 Mar 2009, Jens Axboe wrote:
> > On Wed, Mar 25 2009, Hugh Dickins wrote:
> > > 
> > > Tangential question, but am I right in thinking that BIO_RW_BARRIER
> > > similarly bars across all partitions, whereas its WRITE_BARRIER and
> > > DISCARD_BARRIER users would actually prefer it to apply to just one?
> > 
> > All the barriers refer to just that range which the barrier itself
> > references.
> 
> Ah, thank you: then I had a fundamental misunderstanding of them,
> and need to go away and work that out some more.
> 
> Though I didn't read it before asking, doesn't the I/O Barriers section
> of Documentation/block/biodoc.txt give a very different impression?

I'm sensing a miscommunication here... The ordering constraint is across
devices, at least that is how it is implemented. For file system
barriers (like BIO_RW_BARRIER), it could be per-partition instead. Doing
so would involve some changes at the block layer side, not necessarily
trivial. So I think you were asking about ordering, I was answering
about the write guarantee :-)

-- 
Jens Axboe


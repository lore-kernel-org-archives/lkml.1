Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbZCZI7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbZCZI7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbZCZI7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:59:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52620 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbZCZI7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:59:22 -0400
Date: Thu, 26 Mar 2009 09:59:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
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
Message-ID: <20090326085918.GI27476@kernel.dk>
References: <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA8ADA.3040709@redhat.com> <49CA9114.3040205@garzik.org> <49CA9324.6010407@redhat.com> <1238016170.3281.36.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238016170.3281.36.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25 2009, James Bottomley wrote:
> On Wed, 2009-03-25 at 16:25 -0400, Ric Wheeler wrote:
> > Jeff Garzik wrote:
> > > Ric Wheeler wrote:> And, as I am sure that you do know, to add insult 
> > > to injury, FLUSH_CACHE
> > >> is per device (not file system).
> > >>
> > >> When you issue an fsync() on a disk with multiple partitions, you 
> > >> will flush the data for all of its partitions from the write cache....
> > >
> > > SCSI'S SYNCHRONIZE CACHE command already accepts an (LBA, length) 
> > > pair.  We could make use of that.
> > >
> > > And I bet we could convince T13 to add FLUSH CACHE RANGE, if we could 
> > > demonstrate clear benefit.
> > >
> > >     Jeff
> > 
> > How well supported is this in SCSI?  Can we try it out with a commodity 
> > SAS drive?
> 
> What do you mean by well supported?  The way the SCSI standard is
> written, a device can do a complete cache flush when a range flush is
> requested and still be fully standards compliant.  There's no easy way
> to tell if it does a complete cache flush every time other than by
> taking the firmware apart (or asking the manufacturer).

That's the fear of range flushes, if it was added to t13 as well. Unless
that Other OS uses range flushes, most firmware writers would most
likely implement any range as 0...-1 and it wouldn't help us at all. In
fact it would make things worse, as we would have done extra work to
actually find these ranges, unless you went cheap and said 'just flush
this partition'.

-- 
Jens Axboe


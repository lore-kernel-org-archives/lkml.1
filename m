Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbZCZI6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbZCZI6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZCZI5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:57:55 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52586 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbZCZI5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:57:54 -0400
Date: Thu, 26 Mar 2009 09:57:48 +0100
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
Message-ID: <20090326085748.GH27476@kernel.dk>
References: <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA8ADA.3040709@redhat.com> <20090325195747.GC27476@kernel.dk> <Pine.LNX.4.64.0903252036130.8872@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903252036130.8872@blonde.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25 2009, Hugh Dickins wrote:
> On Wed, 25 Mar 2009, Jens Axboe wrote:
> > On Wed, Mar 25 2009, Ric Wheeler wrote:
> > > Jens Axboe wrote:
> > >>
> > >> Another problem is that FLUSH_CACHE sucks. Really. And not just on
> > >> ext3/ordered, generally. Write a 50 byte file, fsync, flush cache and
> > >> wit for the world to finish. Pretty hard to teach people to use a nicer
> > >> fdatasync(), when the majority of the cost now becomes flushing the
> > >> cache of that 1TB drive you happen to have 8 partitions on. Good luck
> > >> with that.
> > >>   
> > > And, as I am sure that you do know, to add insult to injury, FLUSH_CACHE  
> > > is per device (not file system).
> > >
> > > When you issue an fsync() on a disk with multiple partitions, you will  
> > > flush the data for all of its partitions from the write cache....
> > 
> > Exactly, that's what my (vague) 8 partition reference was for :-)
> > A range flush would be so much more palatable.
> 
> Tangential question, but am I right in thinking that BIO_RW_BARRIER
> similarly bars across all partitions, whereas its WRITE_BARRIER and
> DISCARD_BARRIER users would actually prefer it to apply to just one?

All the barriers refer to just that range which the barrier itself
references. The problem with the full device flushes is implementation
on the hardware side, since we can't do small range flushes. So it's not
as-designed, but rather the best we can do...

-- 
Jens Axboe


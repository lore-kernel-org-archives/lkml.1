Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZCYUny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZCYUny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZCYUnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:43:45 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50577 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZCYUno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:43:44 -0400
Date: Wed, 25 Mar 2009 20:41:17 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ric Wheeler <rwheeler@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090325195747.GC27476@kernel.dk>
Message-ID: <Pine.LNX.4.64.0903252036130.8872@blonde.anvils>
References: <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu>
 <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>
 <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>
 <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk>
 <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk>
 <49CA8ADA.3040709@redhat.com> <20090325195747.GC27476@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009, Jens Axboe wrote:
> On Wed, Mar 25 2009, Ric Wheeler wrote:
> > Jens Axboe wrote:
> >>
> >> Another problem is that FLUSH_CACHE sucks. Really. And not just on
> >> ext3/ordered, generally. Write a 50 byte file, fsync, flush cache and
> >> wit for the world to finish. Pretty hard to teach people to use a nicer
> >> fdatasync(), when the majority of the cost now becomes flushing the
> >> cache of that 1TB drive you happen to have 8 partitions on. Good luck
> >> with that.
> >>   
> > And, as I am sure that you do know, to add insult to injury, FLUSH_CACHE  
> > is per device (not file system).
> >
> > When you issue an fsync() on a disk with multiple partitions, you will  
> > flush the data for all of its partitions from the write cache....
> 
> Exactly, that's what my (vague) 8 partition reference was for :-)
> A range flush would be so much more palatable.

Tangential question, but am I right in thinking that BIO_RW_BARRIER
similarly bars across all partitions, whereas its WRITE_BARRIER and
DISCARD_BARRIER users would actually prefer it to apply to just one?

Hugh

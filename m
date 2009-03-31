Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbZCaPaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbZCaPaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760979AbZCaP3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:29:05 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:21302 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762977AbZCaP3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:29:02 -0400
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       david@fromorbit.com, tj@kernel.org
In-Reply-To: <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain>
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org>
	 <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp>
	 <49D0B687.1030407@oss.ntt.co.jp>
	 <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain>
	 <20090330175544.GX5178@kernel.dk>
	 <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain>
	 <20090330185414.GZ5178@kernel.dk>
	 <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain>
	 <20090330201732.GB5178@kernel.dk>
	 <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain>
	 <49D17CA2.5060105@redhat.com>
	 <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain>
	 <49D1FB64.8000505@redhat.com>
	 <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 11:22:56 -0400
Message-Id: <1238512976.12564.9.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49D2355A.0289:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 07:55 -0700, Linus Torvalds wrote:
> 
> On Tue, 31 Mar 2009, Ric Wheeler wrote:
> > 
> > Now you are just being silly. The drive and the write cache - without barriers
> > or similar tagged operations - will almost certainly reorder all of the IO's
> > internally.
> 
> You do realize that the "drive" may not be a drive at all?
> 
> But apparently you don't. You really seem to see just your own case, and 
> have blinders on for everything else.
> 
> That "drive" may be some virtualized device. It may be some super-fancy 
> memory mapped and largely undocumented random flash thing. It might be a 
> network block device, it may be somebody's IO trace dummy layer, it may be 
> anything at all.
> 

The part that we seem to be skipping over in talking about EOPNOTSUPP is
not what do we do when a barrier isn't supported (print a warning and
move on), it's what do we do when a barrier works.  I very much agree
that EOPNOTSUPP tells us almost nothing.

The idea behind the original implementation was that when barriers did
work, we could make some assumptions about how IO would be ordered
around the barrier, and those assumptions would let us optimize things
for the lying cheating cache enabled storage that we all know and love.

It turns out 6 years later that very few people are interested in those
optimizations, and we're probably better off skipping them in favor of
reducing the complexity of the code involved.

Jens has a little burial site all prepped for pdflush in his yard,
dumping EOPNOTSUPP in there too wouldn't be a bad thing.

-chris



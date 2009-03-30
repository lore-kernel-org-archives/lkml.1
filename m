Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbZC3UUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbZC3UUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760872AbZC3UTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:19:53 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:60584 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760836AbZC3UTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:19:51 -0400
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
From: Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       david@fromorbit.com, tj@kernel.org
In-Reply-To: <87ljqmlqm5.fsf@basil.nowhere.org>
References: <20090329082507.GA4242@infradead.org>
	 <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp>
	 <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp>
	 <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp>
	 <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain>
	 <20090330175544.GX5178@kernel.dk>
	 <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain>
	 <20090330185414.GZ5178@kernel.dk> <49D11A8D.1090600@garzik.org>
	 <1238441043.20607.16.camel@think.oraclecorp.com>
	 <87ljqmlqm5.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 16:15:08 -0400
Message-Id: <1238444108.25199.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49D12853.003F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 22:09 +0200, Andi Kleen wrote:
> Chris Mason <chris.mason@oracle.com> writes:
> >
> > As far as I know, reiserfs is the only one actively using it to choose
> > different code.  It moves a single wait_on_buffer when barriers are on,
> > which I took out once to simplify the code.  Ric saw it in some
> > benchmark numbers and I put it back in.
> >
> > Given that it was a long time ago, I don't have a problem with changing
> > it to work like all the other filesystems.
> 
> When it was a win on reiserfs back then maybe it would be a win
> on ext4 or xfs today too?

It could be, but you get into some larger changes.  The theory behind
the code was that writeback cache is on, so wait_on_buffer isn't really
going to give you a worthwhile error return anyway.  Might as well do
the wait_on_buffer some time later and fix up the commit blocks if it
didn't work out.

We're still arguing about barriers being a good idea all these years
later, and the drives are better at them than they used to be.  So, I'd
rather see less complex code in the filesystems than more.

-chris



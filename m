Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZC0Vi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZC0Vi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZC0ViM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:38:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbZC0ViL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:38:11 -0400
Date: Fri, 27 Mar 2009 22:38:06 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090327213806.GG31071@duck.suse.cz>
References: <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326181106.GC17159@duck.suse.cz> <alpine.LFD.2.00.0903261534490.3032@localhost.localdomain> <20090326155725.c2150ab2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326155725.c2150ab2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 26-03-09 15:57:25, Andrew Morton wrote:
> On Thu, 26 Mar 2009 15:39:53 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, 26 Mar 2009, Jan Kara wrote:
> > >
> > >   Reads are measurably better with the patch - the test with cat you
> > > describe below took ~0.5s per file without the patch and always less than
> > > 0.02s with the patch. So it seems to help something.
> > 
> > That would seem to be a _huge_ improvement.
> 
> It's strange that we still don't have an ext3_writepages().  Open a
> transaction, do a large pile of writes, close the transaction again. 
> We don't even have a data=writeback writepages() implementation, which
> should be fairly simple.
  Doable but not fairly simple ;) Firstly you have to restart a transaction
when you've used up all the credits you originally started with (easy),
secondly ext3 uses lock order PageLock -> "transaction start" which is
unusable for the scheme you suggest. So we'd have to revert that - which
needs larger audit of our locking scheme and that's probably the reason
why noone has done it yet.

> Bizarre.
> 
> Mingming had a shot at it a few years ago and I think Badari did as
> well, but I guess it didn't work out.
> 
> Falling back to generic_writepages() on our main local fs is a bit lame.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

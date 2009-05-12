Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZELQtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZELQtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZELQtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:49:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:47139 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbZELQtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:49:35 -0400
Date: Tue, 12 May 2009 18:49:34 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, mel@csn.ul.ie,
       a.p.zijlstra@chello.nl, cl@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Divy Le Ray <divy@chelsio.com>
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
Message-ID: <20090512164934.GC31131@wotan.suse.de>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com> <20090511134038.5cf1ad3b.akpm@linux-foundation.org> <20090512124201.GO4140@kernel.dk> <20090512130546.GA15793@wotan.suse.de> <20090512163730.GQ4140@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512163730.GQ4140@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 06:37:30PM +0200, Jens Axboe wrote:
> On Tue, May 12 2009, Nick Piggin wrote:
> > On Tue, May 12, 2009 at 02:42:02PM +0200, Jens Axboe wrote:
> > > On Mon, May 11 2009, Andrew Morton wrote:
> > > > On Sat, 9 May 2009 15:46:39 -0700 (PDT)
> > > > David Rientjes <rientjes@google.com> wrote:
> > > > 
> > > > > The oom killer must be invoked regardless of the order if the allocation
> > > > > is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> > > > > free some memory.
> > > > 
> > > > Sigh.  We're supposed to be deleting __GFP_NOFAIL.  I added it as a way
> > > > of easily finding lame error-handling-challenged callers which need to
> > > > be fixed up.  So of course we went and added lots more callers.
> > > > 
> > > > y:/usr/src/linux-2.6.30-rc5> grep -rl GFP_NOFAIL . 
> > > > ./fs/bio-integrity.c
> > 
> > This is no good either, it seems to be in the bio submission path.
> > 
> > It needs a mempool or something.
> 
> mempool cannot help here, since the allocation is tied to the process
> (and IO) life time.

Oh, I was talking about bio-integrity.c...

 
> > It has a dead code "fallback" that returns an error, but I suspect that's
> > not really acceptable.
> 
> It's not that difficult to handle an error there, it just means that we
> lose any process association with that request. It's mostly making sure
> that all the bits and pieces deal with that correctly, but it should not
> be very hard.



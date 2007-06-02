Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbXFBPD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbXFBPD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 11:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760039AbXFBPDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 11:03:52 -0400
Received: from brick.kernel.dk ([80.160.20.94]:7746 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbXFBPDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 11:03:51 -0400
Date: Sat, 2 Jun 2007 17:02:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de, zanussi@us.ibm.com,
       hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070602150228.GI32105@kernel.dk>
References: <20070531103316.GO32105@kernel.dk> <20070531124753.a99f713c.dada1@cosmosbay.com> <20070531105321.GQ32105@kernel.dk> <465F9BEF.20504@zytor.com> <20070601054120.GI32105@kernel.dk> <465FB3AD.5030807@zytor.com> <465FC92C.50608@cosmosbay.com> <466040C1.6030004@zytor.com> <alpine.LFD.0.98.0706010904110.3957@woody.linux-foundation.org> <46604F0D.9070806@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46604F0D.9070806@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01 2007, H. Peter Anvin wrote:
> > So there's a few things to take away from this:
> > 
> >  - regular file access MUST NOT return EAGAIN just because a page isn't 
> >    in the cache. Doing so is simply a bug. No ifs, buts or maybe's about 
> >    it!
> > 
> >    Busy-looping is NOT ACCEPTABLE!
> > 
> >  - you *could* make some alternative conventions:
> > 
> > 	(a) you could make O_NONBLOCK mean that you'll at least 
> > 	    guarantee that you *start* the IO, and while you never return 
> > 	    EAGAIN, you migth validly return a _partial_ result!
> > 
> > 	(b) variation on (a): it's ok to return EAGAIN if _you_ were the 
> > 	    one who started the IO during this particular time aroudn the 
> > 	    loop. But if you find a page that isn't up-to-date yet, and 
> > 	    you didn't start the IO, you *must* wait for it, so that you 
> > 	    end up returning EAGAIN atmost once! Exactly because 
> > 	    busy-looping is simply not acceptable behaviour!
> 
> (b) seems really ugly.  (a) is at least well-defined.  Either seems
> wrong, though.

I totally agree, b) would get nasty. And while a) isn't perfect by any
means, I do follow Linus' logic and agree it's probably the best (only?)
way to handle it.

-- 
Jens Axboe


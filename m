Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbYAJJBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbYAJJBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbYAJJB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:01:29 -0500
Received: from brick.kernel.dk ([87.55.233.238]:1623 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbYAJJB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:01:28 -0500
Date: Thu, 10 Jan 2008 10:01:25 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110090125.GU6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <200801101242.25671.nickpiggin@yahoo.com.au> <20080110083753.GB10745@infradead.org> <20080110084457.GT6258@kernel.dk> <20080110085459.GA11966@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110085459.GA11966@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10 2008, Christoph Hellwig wrote:
> On Thu, Jan 10, 2008 at 09:44:57AM +0100, Jens Axboe wrote:
> > > IMHO this shouldn't be done in the loop driver anyway.  Filesystems have
> > > their own effricient extent lookup trees (well, at least xfs and btrfs
> > > do), and we should leverage that instead of reinventing it.
> > 
> > Completely agree, it's just needed right now for this solution since all
> > we have is a crappy bmap() interface to get at those mappings.
> 
> So let's fix the interface instead of piling crap ontop of it.  As I
> said I think Peter has something to start with so let's beat on it
> until we have something suitable. 

Sure, I'm all for doing it the Right Way. I wasn't aware of anything
Peter was doing in this area, so lets please see it.

It's not like opportunities to improve this haven't been around. My plan
was/is to convert to using the get_block() tricks of O_DIRECT, one could
easily argue that the work should have been done then. And perhaps
direct-io.c wouldn't be such a steaming pile of crap if it had been
done, and loop would already be fine since we could have tapped into
that.

> If we aren't done by end of Feb I'm happy to host a hackfest to get it
> sorted around the fs/storage summit..

Count me in :)

-- 
Jens Axboe


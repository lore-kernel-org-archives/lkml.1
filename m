Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYHDPaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYHDPaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYHDPaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:30:05 -0400
Received: from mail2.shareable.org ([80.68.89.115]:48104 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbYHDPaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:30:04 -0400
Date: Mon, 4 Aug 2008 16:29:49 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Miklos Szeredi <miklos@szeredi.hu>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
Message-ID: <20080804152949.GH18868@shareable.org>
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <200808011122.51792.nickpiggin@yahoo.com.au> <E1KOzMt-0003fa-Ah@pomaz-ex.szeredi.hu> <200808021426.50436.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808021426.50436.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Saturday 02 August 2008 04:28, Miklos Szeredi wrote:
> > On Fri, 1 Aug 2008, Nick Piggin wrote:
> > > Well, a) it probably makes sense in that case to provide another mode
> > > of operation which fills the data synchronously from the sender and
> > > copys it to the pipe (although the sender might just use read/write)
> > > And b) we could *also* look at clearing PG_uptodate as an optimisation
> > > iff that is found to help.
> >
> > IMO it's not worth it to complicate the API just for the sake of
> > correctness in the so-very-rare read error case.  Users of the splice
> > API will simply ignore this requirement, because things will work fine
> > on ext3 and friends, and will break only rarely on NFS and FUSE.
> >
> > So I think it's much better to make the API simple: invalid pages are
> > OK, and for I/O errors we return -EIO on the pipe.  It's not 100%
> > correct, but all in all it will result in less buggy programs.
> 
> That's true, but I hate how we always (in the VM, at least) just brush
> error handling under the carpet because it is too hard :(
> 
> I guess your patch is OK, though. I don't see any reasons it could cause
> problems...

At least, if there are situations where the data received is not what
a common sense programmer would expect (e.g. blocks of zeros, data
from an unexpected time in syscall sequence, or something, or just
"reliable except with FUSE and NFS"), please ensure it's documented in
splice.txt or wherever.

-- Jamie

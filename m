Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbYAIJng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbYAIJng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYAIJn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:43:26 -0500
Received: from brick.kernel.dk ([87.55.233.238]:11387 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbYAIJnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:43:24 -0500
Date: Wed, 9 Jan 2008 10:43:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080109094320.GA6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <20080109093107.GA5023@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109093107.GA5023@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09 2008, Christoph Hellwig wrote:
> On Wed, Jan 09, 2008 at 09:52:32AM +0100, Jens Axboe wrote:
> > - The file block mappings must not change while loop is using the file.
> >   This means that we have to ensure exclusive access to the file and
> >   this is the bit that is currently missing in the implementation. It
> >   would be nice if we could just do this via open(), ideas welcome...
> 
> And the way this is done is simply broken.  It means you have to get
> rid of things like delayed or unwritten hands beforehand, it'll be
> a complete pain for COW or non-block backed filesystems.

COW is not that hard to handle, you just need to be notified of moving
blocks. If you view the patch as just a tighter integration between loop
and fs, I don't think it's necessarily that broken.

I did consider these cases, and it can be done with the existing
approach.

> The right way to do this is to allow direct I/O from kernel sources
> where the filesystem is in-charge of submitting the actual I/O after
> the pages are handed to it.  I think Peter Zijlstra has been looking
> into something like that for swap over nfs.

That does sound like a nice approach, but a lot more work. It'll behave
differently too, the advantage of what I proposed is that it behaves
like a real device.

I'm not asking you to love it (in fact I knew some people would complain
about this approach and I understand why), just tossing it out there to
get things rolling. If we end up doing it differently I don't really
care, I'm not married to any solution but merely wish to solve a
problem. If that ends up being solved differently, the outcome is the
same to me.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbXIOPvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbXIOPvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 11:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXIOPvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 11:51:05 -0400
Received: from ns.suse.de ([195.135.220.2]:59171 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbXIOPvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 11:51:04 -0400
Date: Sat, 15 Sep 2007 17:51:01 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joern Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070915155100.GA21861@v2.random>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 02:14:42PM +0200, Goswin von Brederlow wrote:
> I keep coming back to the fact that movable objects should be moved
> out of the way for unmovable ones. Anything else just allows

That's incidentally exactly what the slab does, no need to reinvent
the wheel for that, it's an old problem and there's room for
optimization in the slab partial-reuse logic too. Just boost the order
0 page size and use the slab to get the 4k chunks. The sgi/defrag
design is backwards.

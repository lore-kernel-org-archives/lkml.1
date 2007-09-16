Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbXIPSPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbXIPSPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXIPSPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:15:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43816 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbXIPSPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:15:07 -0400
Date: Sun, 16 Sep 2007 19:15:04 +0100
To: Andrea Arcangeli <andrea@suse.de>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070916181504.GB16406@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070915155100.GA21861@v2.random>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (15/09/07 17:51), Andrea Arcangeli didst pronounce:
> On Sat, Sep 15, 2007 at 02:14:42PM +0200, Goswin von Brederlow wrote:
> > I keep coming back to the fact that movable objects should be moved
> > out of the way for unmovable ones. Anything else just allows
> 
> That's incidentally exactly what the slab does, no need to reinvent
> the wheel for that, it's an old problem and there's room for
> optimization in the slab partial-reuse logic too.

Except now as I've repeatadly pointed out, you have internal fragmentation
problems. If we went with the SLAB, we would need 16MB slabs on PowerPC for
example to get the same sort of results and a lot of copying and moving when
a suitable slab page was not available.

> Just boost the order
> 0 page size and use the slab to get the 4k chunks. The sgi/defrag
> design is backwards.
> 

Nothing stops you altering the PAGE_SIZE so that large blocks work in
the way you envision and keep grouping pages by mobility for huge page
sizes.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

Return-Path: <linux-kernel-owner+w=401wt.eu-S966200AbXIKV1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966200AbXIKV1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXIKV1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:27:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41886 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760263AbXIKV1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:27:21 -0400
Date: Tue, 11 Sep 2007 22:27:17 +0100
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070911212717.GC18127@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111256250.25781@schroedinger.engr.sgi.com> <200709111517.52520.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200709111517.52520.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/09/07 15:17), Nick Piggin didst pronounce:
> On Wednesday 12 September 2007 06:01, Christoph Lameter wrote:
> > On Tue, 11 Sep 2007, Nick Piggin wrote:
> > > There is a limitation in the VM. Fragmentation. You keep saying this
> > > is a solved issue and just assuming you'll be able to fix any cases
> > > that come up as they happen.
> > >
> > > I still don't get the feeling you realise that there is a fundamental
> > > fragmentation issue that is unsolvable with Mel's approach.
> >
> > Well my problem first of all is that you did not read the full message. It
> > discusses that later and provides page pools to address the issue.
> >
> > Secondly you keep FUDding people with lots of theoretical concerns
> > assuming Mel's approaches must fail. If there is an issue (I guess there
> > must be right?) then please give us a concrete case of a failure that we
> > can work against.
> 
> And BTW, before you accuse me of FUD, I'm actually talking about the
> fragmentation issues on which Mel I think mostly agrees with me at this
> point.
> 

I'm half way between you two on this one. I agree with Christoph in that
it's currently very difficult to trigger a failure scenario and today we
don't have a way of dealing with it. I agree with Nick in that conceivably a
failure scenario does exist somewhere and the careful person (or paranoid if
you prefer) would deal with it pre-emptively. The fact is that no one knows
what a large block workload is going to look like to the allocator so we're
all hand-waving.

Right now, I can't trigger the worst failure scenarious that cannot be
dealt with for fragmentation but that might change with large blocks. The
worst situation I can think is a process that continously dirties large
amounts of data on a large block filesystem while another set of processes
works with large amounts of anonymous data without any swap space configured
with slub_min_order set somewhere between order-0 and the large block size.
Fragmentation wise, that's just a kick in the pants and might produce
the failure scenario being looked for.

If it does fail, I don't think it should be used to beat Christoph with as
such because it was meant to be a #2 solution. What hits it is if the mmap()
change is unacceptable.

> Also have you really a rational reason why we should just up and accept
> all these big changes happening just because that, while there are lots
> of theoretical issues, the person pointing them out to you hasn't happened
> to give you a concrete failure case. Oh, and the actual performance
> benefit is actually not really even quantified yet, crappy hardware not
> withstanding, and neither has a proper evaluation of the alternatives.
> 

Performance figures would be nice. dbench is flaky as hell but can
comparison figures be generated on one filesystem with 4K blocks and one
with 64K? I guess we can do it ourselves too because this should work on
normal machines.

> So... would you drive over a bridge if the engineer had this mindset?
> 

If I had this bus that couldn't go below 50MPH, right...... never mind.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

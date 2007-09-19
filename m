Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbXISBIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbXISBIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 21:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXISBIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 21:08:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbXISBIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 21:08:10 -0400
Date: Tue, 18 Sep 2007 18:06:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nathan Scott <nscott@aconex.com>
cc: Andrea Arcangeli <andrea@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <1190163523.24970.378.camel@edge.yarra.acx>
Message-ID: <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org>
References: <20070911060349.993975297@sgi.com>  <200709161853.12050.nickpiggin@yahoo.com.au>
  <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com> 
 <200709181116.22573.nickpiggin@yahoo.com.au> 
 <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org> 
 <20070918191853.GB7541@v2.random>  <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org>
 <1190163523.24970.378.camel@edge.yarra.acx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Sep 2007, Nathan Scott wrote:
> 
> FWIW (and I hate to let reality get in the way of a good conspiracy) -
> all SGI systems have always defaulted to using 4K blocksize filesystems;

Yes. And I've been told that:

> there's very few customers who would use larger

.. who apparently would like to  move to x86-64. That was what people 
implied at the kernel summit.

>						 especially as the Linux
> kernel limitations in this area are well known.  There's no "16K mess"
> that SGI is trying to clean up here (and SGI have offered both IA64 and
> x86_64 systems for some time now, so not sure how you came up with that
> whacko theory).

Well, if that is the case, then I vote that we drop the whole patch-series 
entirely. It clearly has no reason for existing at all.

There is *no* valid reason for 16kB blocksizes unless you have legacy 
issues. The performance issues have nothing to do with the block-size, and 
should be solvable by just making sure that your stupid "state of the art" 
crap SCSI controller gets contiguous physical memory, which is best done 
in the read-ahead code.

So get your stories straight, people.

			Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbXD1KRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbXD1KRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbXD1KRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:17:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48514 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756166AbXD1KRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:17:48 -0400
Date: Sat, 28 Apr 2007 11:21:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070428112117.6170f581@the-village.bc.nu>
In-Reply-To: <20070428025801.eca77146.akpm@linux-foundation.org>
References: <20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	<20070426235542.bad7035a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
	<20070427002640.22a71d06.akpm@linux-foundation.org>
	<20070427163620.GI32602149@melbourne.sgi.com>
	<20070427173432.GJ32602149@melbourne.sgi.com>
	<20070427121108.9ee05710.akpm@linux-foundation.org>
	<20070428031739.GK32602149@melbourne.sgi.com>
	<20070427215634.325606a9.akpm@linux-foundation.org>
	<20070428104328.0b609fb6@the-village.bc.nu>
	<20070428025801.eca77146.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also remember that even if you do larger pages by using virtual pairs or
> > quads of real pages because it helps on some systems you end up needing
> > the same sized sglist as before so you don't make anything worse for
> > half-assed controllers as you get the same I/O size providing they have
> > the minimal 2 or 4 sg list entries (and those that don't are genuinely
> > beyond saving and nowdays very rare)
> > 
> 
> Could you expand on that a bit please?  I don't get it.

Put a 16K "page" into the page cache physically and you need to allocate
1 sg entry and you get a clear benefit, IFF you can allocate the pages. 

Put a 16K "page" into the page cache made up of 4 x real 4K pages which
are not physically contiguous and you need 4 sg list entries - which is
no worse than if you were using 4K pages

	4 per 16K page cache "logcial page"		-> 4 per 16K

	1 per 4K physical page for 4K page cache	-> 4 per 16K

The only ugly case for the latter is if you are reading something like a
16K page ext3fs from an old IA64 box onto a real computer and you have a
controller with insufficient sg list entries to read a 16K logical page.
At that point the block layer is going to have kittens.

Alan

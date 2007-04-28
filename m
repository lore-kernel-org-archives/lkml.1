Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXD1L0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXD1L0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbXD1L0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:26:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43511 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754778AbXD1L0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:26:09 -0400
Date: Sat, 28 Apr 2007 12:29:08 +0100
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
Message-ID: <20070428122908.58f81808@the-village.bc.nu>
In-Reply-To: <20070428032530.2e9c9e55.akpm@linux-foundation.org>
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
	<20070428112117.6170f581@the-village.bc.nu>
	<20070428032530.2e9c9e55.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But all (both) the proposals we're (ahem) discussing do involve 4x
> physically contiguous pages going into those four contiguous pagecache
> slots.
> 
> So we're improving things for the half-assed controllers, aren't we?

Not neccessarily. If you use 16K contiguous pages you have to do
more work to get memory contiguously and you have less cache efficiency
both of which will do serious damage to performance with poor I/O
subsystems for all the extra paging and I/O, and probably way more than
sglist stuff on PC class boxes. (yes its probably a win on your 32GB SGI
monster)

That aside you are improving things for most but not all half-assed
controllers (some sglists are simply page pointers for each 4K page or
have different efficient encoding for page sized chunks (I2O). If you are
reading large chunks on a really crap controller (eg IDE in PIO) then the
fact you pull 16K when you need 4K will also wipe out any gains.

Alan

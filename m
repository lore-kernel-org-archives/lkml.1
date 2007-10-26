Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbXJZFCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbXJZFCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXJZFCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:02:10 -0400
Received: from ozlabs.org ([203.10.76.45]:50235 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbXJZFCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:02:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18209.29891.911465.715995@cargo.ozlabs.ibm.com>
Date: Fri, 26 Oct 2007 15:01:55 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Boaz Harrosh <bharrosh@panasas.com>,
       Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: [PATCH 09/10] Change table chaining layout
In-Reply-To: <alpine.LFD.0.999.0710250834390.30120@woody.linux-foundation.org>
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
	<471DCBB2.9020706@panasas.com>
	<alpine.LFD.0.999.0710230808260.30120@woody.linux-foundation.org>
	<200710251840.02157.rusty@rustcorp.com.au>
	<alpine.LFD.0.999.0710250834390.30120@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> Nobody should *ever* walk the list to find the length. Does anybody really 
> do that? Yes, we pass the thing down, but do people *need* it?

Yes, I need it for devices that use the macintosh DBDMA
(descriptor-based DMA) hardware.  The DBDMA hardware reads an array of
descriptors from system RAM, so I need to allocate an array and fill
it in with DBDMA command blocks (and then dma-map it and point the
device at it).

> [ Side note: some of the users of that length currently would seem to be 
>   buggy in the presense of continuation entries, and seem to assume that 
>   the "list" is just a contiguous array. In fatc, that's almost the only 
>   valid use for the "count" thing, since any other use _has_ to walk it 
>   entry by entry anyway, no? ]

Maybe the drivers for devices that use DBDMA are now buggy.  Certainly
filling in the array of DBDMA command blocks involves walking the
list, but it would extremely useful to know how much to allocate
before we start filling them in.  So we at least need an upper bound
on the number of "real" entries, even if we don't have the exact
number.

Paul.

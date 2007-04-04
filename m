Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbXDDPDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbXDDPDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXDDPDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:03:22 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:25516 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbXDDPDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:03:21 -0400
X-AuditID: d80ac287-94e6abb000000c42-39-4613be38ed4e 
Date: Wed, 4 Apr 2007 16:03:15 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Dan Aloni <da-x@monatomic.org>
cc: Andrea Arcangeli <andrea@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
In-Reply-To: <20070404144421.GA13762@localdomain>
Message-ID: <Pine.LNX.4.64.0704041553220.18202@blonde.wat.veritas.com>
References: <20070329075805.GA6852@wotan.suse.de>
 <Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com>
 <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de>
 <Pine.LNX.4.64.0704041023040.17341@blonde.wat.veritas.com>
 <20070404102407.GA529@wotan.suse.de> <20070404122701.GB19587@v2.random>
 <20070404135530.GA29026@localdomain> <20070404141457.GF19587@v2.random>
 <20070404144421.GA13762@localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 Apr 2007 15:03:20.0454 (UTC) FILETIME=[6217B260:01C776CA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Dan Aloni wrote:
> 
> To refine that example, you could replace the file with a large anonymous 
> memory pool and a lot of swap space committed to it. In that case - with 
> no ZERO_PAGE, would the kernel needlessly swap-out the zeroed pages? 
> Perhaps it's an example too far-fetched to worth considering...

Nice point, not far-fetched, though I don't know whether it's worth
worrying about or not.  Yes, as things stand, the kernel will
needlessly write them out to swap: because we're in the habit of
marking a writable pte as dirty, partly to save the processor (how
i386-centric am I being?) from having to do that work just after,
partly because of some race too ancient for me to know anything
about - do_no_page (though not the function in question here) says:

	 * This silly early PAGE_DIRTY setting removes a race
	 * due to the bad i386 page protection. But it's valid
	 * for other architectures too.

Maybe Nick will decide to not to mark the readfaults as dirty.

Hugh

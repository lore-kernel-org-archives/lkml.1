Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbXDDQbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbXDDQbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992933AbXDDQbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:31:19 -0400
Received: from ns.suse.de ([195.135.220.2]:33817 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbXDDQbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:31:19 -0400
Date: Wed, 4 Apr 2007 18:31:11 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
Message-ID: <20070404163111.GM19587@v2.random>
References: <20070329075805.GA6852@wotan.suse.de> <Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com> <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de> <Pine.LNX.4.64.0704040830500.6730@woody.linux-foundation.org> <20070404154839.GI19587@v2.random> <Pine.LNX.4.64.0704041700380.27262@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704041700380.27262@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 05:10:37PM +0100, Hugh Dickins wrote:
> file will be written to later on), and MAP_PRIVATE mmap of /dev/zero

Obviously I meant MAP_PRIVATE of /dev/zero, since it's the only one
backed by the zero page.

> uses the zeromap stuff which we were hoping to eliminate too
> (though not in Nick's initial patch).

I didn't realized you wanted to eliminate it too.

> Looks like a job for /dev/same_page_over_and_over_again.
> 
> > (without having to run 4k large mmap syscalls or nonlinear).
> 
> You scared me, I made no sense of that at first: ah yes,
> repeatedly mmap'ing the same page can be done those ways.

Yep, which is probably why we don't need the
/dev/same_page_over_and_over_again for that.

Overall the worry about the TLB benchmarking apps being broken in its
measurements sounds very minor compared to the risk of wasting tons of
ram and going out of memory. If there was no risk of bad breakage we
wouldn't need to discuss this.

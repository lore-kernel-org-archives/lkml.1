Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbXDDQKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbXDDQKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXDDQKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:10:46 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50859 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbXDDQKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:10:43 -0400
X-AuditID: d80ac287-976cabb000000c42-97-4613ce0278a7 
Date: Wed, 4 Apr 2007 17:10:37 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrea Arcangeli <andrea@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
In-Reply-To: <20070404154839.GI19587@v2.random>
Message-ID: <Pine.LNX.4.64.0704041700380.27262@blonde.wat.veritas.com>
References: <20070329075805.GA6852@wotan.suse.de>
 <Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com>
 <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de>
 <Pine.LNX.4.64.0704040830500.6730@woody.linux-foundation.org>
 <20070404154839.GI19587@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 Apr 2007 16:10:41.0723 (UTC) FILETIME=[CAE068B0:01C776D3]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Andrea Arcangeli wrote:
> On Wed, Apr 04, 2007 at 08:35:30AM -0700, Linus Torvalds wrote:
> > Anyway, I'm not against this, but I can see somebody actually *wanting* 
> > the ZERO page in some cases. I've used the fact for TLB testing, for 
> > example, by just doing a big malloc(), and knowing that the kernel will 
> > re-use the ZERO_PAGE so that I don't get any cache effects (well, at least 
> > not any *physical* cache effects. Virtually indexed cached will still show 
> > effects of it, of course, but I haven't cared).
> 
> Ok, those cases wanting the same zero page, could be fairly easily
> converted to an mmap over /dev/zero

No, MAP_SHARED mmap of /dev/zero uses shmem, which allocates distinct
pages for this (because in general tmpfs doesn't know if a readonly
file will be written to later on), and MAP_PRIVATE mmap of /dev/zero
uses the zeromap stuff which we were hoping to eliminate too
(though not in Nick's initial patch).

Looks like a job for /dev/same_page_over_and_over_again.

> (without having to run 4k large mmap syscalls or nonlinear).

You scared me, I made no sense of that at first: ah yes,
repeatedly mmap'ing the same page can be done those ways.

Hugh

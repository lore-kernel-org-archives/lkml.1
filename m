Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXDDQJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXDDQJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXDDQJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:09:39 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46212 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXDDQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:09:37 -0400
Date: Wed, 4 Apr 2007 09:09:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@suse.de>
cc: Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
In-Reply-To: <20070404154839.GI19587@v2.random>
Message-ID: <Pine.LNX.4.64.0704040906340.6730@woody.linux-foundation.org>
References: <20070329075805.GA6852@wotan.suse.de>
 <Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com>
 <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de>
 <Pine.LNX.4.64.0704040830500.6730@woody.linux-foundation.org>
 <20070404154839.GI19587@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Apr 2007, Andrea Arcangeli wrote:
> 
> Ok, those cases wanting the same zero page, could be fairly easily
> converted to an mmap over /dev/zero (without having to run 4k large
> mmap syscalls or nonlinear).

You're missing the point. What if it's something like oracle that has been 
tuned for Linux using this? Or even an open-source app that is just used 
by big places and they see performace problems but it's not obvious *why*.

We "know" why, because we're discussing this point. But two months from 
now, when some random company complains to SuSE/RH/whatever that their app 
runs 5% slower or uses 200% more swap, who is going to realize what caused 
it?

THAT is the problem with patches like this. I'm not against it, but you 
can't just dismiss it with "we can fix the app". We *cannot* fix the app 
if we don't even realize what caused the problem..

		Linus

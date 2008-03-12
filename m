Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYCLVMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYCLVMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYCLVMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:12:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35913 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbYCLVMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:12:21 -0400
Date: Wed, 12 Mar 2008 21:12:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J.C. Pizarro" <jcpiza@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux+glibc memory allocator, poor performance
Message-ID: <20080312211219.GL27894@ZenIV.linux.org.uk>
References: <998d0e4a0803121309s125dddbao801e53e44296a4d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <998d0e4a0803121309s125dddbao801e53e44296a4d6@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 09:09:04PM +0100, J.C. Pizarro wrote:

> Assume a SMP system that has 8 CPUs. The main problem of requesting
> pages is the BKL (Big Kernel Lock) in this SMP system used for mutual
> exclusion of the shared resource (the memory).

Really?  Used _where_?

> To solve this major problem, i propose you freely

I hate to think of what you'd propose under duress...

> to allocate 8 local caches
> of (e.g.) 2 MiB each CPU (total 2MiB x 8 CPUs = 16 MiB) acting as
> 8 producer buffers for globally many consumer tasks (e.g. >= 20).
> 
> When the some producer buffer is empty then it does unfrequently BKL to
> allocate another 2 MiB more from the shared resource (the memory).

Excellent advice.  One question: why the bleeding hell would we use BKL
in allocator, frequently or not, when we do not share the crucial resource
needed to come up with such ideas?  Or are you proposing to share your
crack pipe as well?

> In the reverse, it's simple, return back the unused pages to the local buffer
> of the producer, and when this full then to do BKL too to unallocate its half
> to the shared resource (the memory).

I wonder...  Are you seriously implying that nobody here had ever been able
to come up with anything better than _that_ (e.g. with an amazingly advanced
idea of googling for papers on allocators for all of two minutes)?  And that
you are so sure of it that you couldn't be arsed to check what the hell is
allocator really doing, on the off-chance that somebody might have been able
to match your brilliant intellectual feat?

And then we are told that linux-kernel regulars are mean and insulting...

FWIW, the quality of proposed "solution" is not an issue; hell, even "what
if that code is really so dumb that <....> would be an improvement" is not
a problem - the estimate is too low, but far be it from me to suggest that
one should apriori assume that unreviewed code is good.  What _really_
makes the whole thing incredibly insulting is that you had not bothered
to even look at the damn thing and just went on with "of course none of
you could have ever come up with anything better - I don't even need to
look at it to tell you that".

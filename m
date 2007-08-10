Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXHJRqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXHJRqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXHJRqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:46:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36812 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754445AbXHJRqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:46:33 -0400
Date: Fri, 10 Aug 2007 10:46:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Daniel Phillips <daniel.raymond.phillips@gmail.com>
cc: Daniel Phillips <phillips@phunq.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
In-Reply-To: <4a5909270708100115v4ad10c4es697d216edf29b07d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708101041040.12758@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl> 
 <Pine.LNX.4.64.0708071513290.3683@schroedinger.engr.sgi.com> 
 <4a5909270708080037n32be2a73k5c28d33bb02f770b@mail.gmail.com> 
 <Pine.LNX.4.64.0708081106230.12652@schroedinger.engr.sgi.com> 
 <4a5909270708091141tb259eddyb2bba1270751ef1@mail.gmail.com> 
 <Pine.LNX.4.64.0708091146410.25220@schroedinger.engr.sgi.com> 
 <4a5909270708091717n2f93fcb5i284d82edfd235145@mail.gmail.com> 
 <Pine.LNX.4.64.0708091844450.3185@schroedinger.engr.sgi.com> 
 <4a5909270708092034yaa0a583w70084ef93266df48@mail.gmail.com> 
 <Pine.LNX.4.64.0708092045120.27164@schroedinger.engr.sgi.com>
 <4a5909270708100115v4ad10c4es697d216edf29b07d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007, Daniel Phillips wrote:

> It is quite clear what is in your patch.  Instead of just grabbing a
> page off the buddy free lists in a critical allocation situation you
> go invoke shrink_caches.  Why oh why?  All the memory needed to get

Because we get to the code of interest when we have no memory on the 
buddy free lists and need to reclaim memory to fill them up again.

> You do not do anything to prevent mixing of ordinary slab allocations
> of unknown duration with critical allocations of controlled duration.
>  This  is _very important_ for sk_alloc.  How are you going to take
> care of that?

It is not necessary because you can reclaim memory as needed.

> There are certainly improvements that can be made to the posted patch
> set.  Running off and learning from scratch how to do this is not
> really helpful.

The idea of adding code to deal with "I have no memory" situations 
in a kernel that based on have as much memory as possible in use at all 
times is plainly the wrong approach. If you need memory then memory needs 
to be reclaimed. That is the basic way that things work and following that 
through brings about a much less invasive solution without all the issues 
that the proposed solution creates.

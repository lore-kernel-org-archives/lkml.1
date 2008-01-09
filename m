Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYAIWoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYAIWoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbYAIWnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:43:52 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54271 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbYAIWnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:43:51 -0500
Date: Thu, 10 Jan 2008 00:43:49 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Matt Mackall <mpm@selenic.com>
cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <1199906151.6245.57.camel@cinder.waste.org>
Message-ID: <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com> 
 <1199419890.4608.77.camel@cinder.waste.org>  <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
  <1199641910.8215.28.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
 <1199906151.6245.57.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Wed, 9 Jan 2008, Matt Mackall wrote:
> I kicked this around for a while, slept on it, and then came up with
> this little hack first thing this morning:
> 
> ------------
> slob: split free list by size
> 

[snip]

> And the results are fairly miraculous, so please double-check them on
> your setup. The resulting statistics change to this:

[snip]
 
> So the average jumped by 714k from before the patch, became much more
> stable, and beat SLUB by 287k. There are also 7 perfectly filled pages
> now, up from 1 before. And we can't get a whole lot better than this:
> we're using 259 pages for 244 pages of actual data, so our total
> overhead is only 6%! For comparison, SLUB's using about 70 pages more
> for the same data, so its total overhead appears to be about 35%.

Unfortunately I only see a slight improvement to SLOB (but it still gets 
beaten by SLUB):

[ the minimum, maximum, and average are captured from 10 individual runs ]

                                 Free (kB)             Used (kB)
                    Total (kB)   min   max   average   min  max  average
  SLUB (no debug)   26536        23868 23892 23877.6   2644 2668 2658.4
  SLOB (patched)    26548        23456 23708 23603.2   2840 3092 2944.8
  SLOB (vanilla)    26548        23472 23640 23579.6   2908 3076 2968.4
  SLAB (no debug)   26544        23316 23364 23343.2   3180 3228 3200.8
  SLUB (with debug) 26484        23120 23136 23127.2   3348 3364 3356.8

What .config did you use? What kind of user-space do you have? (I am still 
using the exact same configuration I described in the first mail.)

			Pekka

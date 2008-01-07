Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYAGUpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYAGUpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYAGUo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:44:57 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38869 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbYAGUoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:44:55 -0500
Date: Mon, 7 Jan 2008 22:44:53 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Matt Mackall <mpm@selenic.com>
cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
In-Reply-To: <1199732595.4110.30.camel@cinder.waste.org>
Message-ID: <Pine.LNX.4.64.0801072239490.2208@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com> 
 <1199419890.4608.77.camel@cinder.waste.org>  <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
  <1199641910.8215.28.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
 <1199732595.4110.30.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Mon, 7 Jan 2008, Matt Mackall wrote:
> Fascinating. Which kernel version are you using? This patch doesn't seem
> to have made it to mainline:
> 
> ---
> 
> slob: fix free block merging at head of subpage
> 
> We weren't merging freed blocks at the beginning of the free list.
> Fixing this showed a 2.5% efficiency improvement in a userspace test
> harness.

Hmm, interesting, it definitely improves the best case (although not quite 
on a par with SLUB) but makes worst case and average case significantly 
worse (almost as bad as SLAB):

[ the minimum, maximum, and average are of captured from 10 individual runs ]

                                 Free (kB)             Used (kB)
                    Total (kB)   min   max   average   min  max  average
  SLUB (no debug)   26536        23868 23892 23877.6   2644 2668 2658.4
  SLOB              26548        23472 23640 23579.6   2908 3076 2968.4
  SLOB (patched)    26548        23260 23728 23385.2   2820 3288 3162.8
  SLAB (no debug)   26544        23316 23364 23343.2   3180 3228 3200.8
  SLUB (with debug) 26484        23120 23136 23127.2   3348 3364 3356.8

			Pekka

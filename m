Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYADUha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYADUha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYADUhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:37:23 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50700 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752230AbYADUhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:37:22 -0500
Date: Fri, 4 Jan 2008 12:37:20 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
In-Reply-To: <1199438251.7143.2.camel@twins>
Message-ID: <Pine.LNX.4.64.0801041235240.11479@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com> 
 <20080104024506.GA4665@one.firstfloor.org> <1199438251.7143.2.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008, Peter Zijlstra wrote:

> I remember wli trying to work out a series that had minimal
> fragmentation. IIRC he was mixing a fibonaci series with the power of
> two series.
> 
> Bill, do you remember getting anywhere?

I tried various approaches to reduce the overhead that power of two slab 
sizes cause in SLUB during the initial comparison of memory use with SLOB. 
This involved creating slabs in 32 byte increments and trying to add a few 
additional extra slabs in between the power of two sizes. None of that led 
to convincing results.
 
I found that the SLAB scheme with power of two caches and two extra ones 
(96 and 192 bytes) was optimal.

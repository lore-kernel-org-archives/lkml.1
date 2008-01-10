Return-Path: <linux-kernel-owner+w=401wt.eu-S1759709AbYAJPp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbYAJPp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYAJPpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:45:17 -0500
Received: from waste.org ([66.93.16.53]:54131 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbYAJPpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:45:15 -0500
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
From: Matt Mackall <mpm@selenic.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <1199419890.4608.77.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
	 <1199641910.8215.28.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
	 <1199906151.6245.57.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
	 <1199919548.6245.74.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 09:44:17 -0600
Message-Id: <1199979858.5331.15.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 12:54 +0200, Pekka J Enberg wrote:
> Hi Matt,
> 
> On Thu, 10 Jan 2008, Pekka J Enberg wrote:
> > I'll double check the results for SLUB next but it seems obvious that your 
> > patches are a net gain for SLOB and should be applied. One problem though 
> > with SLOB seems to be that its memory efficiency is not so stable. Any 
> > ideas why that is?

We're seeing different numbers in each allocator indicating that the
ordering of allocations is not stable. When fragmentation occurs, it
magnifies the underlying instability. On my config, where the split list
combats fragmentation extremely effectively, the stability is quite
good.

Perhaps I'll add a printk to allocs and generate some size histograms.
lguest + grep = relayfs for dummies.

> Ok, I did that. The number are stable and reproducible. In fact, the 
> average for SLUB is within 1 KB of the previous numbers. So, we have the 
> same .config, the same userspace, and the same hypervisor, so what's the 
> difference here?

I've got:

gcc version 4.2.3 20080102 (prerelease) (Debian 4.2.2-5)
BusyBox v1.2.1 (2006.11.01-11:21+0000) Built-in shell (ash)

-- 
Mathematics is the supreme nostalgia of our time.


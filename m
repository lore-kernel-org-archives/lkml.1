Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbYAEUGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbYAEUGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbYAEUGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:06:06 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43734 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755932AbYAEUGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:06:04 -0500
Date: Sat, 5 Jan 2008 12:05:58 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zanussi@us.ibm.com
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
In-Reply-To: <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0801051202480.14866@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
 <1199419890.4608.77.camel@cinder.waste.org> <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008, Pekka J Enberg wrote:

> So, I have this silly memory profiler derived from the kleak patches by 
> the relayfs people and would love to try it out on an embedded workload 
> where SLUB memory footprint is terrible. Any suggestions?

Good idea. But have you tried to look at slabinfo?

Try to run

	slabinfo -t

which will calculate the allocation overhead of the currently allocated 
objects in all slab caches.

One problem: The actual size of kmalloc'ed objects is not available so it 
does not calculate the overhead that comes about because of rounding. Your 
approach would cover that as well but I think we could also add a debug 
mode in which we store the actual size of a kmalloc object and export the 
information via sysfs. Would be nicer than adding this whole additional 
layer.


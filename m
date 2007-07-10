Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbXGJB43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbXGJB43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbXGJB4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:56:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58357 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754346AbXGJB4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:56:21 -0400
Date: Mon, 9 Jul 2007 18:56:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <4692E44E.6000606@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com>
 <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org>
 <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
 <20070709095116.c2ea700f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
 <4692E44E.6000606@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Nick Piggin wrote:

> I don't see any problems with maintaining SLOB. It is simple enough
> that I was able to write a userspace test harness for it and hack
> away at it after reading the code the first time for half an hour or
> so. It is nothing even slightly comparable to the problems of SLAB,
> for example. And you don't have to maintain it at all anyway!

I have to maintain it because I have to keep the slab APIs consistent 
(recently I added GFP_ZERO support and had to provide shims for slab 
defreag). It is not in a good state as described in the patch and has a 
history of not being maintained properly. Everyone that modifies the 
behavior of the slab allocator has to do something to avoid breaking SLOB. 
Its certainly fun to hack on but is that a criterion for keeping it in the 
tree?

> I like removing code as much as the next person, but I don't
> understand why you are so intent on removing SLOB and willing to
> dismiss its advantages so quickly.

Quickly? We have considered this for months now.

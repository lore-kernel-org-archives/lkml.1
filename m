Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYFMC1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYFMC1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 22:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYFMC1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 22:27:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60361 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755300AbYFMC1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 22:27:11 -0400
Date: Thu, 12 Jun 2008 19:27:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Martin Peschke <mp3@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu
 operations
In-Reply-To: <200806131038.12987.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0806121921260.4570@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <200806122121.09835.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0806121017010.30597@schroedinger.engr.sgi.com>
 <200806131038.12987.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008, Rusty Russell wrote:

> cpu_possible_map should definitely be minimal, but your point is well made: 
> dynamic percpu could actually cut memory allocation.  If we go for a hybrid 
> scheme where static percpu is always allocated from the initial chunk, 
> however, we still need the current pessimistic overallocation.

The initial chunk would mean that the percpu areas all come from the same 
NUMA node. We really need to allocate from the node that is nearest to a 
processor (not all processors have processor local memory!).

It would be good to standardize the way that percpu areas are allocated. 
We have various ways of allocation now in various arches. 
init/main.c:setup_per_cpu_ares() needs to be generalized:

1. Allocate the per cpu areas in a NUMA aware fashions.

2. Have a function for instantiating a single per cpu area that 
   can be used during cpu hotplug.

3. Some hooks for arches to override particular behavior as needed.
   F.e. IA64 allocates percpu structures in a special way. x86_64
   needs to do some tricks for the pda etc etc.

> Mike's a clever guy, I'm sure he'll think of something :)

Hopefully. Otherwise he will ask me =-).


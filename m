Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbXGISBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbXGISBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757825AbXGISAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:00:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45455 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757513AbXGISAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:00:53 -0400
Date: Mon, 9 Jul 2007 11:00:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-Id: <20070709110013.82d2273c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com>
	<20070708035018.074510057@sgi.com>
	<20070708075119.GA16631@elte.hu>
	<20070708110224.9cd9df5b.akpm@linux-foundation.org>
	<4691A415.6040208@yahoo.com.au>
	<Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
	<20070709095116.c2ea700f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 10:26:08 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> > I assume the tradeoff here is better packing versus having a ridiculous
> > number of caches.  Is there any other cost?
> > Because even having 1024 caches wouldn't consume a terrible amount of
> > memory and I bet it would result in aggregate savings.
> 
> I have tried any number of approaches without too much success. Even one 
> slab cache for every 8 bytes. This creates additional admin overhead 
> through more control structure (that is pretty minimal but nevertheless 
> exists)
> 
> The main issue is that kmallocs of different size must use different 
> pages. If one allocates one 64 byte item and one 256 byte item and both 64 
> byte and 256 byte are empty then SLAB/SLUB will have to allocate 2 pages. 
> SLUB can fit them into one. This is basically only relevant early after 
> boot. The advantage goes away as the system starts to work and as more 
> objects are allocated in the slabs but the power-of-two slab will always
> have to extend its size in page size chunks which leads to some overhead 
> that SLOB can avoid by placing entities of multiple size in one slab. 
> The tradeoff in SLOB is that is cannot be an O(1) allocator because it 
> has to manage these variable sized objects by traversing the lists.
> 
> I think the advantage that SLOB generates here is pretty minimal and is 
> easily offset by the problems of maintaining SLOB.

Sure.  But I wasn't proposing this as a way to make slub cover slob's advantage.
I was wondering what effect it would have on a more typical medium to large sized
system.

Not much, really: if any particular subsystem is using a "lot" of slab memory then
it should create its own cache rather than using kmalloc anyway, so forget it ;)

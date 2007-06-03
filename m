Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbXFCQPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbXFCQPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 12:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbXFCQPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 12:15:43 -0400
Received: from waste.org ([66.93.16.53]:50699 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbXFCQPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 12:15:43 -0400
Date: Sun, 3 Jun 2007 11:15:28 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-ID: <20070603161528.GO11166@waste.org>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> <20070601204141.f84ad72f.akpm@linux-foundation.org> <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com> <20070601213117.1178e8e0.akpm@linux-foundation.org> <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 09:45:15PM -0700, Christoph Lameter wrote:
> On Fri, 1 Jun 2007, Andrew Morton wrote:
> 
> > They are different instances which happen to have the same length (zero).
> 
> I guess one could use the slab allocators as a type of reservation 
> ticket generator with zero sized objects. Hmmm.... But is that really a 
> useful thing to do?

Yes. Old kmalloc(0) gives you a unique pointer that you can use as a
cookie. Which you can then use for all the things you'd use a cookie
for.

But I'd be pretty surprised if anyone was actually doing that. Because
it's easy enough to simply alloc some actual space and stuff some
actual data in it that corresponds to the cookie and use the pointer
to the actual space as the cookie.

On architectures where we have more address space, we could have a
dedicated lala-land for these things. 

> > I agree the risk is low, but if something _does_ blow up, it will do so subtly.

Arguable the proposed badptr behavior is correct. It's basically "how many
angels can dance on the head of a pin"? All the returned pointers are
at least 0 bytes away from the previous one.

-- 
Mathematics is the supreme nostalgia of our time.

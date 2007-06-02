Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbXFBEyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbXFBEyr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 00:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXFBEyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 00:54:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077AbXFBEyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 00:54:39 -0400
Date: Fri, 1 Jun 2007 21:54:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-Id: <20070601215427.f06d09e7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
	<20070601204141.f84ad72f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
	<20070601213117.1178e8e0.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 21:45:15 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 1 Jun 2007, Andrew Morton wrote:
> 
> > They are different instances which happen to have the same length (zero).
> 
> I guess one could use the slab allocators as a type of reservation 
> ticket generator with zero sized objects. Hmmm.... But is that really a 
> useful thing to do?
> 
> > But the code will incorrectly decide that they are the same instance.  It
> > might cause refcounting or accounting errors, for example.  I don't know - the
> > kernel's a big place.
> 
> That would have to occur with objects that are repeatedly allocated and 
> then linked toghether etc. Linking typicallty requires a listhead so its 
> typically difficult to do zero length objects.

Well I can't immediately think of a scenario in which it's likely to occur,
but we're in the position of trying to prove a negative.

Poke Bill Irwin - he'll think of something ;)

> > I agree the risk is low, but if something _does_ blow up, it will do so subtly.
> 
> The cases that we have seen so far are due to array allocations of N 
> elements where N == 0 leads to the creation of a zero sized object.
> The objects of the array are not zero sized it is just that zero of 
> them are allocated.

We lose leak-detection and double-free detection this way, too.  Not a big
deal.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbXFBEpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbXFBEpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 00:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXFBEpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 00:45:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49950 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752336AbXFBEpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 00:45:16 -0400
Date: Fri, 1 Jun 2007 21:45:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <20070601213117.1178e8e0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
 <20070601204141.f84ad72f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
 <20070601213117.1178e8e0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Andrew Morton wrote:

> They are different instances which happen to have the same length (zero).

I guess one could use the slab allocators as a type of reservation 
ticket generator with zero sized objects. Hmmm.... But is that really a 
useful thing to do?

> But the code will incorrectly decide that they are the same instance.  It
> might cause refcounting or accounting errors, for example.  I don't know - the
> kernel's a big place.

That would have to occur with objects that are repeatedly allocated and 
then linked toghether etc. Linking typicallty requires a listhead so its 
typically difficult to do zero length objects.
 
> I agree the risk is low, but if something _does_ blow up, it will do so subtly.

The cases that we have seen so far are due to array allocations of N 
elements where N == 0 leads to the creation of a zero sized object.
The objects of the array are not zero sized it is just that zero of 
them are allocated.

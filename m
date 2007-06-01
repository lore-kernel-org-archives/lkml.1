Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbXFAXmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbXFAXmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbXFAXmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:42:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57502 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753394AbXFAXmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:42:04 -0400
Date: Fri, 1 Jun 2007 16:42:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <alpine.LFD.0.98.0706011630240.3957@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706011639520.9992@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
 <20070601151649.bb23c6f9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
 <20070601153328.1118ccaf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
 <20070601160241.33b304bf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011615540.9781@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011630240.3957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Linus Torvalds wrote:

> No, I don't think you can do it this way.

Ultimately not. But its worth to see if this works.

> At a minimum, you'd need to test that the result is word-aligned. 
> Preferably 8-byte aligned. We literally have stuff that knows about these 
> things and uses the low bits in the pointer to keep extra data.

kmalloc allocations are guaranteed to be aligned to KMALLOC_MINALIGN. I 
can bring that in but it will make the patch less readable.

> Of course, there migth be other (even more subtle) cases where we just 
> assume certain alignment, and depend on the fact that we just _happen_ to 
> get it. Who knows..

I tried to get rid of those cased and I hope that work is complete in 
2.6.22.


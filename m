Return-Path: <linux-kernel-owner+w=401wt.eu-S1761172AbXFAXmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172AbXFAXmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbXFAXmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:42:07 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754141AbXFAXmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:42:05 -0400
Date: Fri, 1 Jun 2007 16:41:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <Pine.LNX.4.64.0706011617330.9781@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.98.0706011638360.3957@woody.linux-foundation.org>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
 <20070601151649.bb23c6f9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
 <20070601153328.1118ccaf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706011617330.9781@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Christoph Lameter wrote:
> 
> Something like this? (Not tested yet just for review):

I'm not seeing the path on the freeing side that silently accepts BADPTR.

It is not ok to derefence BADPTR, but it's obviously ok to _free_ it.

Also, if I read the patch correctly, you _also_ return BADPTR for slabs 
that are too large. No?  That would be wrong - those need to return NULL 
for "out of memory".

(But I only looked at the diff, not at the end result, so it may be that 
all the cases where you changed "return NULL" into "return BADPTR" were 
really just the size-zero ones - it just looked suspicious).

		Linus

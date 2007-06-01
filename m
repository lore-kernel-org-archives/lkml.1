Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbXFAXhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbXFAXhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbXFAXhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:37:34 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbXFAXhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:37:33 -0400
Date: Fri, 1 Jun 2007 16:36:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <Pine.LNX.4.64.0706011615540.9781@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.98.0706011630240.3957@woody.linux-foundation.org>
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
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Christoph Lameter wrote:
> 
> Hmmm... We are going rapidly here. This is a patch that I am testing right 
> now. It right adjust the object and the patch is manageable:

No, I don't think you can do it this way.

At a minimum, you'd need to test that the result is word-aligned. 
Preferably 8-byte aligned. We literally have stuff that knows about these 
things and uses the low bits in the pointer to keep extra data.

(That said, I didn't check whether we actually kmalloc() the data, but I 
think we do - things like "struct key" etc).

Now, maybe those things always have a 8-byte-aligned size, and it works 
out, but I'd be worried.

Of course, there migth be other (even more subtle) cases where we just 
assume certain alignment, and depend on the fact that we just _happen_ to 
get it. Who knows..

		Linus

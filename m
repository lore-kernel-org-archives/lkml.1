Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbXFBAqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbXFBAqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXFBAqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:46:36 -0400
Received: from gw.goop.org ([64.81.55.164]:58686 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbXFBAqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:46:35 -0400
Message-ID: <4660BDE7.1070904@goop.org>
Date: Fri, 01 Jun 2007 17:46:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com> <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com> <20070601135900.ec44b1aa.akpm@linux-foundation.org> <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com> <20070601151649.bb23c6f9.akpm@linux-foundation.org> <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com> <20070601153328.1118ccaf.akpm@linux-foundation.org> <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So for *both* of the above reasons, it's actually stupid to return NULL 
> for a zero-sized allocation. It would be much better to return another 
> pointer that will trap on access. A good candidate might be to return
>
> 	#define BADPTR ((void *)16)
>   

I think this is a good idea in principle, but I wonder if there's any
code which assumes that kmalloc(x) != kmalloc(x) for all non-NULL
returns from kmalloc.

J

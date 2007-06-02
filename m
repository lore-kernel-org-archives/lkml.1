Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbXFBBZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbXFBBZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbXFBBYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:24:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60355 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757900AbXFBBYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:24:54 -0400
Date: Fri, 1 Jun 2007 18:24:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Valdis.Kletnieks@vt.edu
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <6985.1180746300@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0706011823470.10720@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
 <20070601151649.bb23c6f9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
 <20070601153328.1118ccaf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>           
 <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
 <6985.1180746300@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Valdis.Kletnieks@vt.edu wrote:

> On Fri, 01 Jun 2007 16:00:30 PDT, Linus Torvalds said:
> 
> > 	#define BADPTR ((void *)16)
> 
> > I bet you'd find *more* problems that way than by returning NULL, and 
> > you'd also avoid the whole problem with "if (!ptr) return -ENOMEM".
> 
> Hmm.. this looks like a good contender for "first usage of #ifndef CONFIG_STABLE"

The warning? Sure but the BADPTR (or ZERO_SIZE_PTR now) will stay. 
It is definitely an error to deference an object that has no size.


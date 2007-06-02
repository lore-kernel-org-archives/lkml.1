Return-Path: <linux-kernel-owner+w=401wt.eu-S1762332AbXFBAl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332AbXFBAl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbXFBAlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:41:52 -0400
Received: from gw.goop.org ([64.81.55.164]:37241 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbXFBAlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:41:52 -0400
Message-ID: <4660BCCC.205@goop.org>
Date: Fri, 01 Jun 2007 17:41:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com> <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com> <20070601135900.ec44b1aa.akpm@linux-foundation.org> <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com> <20070601151649.bb23c6f9.akpm@linux-foundation.org> <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com> <20070601153328.1118ccaf.akpm@linux-foundation.org> <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Well there are architectural problems. We determine the power of two slab 
> at compile time. The object size information is currently not available in 
> the binary :=).
>   

That only applies to allocations with constant sizes. One presumes
nobody is explicitly doing kmalloc(0), so we can use a separate
runtime-computed-size path to do poisoning. (Which is probably 90% of
the problem, since people who kmalloc(sizeof(struct foo)) will generally
stay within bounds without too much effort.)

J

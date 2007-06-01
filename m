Return-Path: <linux-kernel-owner+w=401wt.eu-S1764280AbXFAUHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764280AbXFAUHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762980AbXFAUGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:06:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33373 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762957AbXFAUGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:06:54 -0400
Date: Fri, 1 Jun 2007 13:06:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: srinivasa@in.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vatsa@in.ibm.com, dino@in.ibm.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <20070601130212.7be4432a.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0706011305230.3976@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <Pine.LNX.4.64.0706011107540.2284@schroedinger.engr.sgi.com>
 <20070601121114.b165f1e8.pj@sgi.com> <Pine.LNX.4.64.0706011217510.3406@schroedinger.engr.sgi.com>
 <20070601124757.fe91a002.pj@sgi.com> <Pine.LNX.4.64.0706011249530.3598@schroedinger.engr.sgi.com>
 <20070601130212.7be4432a.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Paul Jackson wrote:

> > We must have a NULL pointer exactly because it cannot be dereferenced.
> 
> Well, both patch versions had NULL pointers - either pidarray or ctr->buf.
> 
> But now I can make more sense of what you say -- you -want- the pidarray
> pointer, in particular, to be NULL, so that we don't accidentally use it.
> 
> Does that still mean that your patch suggestion was incomplete, in that
> it lacked the additional checks to avoid using a NULL pidarray?

There are no checks necessary. Your function worked fine so far for 
the case of zero objects with the pointer returned by kmalloc. If the 
code is correct then it will not dereference the pointer to the zero 
sized array. If not then we may find a bug and fix it.


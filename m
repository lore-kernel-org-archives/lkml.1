Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbXFATLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbXFATLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbXFATLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:11:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44962 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755514AbXFATLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:11:17 -0400
Date: Fri, 1 Jun 2007 12:11:14 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: srinivasa@in.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vatsa@in.ibm.com, dino@in.ibm.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
Message-Id: <20070601121114.b165f1e8.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706011107540.2284@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com>
	<200706011620.05756.srinivasa@in.ibm.com>
	<Pine.LNX.4.64.0706011107540.2284@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph wrote:
> Hmmmm.... Isnt it easier to set the pidarray to NULL in the case it
> has no objects? Then any deferences will fail. Paul?

>From what I can tell, in 30 seconds of reading, either of these
approaches, Christoph's or Srinivasa's, based on Vatsa's suggestions
-could- be made to work.

I don't understand how Christoph's approach works, as stated, however.

What do you mean, Christoph, by "then any dereferences will fail" ?
That sounds bad to me -- we don't want pointer dereferences failing
in the kernel, do we?  Wouldn't you have to add some more lines of
code, a bit further down, where pidarray is used, to avoid trying to
use it if its NULL?

I think that Srinivasa's point is that it is legitimate for this array
to be empty, and that we have to code for that case, one way or another.
Now that we can't simply kmalloc zero bytes and get away with it, that
requires explicit tests in the code for the empty case, one way or
another.  This sounds like a valid point to me.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

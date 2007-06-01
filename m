Return-Path: <linux-kernel-owner+w=401wt.eu-S1764001AbXFATvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764001AbXFATvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762367AbXFATvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:51:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60833 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762078AbXFATvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:51:35 -0400
Date: Fri, 1 Jun 2007 12:51:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: srinivasa@in.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vatsa@in.ibm.com, dino@in.ibm.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <20070601124757.fe91a002.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0706011249530.3598@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <Pine.LNX.4.64.0706011107540.2284@schroedinger.engr.sgi.com>
 <20070601121114.b165f1e8.pj@sgi.com> <Pine.LNX.4.64.0706011217510.3406@schroedinger.engr.sgi.com>
 <20070601124757.fe91a002.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Paul Jackson wrote:

> > The allocated array has 0 bytes. Any dereference is an error.
> 
> Well, then, that doesn't work either.
> 
> We -agree- we can't have this failing. You suggested (if I understood
> correctly, which I doubt) that we set the pointer to NULL, and noted
> that derefencing a NULL pointer would fail.  I agree such derefences
> would fail, and tried to point out that this would be bad.  We can't
> have pointer dereferences failing in the kernel ... duh.
> 
> Your reply seems like a non sequiter to me, pointing out that having
> a pointer to an array of 0 bytes fails as well.  Ok - that's bad too.

Think about it some more...
 
> So we cannot have a NULL pointer, used unchecked, and we cannot have
> a non-NULL pointer to a zero byte array, used unchecked.

We must have a NULL pointer exactly because it cannot be dereferenced. It 
is a safety precaution that the following code will not deference the 
pointer to the array of zero size. Because attempting to access an object 
in an array with zero object in them is an error.

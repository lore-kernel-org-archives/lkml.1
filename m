Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbYCJNsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbYCJNsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYCJNsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:48:06 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:21293 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYCJNsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:48:05 -0400
Subject: Re: [patch -mm 2/2] mempolicy: use default_policy mode instead of
	MPOL_DEFAULT
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andi Kleen <ak@suse.de>
Cc: David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       akpm@linux-foundation.org, clameter@sgi.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200803090019.19518.ak@suse.de>
References: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com>
	 <1205003580.4918.21.camel@localhost>
	 <alpine.DEB.1.00.0803081414460.12095@chino.kir.corp.google.com>
	 <200803090019.19518.ak@suse.de>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 10 Mar 2008 09:48:01 -0400
Message-Id: <1205156881.5579.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-09 at 00:19 +0100, Andi Kleen wrote:
> > Using MPOL_DEFAULT purely for falling back to the task or system-wide 
> > policy, however, seems confusing.  The semantics seem to indicate that 
> > MPOL_DEFAULT represents the system-wide default policy without any 
> > preferred node or set of nodes to bind or interleave.  So if a VMA has a 
> > policy of MPOL_DEFAULT then, to me, it seems like that indicates the 
> > absence of a specific policy, not a mandate to fallback to the task 
> > policy.
> 
> I designed MPOL_DEFAULT on vma originally to be a fallback to the task policy.
> 
> Absence of specific policy would be MPOL_PREFERRED with -1 node.

Not sure what you mean here, Andi.   

"MPOL_PREFERRED with -1 node" == "local allocation", right?  

Whereas, in the task mempolicy or vma policy or shared policy, the lack
of a specific policy--i.e., a null mempolicy pointer, or no policy at
that offset in a shared policy rbtree--means fall back to surrounding
context, right?  As far back as I've looked, mempolicy.c implemented
MPOL_DEFAULT, passed to set_mempolicy() or mbind(), by deleting the
target policy, resulting in "fall back".  

The only place that MPOL_DEFAULT actually occurs in a struct mempolicy
is in the system default policy.  I think we can simplify the code and
documentation--not have to explain the context dependent meaning of
MPOL_DEFAULT--by making it simply an API request to remove the target
policy and establish "default behavior" for that context--i.e.,
fallback.  

Lee
> 
> -Andi
> 
> 
> 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759189AbXJ3Xyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbXJ3Xyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbXJ3Xy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:54:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20828 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbXJ3Xy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:54:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=xo1Xnu+Vgnd+HNv+Bldly6zUCm8DL+vY6g2UXZRsUayIM6osl5p88GCftqDHFaBUJ
	Z9sDtWfB0EVfH3nYEuvYQ==
Date: Tue, 30 Oct 2007 16:53:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071030164414.b353e41c.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710301648540.28111@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com> <1193434278.5032.106.camel@localhost> <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
 <20071026180713.aeedfac2.pj@sgi.com> <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com> <20071026194144.6042316a.pj@sgi.com> <alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com> <20071027161955.e9d4d2db.pj@sgi.com>
 <alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com> <20071028164637.8d1b45b0.pj@sgi.com> <alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com> <20071028212745.57a7db67.pj@sgi.com> <alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
 <20071029001554.c12b6b6c.pj@sgi.com> <alpine.DEB.0.9999.0710301607430.19750@chino.kir.corp.google.com> <20071030164414.b353e41c.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007, Paul Jackson wrote:

> > Those applications that currently rely on the remapping are going to be 
> > broken anyway because they are unknowingly receiving different nodes than 
> > they intended, this is the objection to remapping that Lee agreed with.
> 
> No, they may or may not be broken.  That depends on whether or not they had
> specific hardware locality or affinity needs.
> 

Of course they have specific affinity needs, that's why they used 
mempolicies.  Remapping those policies to a set of nodes that resembles 
the original mempolicy's nodemask in terms of construction but without 
regard for the affinity those nodes have with respect to system topology 
could lead to performance degredations.

> If you're running apps that have specific hardware affinity requirements,
> then perhaps you shouldn't be moving them about in the first place ;).
> And if they did have such needs, aren't they just as likely to be busted
> by AND'ing off some of their nodes as they are by remapping those nodes?
> 

No, because you're interleaving over the set of actual nodes you wanted to 
interleave over in the first place and not some pseudo-random set that 
your cpuset has access to.

> I sure wish I knew what real world, actual, not hypothetical, situations
> were motivating this.
> 

You're defending the current remap behavior in terms of semantics of 
mempolicies?  My position, and Choice C's position, is that you either get 
the exact (or partially-constructed) policy that you asked for, or you get 
the MPOL_DEFAULT behavior.  What you don't get, even though it's currently 
how we do it, is a completely different set of nodes that you never 
intended to have a specific policy over.

		David

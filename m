Return-Path: <linux-kernel-owner+w=401wt.eu-S1763994AbXJZRhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763994AbXJZRhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbXJZRg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:36:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52442 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752892AbXJZRg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:36:58 -0400
Date: Fri, 26 Oct 2007 10:36:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <1193411888.5032.9.camel@localhost>
Message-ID: <Pine.LNX.4.64.0710261035330.15270@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
  <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> 
 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com> 
 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com> 
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
 <1193411888.5032.9.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Lee Schermerhorn wrote:

> > With that MPOL_INTERLEAVE would be context dependent and no longer 
> > needs translation. Lee had similar ideas. Lee: Could we make 
> > MPOL_INTERLEAVE generally cpuset context dependent?
> > 
> 
> That's what my "cpuset-independent interleave" patch does.  David
> doesn't like the "null node mask" interface because it doesn't work with
> libnuma.  I plan to fix that, but I'm chasing other issues.  I should
> get back to the mempol work after today.

But this makes it cpuset dependent. The set of nodes is dependent on the 
cpuset. If it would be independent then interleave could allow any nodes 
outside of the cpuset.
 
> What I like about the cpuset independent interleave is that the "policy
> remap" when cpusets are changed is a NO-OP--no need to change the
> policy.  Just as "preferred local" policy chooses the node where the
> allocation occurs, my cpuset independent interleave patch interleaves
> across the set of nodes available at the time of the allocation.  The
> application has to specifically ask for this behavior by the null/empty
> nodemask or the TBD libnuma API.  IMO, this is the only reasonable
> interleave policy for apps running in dynamic cpusets.

Hmmm.. But its an API change and requires more special casing.

> An aside:  if David et al [at google] are using cpusets on fake numa for
> resource management [I don't know this is the case, but saw some
> discussions way back that indicate it might be?], then maybe this
> becomes less of an issue when control groups [a.k.a. containers] and
> memory resource controls come to fruition?

Yes very likely.


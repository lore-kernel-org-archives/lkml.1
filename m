Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbXJ0Ihc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbXJ0Ihc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 04:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXJ0IhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 04:37:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47720 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751639AbXJ0IhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 04:37:00 -0400
Date: Sat, 27 Oct 2007 01:36:56 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071027013656.4ffadb87.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710262303410.30785@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<1193412644.5032.13.camel@localhost>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	<20071026120037.7b95a136.pj@sgi.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<Pine.LNX.4.64.0710261949360.30293@schroedinger.engr.sgi.com>
	<20071026221624.cec512da.pj@sgi.com>
	<Pine.LNX.4.64.0710262303410.30785@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Are you saying:
> >  1) The kernel continues to default to Choice A, unless
> >     the flag enables Choice B, or
> >  2) The kernel defaults to the new Choice B, unless the
> >     flag reverts to the old Choice A?
> 
> If 2) is keeping the API semantics then 2.

No .. (1) keeps the same API semantics.


> Let everything be as it is today unless
> numactl sets the new.
> ...
> Tough. The API needs to remain stable. 

Good - that I understand.  Your position is clear now.

You have chosen (1) above, which keeps Choice A as the default.


Before I leave this part, there is one more thing I kinda really need,
if you could, Christoph.  Could you describe in your own words what you
think Choices A and B mean?  We seem to be having trouble communicating,
and hence there is some risk right now that we don't mean the same thing
by this new "Choice B".

===

Now ... onto the matter of permanent API warts:

> > I wonder if there might be some way to avoid that permanent ugly wart
> > on each and every set/get mempolicy system call forever afterward.
> 
> Hmmm.. The alternative is to add new set/get mempolicy functions.

Other alternatives include a per-system, per-cpuset or per-process
flag, in addition to the per-system call flag you suggested earlier
(MPOL_MF_RELATIVE), or whatever you mean by "new set/get mempolicy
functions" ... could you elaborate on that one?

So ... the question becomes this:

  How do we migrate to Choice B, without leaving both Choices
  permanently supported, and an ugly mode flag selecting the
  non-default Choice, while not breaking API's too abruptly?

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

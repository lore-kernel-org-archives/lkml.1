Return-Path: <linux-kernel-owner+w=401wt.eu-S1760149AbXJ2TCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149AbXJ2TCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbXJ2TCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:02:38 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:59591 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbXJ2TCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:02:37 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Paul Jackson <pj@sgi.com>
Cc: rientjes@google.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20071029114109.46285026.pj@sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
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
	 <1193670617.5035.38.camel@localhost>  <20071029114109.46285026.pj@sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 29 Oct 2007 15:01:42 -0400
Message-Id: <1193684503.5035.142.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 11:41 -0700, Paul Jackson wrote:
> Lee wrote:
> > Maybe it's just me, but I think it's pretty presumptuous to think we can
> > infer the intent of the application from the nodemask w/o additional
> > flags such as Christoph proposed [cpuset relative]--especially for
> > subsets of the cpuset.  E.g., the application could intend the nodemask
> > to specify memories within a certain distance of a physical resource,
> > such as where a particular IO adapter or set thereof attach to the
> > platform.
> 
> Well, yes, we can't presume to know whether some application can move
> or not.
> 
> But our kernel work is not presuming that.
> 
> It's providing mechanisms useful for moving apps.
> 
> The people using this decide what and when and if to move.
> 
> For example, the particular customers (HPC) I focus on for my job don't
> move jobs because they don't want to take the transient performance
> hit that would come from blowing out all their memory caches.
> 
> I'm guessing that David's situation involves something closer what you
> see with a shared web hosting service, running jobs that are very
> independent of hardware particulars.
> 
> But in any case, we (the kernel) are just providing the mechanisms.
> If they don't fit ones needs, don't use them ;).
> 

I'm with you on this last point!  I was reacting to the notion that we
can infer intent from a nodemask and that preserving the cpuset relative
numbering after changing cpuset resources or moving tasks preserves that
intent--especially if it involves locality and distance considerations.
I can envision sets of such transformations on HP platforms where
locality and distance would be preserved by preserving cpuset-relative
numbering, and many where they would not.  I expect you could do the
same for SGI platforms.  I'm not opposed to what you're trying to do,
modulo complexity concerns.  And I'm not saying that the complexity is
not worth it to customers.  But, given that we just "providing the
mechanism", I think we need to provide very good documentation on the
implications of these mechanism vis a vis whatever
characteristics--locality, distance, bandwidth sharing, ...--the
application intends when it installs a policy.

Like you, no doubt, I'm eyeballs deep in a number of things.  At some
point, I'll take a cut at enumerating various "intents" that different
types of applications might have when using mem policies and cpusets.
Others can add to that, or may even beat me to it.   We can then
evaluate how well these scenarios are served by the current mechanisms
and by whatever changes are proposed.

I should note that I really like cpusets--i.e., find them useful--and
I'm painfully aware of the awkward interactions with mempolicy.  On the
other hand, I don't want to sacrifice mem policy capabilities to shoe
horn them into cpusets.  In fact, I want to add additional mechanisms
that may also be awkward in cpusets.  As you say, "if they don't fit
your needs, don't use them."  

Later,
Lee


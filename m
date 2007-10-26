Return-Path: <linux-kernel-owner+w=401wt.eu-S1765454AbXJZUlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765454AbXJZUlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764668AbXJZUkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:40:10 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:44593 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764618AbXJZUkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:40:07 -0400
Subject: Re: [patch 3/3] cpusets: add memory_spread_user option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Paul Jackson <pj@sgi.com>
Cc: rientjes@google.com, akpm@linux-foundation.org, ak@suse.de,
       clameter@sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071026105431.77d56253.pj@sgi.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com>
	 <20071025230409.81f20ed3.pj@sgi.com>
	 <alpine.DEB.0.9999.0710260204590.8261@chino.kir.corp.google.com>
	 <20071026025634.0f32e1e2.pj@sgi.com> <20071026101805.df3ebfda.pj@sgi.com>
	 <1193420627.5032.46.camel@localhost>  <20071026105431.77d56253.pj@sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 26 Oct 2007 16:39:09 -0400
Message-Id: <1193431149.5032.60.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 10:54 -0700, Paul Jackson wrote:
> > Will it handle the case of MPOL_INTERLEAVE policy on a shm segment that
> > is mapped by tasks in different, possibly disjoint, cpusets.  Local
> > allocation does, and my patch does.  That was one of the primary
> > goals--to address an issue that Christoph has with shared policies.
> > cpusets really muck these up!
> 
> It probably won't handle that.  I don't get along too well with shmem.

Not surprising :).  shmem doesn't get along too well with cpusets.

> 
> Can you to an anti-shmem bigot how MPOL_INTERLEAVE should work with
         ^ explain ?
> shmem segments mapped in diverse ways by different tasks in different
> cpusets?  What would be the key attribute(s) of a proper solution?
> Maybe if we keep it simple enough, I can avoid mucking it up too much
> this time around.

Personally, I'm of the opinion "if it hurts when you do that, don't do
that".  I have uses for shared memory and mempolicies on the same, but
they don't involve sharing shmem [nor mapped files] between cpusets nor
dynamically changing cpusets.  So, my approach would be to document the
issues clearly [another reason I'd like to see cpuset man pages] and
make sure that folks can't accidentally trip over them.  But, I suppose
all the documentation in the world won't stop some people from hurting
themselves.  As my grandmother used to tell me, "children and fools
shouldn't play with sharp tools."  [Then she'd always ask me, "Which one
are you?"  I guess time has answered that question...]

Lee


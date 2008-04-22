Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbYDVIbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbYDVIbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbYDVIax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:30:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745AbYDVIav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:30:51 -0400
Date: Tue, 22 Apr 2008 10:30:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jason.wessel@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: kgdb: core
Message-ID: <20080422083038.GA28970@elte.hu>
References: <200804181741.m3IHfTeC012089@hera.kernel.org> <20080418150930.476ea7aa.akpm@linux-foundation.org> <20080421141252.GR9554@elte.hu> <20080421214636.617970c6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421214636.617970c6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > On Mon, 21 Apr 2008 16:12:52 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > > So please
> > > 
> > > a) make this a kerneldoc comment and
> > > 
> > > b) remove the kerneldoc at the definition site(s).
> > > 
> > > (alternative: teach the kerneldoc system to go fishing in the various 
> > > arch directories to find the appropriate documentation, but I don't 
> > > know enough about kerneldoc to be able say anything about that).
> > 
> > well there's lkml feedback ping-pong effect here. It was pointed out 
> > in earlier kgdb review that it's an "error" to put kerneldoc into 
> > header files.
> 
> It is, normally.  Nobody thought about this case.

in that review discussion i pointed out much of the same arguments you 
did in this mail.

> > I pointed out that it makes no sense to do otherwise but removed the 
> > kerneldoc annotation to resolve the "objection".
> 
> Duplicating the same stuff in multiple places is the larger sin.  It 
> sounds like the best compromise would be to kernel-doc the interface 
> in the .h file and remove the duplicated comments from .c.
> 
> Or perhaps we kernel-doc the interface in the x86 .c files and leave 
> it at that - people should go there to find the docs.  Problem is, 
> this will presumably generate bad results if one builds the formal 
> kerneldoc output for a different architecture.  The kerneldoc system 
> could of course fix this somehow, but I don't know what shape it would 
> take nor how much work it would be.

i'd rather just have it in the .h, to put KernelDoc into the position of 
getting fixed with a real testcase?

( _some_ comments in the arch file might be appropriate as well, but
  only if the arch implementation deviates from the common pattern in
  some way. )

It's not like this is a big issue, people writing KGDB arch support are 
not the typical readers of KernelDoc PDFs.

	Ingo

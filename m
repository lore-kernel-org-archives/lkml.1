Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZFSFkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZFSFkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 01:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZFSFkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 01:40:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51546 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZFSFkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 01:40:04 -0400
Date: Fri, 19 Jun 2009 07:39:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kyle@mcmartin.ca
Subject: Re: [GIT PULL] percpu for 2.6.31
Message-ID: <20090619053944.GB8162@elte.hu>
References: <4A39F5B4.1070305@kernel.org> <alpine.LFD.2.01.0906181421460.16802@localhost.localdomain> <4A3AC0BA.4000407@kernel.org> <4A3AEE42.4010300@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3AEE42.4010300@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, again.
> 
> Tejun Heo wrote:
> > Oops, my apologies.  I had them as floating series and apparently used
> > different base commit when applying them.  I did grep run and full yes
> > build on the original quilt tree but didn't after quiltimport.  Sorry.
> 
> I digged through git changelogs to find out where it went wrong.  
> I did use the same base commit when quiltimporting but when I 
> updated the patches on top of mainline two days ago, I forgot to 
> quilt add the file and the mce change got committed to the base 
> tree instead of quilt patch.  After pulling the latest master into 
> the quilt branch yesterday, I updated the series for newcomers and 
> everything worked fine (as the base tree change got merged by 
> git).  quiltimporting of course lost the base tree change and 
> thinking the output gotta be identical I didn't test the final git 
> tree.
> 
> Anyways, I'm dropping the for-linus branch from percpu tree, 
> fixing it up, adding patchsets scheduled for .32 release and will 
> try to get it merged into #linux-next.

Please create a -git based bit for the x86 side (as i asked you 
previously) - we can certainly get that upstream sooner after the 
necessary amount of testing.

Condolences for trying to improve a dozen SMP architectures at once, 
you've ended up with:

 - being forced to rebase all the time. (This will happen in the
   cycle to come too: just watch as the conflicts in linux-next
   mount up with the architecture trees. Your tree will become
   crappy quickly due to the combined noise.)

 - the 10x patch logistics end up killing your overall quality, let
   crap creep in and cause breakage even on x86.

You wasted 3 months of your life on that. Now you've learned not to 
do that ever again - i've been there, done that, got the T-shirt.

Just stick your new stuff behind an ARCH_HAS flag, add it to the 
architecture(s) you care about and forget about the rest - let the 
remaining arch maintainers pick things up in their own pace. You'll 
get 90% of the benefits to Linux with just 30% of the work.

( Many wont btw: we still dont have lockdep support in all
  architectures - 3 years and counting. It's a highly useful purely
  sw feature with zero hardware dependencies. Fortunately it's
  well-modularized and the functionality is non-essential. Percpu
  allocation is not so lucky as it's essential functionality. )

	Ingo

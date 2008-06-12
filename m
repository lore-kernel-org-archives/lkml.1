Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbYFLK6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbYFLK6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbYFLK5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:57:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48631 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbYFLK5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:57:55 -0400
Date: Thu, 12 Jun 2008 12:57:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 0/5] x86: minor PAT adaptations
Message-ID: <20080612105740.GA20156@elte.hu>
References: <20080610140411.GD5024@alberich.amd.com> <20080612081029.GA1403@elte.hu> <20080612100110.GA7763@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612100110.GA7763@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> > > patch 5 - slightly changing the code that is doing the intersection of
> > >           pat_type and mtrr_type to be more readable (from my point of view)
> > > 
> > > Patches are against x86/pat (as of version 
> > > v2.6.26-rc3-6-g46dd98a).
> > 
> > #5 makes sense too, but it didnt apply cleanly:
> 
> That's odd. I've double checked it by doing a fresh
> 
> $ git remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> $ git remote update
> $ git checkout tip/x86/pat
> 
> and applying patches 1-5 in sequence without problems.
> (Patches were taken from emails that arrived via my linux-kernel
> subscription.) Probably your tip/x86/pat is not at
> v2.6.26-rc3-6-g46dd98a?

it was there - but some other commit from upstream interfered.

> When trying to apply the patches to tip/master I get rejects for 
> patches 3 and 5.
> 
> Hence I think creating my patches against a feature branch was not a 
> good idea.

it was a good idea - as that the final destination where the PAT patches 
end up.

current tip/x86/pat head is:

 tip/x86/pat 499f8f8: x86: rename pat_wc_enabled to pat_enabled

> >  1 out of 1 hunk FAILED -- rejects in file arch/x86/mm/pat.c
> > 
> > (it didnt apply neither against tip/x86/pat or tip/master, nor against 
> > linus/master. I guess it's some mixup somewhere.)
> 
> Ok, it's commit 282c454cd3a7041f59a37112bb2f82263bc38f6c which was not 
> contained in the tip/x86/pat branch. This means I have to adapt patch 
> 5.

indeed. I cherry-picked this commit meanwhile into x86/pat.

> Finally a dumb question. What patches do you prefer? Patches against 
> feature branches (say tip/x86/foo), against tip/master or against 
> tip/auto-latest as described in your tip.git-Readme?

either is fine - but if you make specific topic updates it's best to do 
them against the topic branch and we'll integrate them all together. If 
in doubt, using tip/master doesnt hurt.

usually i do this: i update x86/pat, then i switch to 'master' and check 
whether it all merges cleanly via 'git-merge x86/pat'.

when you switch to a topic branch, you might also want to update to the 
latest linus tree via 'git-merge linus/master', to pick up all other 
fixes as well. The topic branches always merge cleanly to linus-latest. 
(we automate that - the x86/pat topic branch is not stale as its -rc3 
base would suggest, there simply was no need to merge it to Linus-latest 
up to now)

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbYD0LXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbYD0LXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 07:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbYD0LXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 07:23:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52475 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439AbYD0LXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 07:23:10 -0400
Date: Sun, 27 Apr 2008 13:22:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk
Subject: Re: CONFIG_OPTIMIZE_INLINING
Message-ID: <20080427112256.GA23139@elte.hu>
References: <20080426.215513.141243565.davem@davemloft.net> <20080427055943.GA16290@elte.hu> <20080426.230807.144232984.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.230807.144232984.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 27 Apr 2008 07:59:43 +0200
> 
> > ... as i saw no reason why this feature, which i found rather 
> > useful, should be delayed another year or so. I'd be more than happy 
> > to promote this feature back to lib/Kconfig.debug, sparc64 interest 
> > would make that a strong argument.
> 
> So you caved in to FUD in order to pad your commit and signoff count?
> 
> Because anyone who is paying attention can see clearly that you're 
> trying to push as much stuff as quickly as possible into Linus's tree 
> with your singoffs and authorship on it this merge window.
> 
> Gee, I wonder why...

That suggestion is ridiculous but i guess i have to reply to it.

Firstly, i've been given more credit in Linux already than is enough for 
a lifetime ;-) 1000+ changes down the line the joy of having yet another 
commit upstream is ... minimal. I'm more interested in seeing Linux 
progress as a whole and most of my pride goes towards the whole 
structure not towards individual changes.

Secondly, you dont even have to take my word on this one. Was there even 
a shred of truth to the claim above i'd surely must have split up this 
recent x86 commit into many small commits:

| commit a4928cffe6435caf427ae673131a633c1329dbf3
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Wed Apr 23 13:20:56 2008 +0200
|
|    "make namespacecheck" fixes
|
|    Signed-off-by: Ingo Molnar <mingo@elte.hu>

  arch/x86/kernel/apic_32.c     |    2 +-
  arch/x86/kernel/apic_64.c     |    4 ++--
  arch/x86/kernel/process_32.c  |    2 +-
  arch/x86/kernel/process_64.c  |    2 +-
  arch/x86/kernel/setup_32.c    |    4 ++--
  arch/x86/kernel/smpboot.c     |   12 ++++++------
  arch/x86/kernel/tlb_64.c      |    2 +-
  arch/x86/kernel/vsyscall_64.c |    2 +-
  arch/x86/mm/dump_pagetables.c |    2 +-
  arch/x86/mm/pageattr.c        |    2 +-
  arch/x86/mm/srat_64.c         |    2 +-
  include/asm-x86/smp.h         |    1 -
  include/asm-x86/tsc.h         |    1 -
  13 files changed, 18 insertions(+), 20 deletions(-)

i could have made that 13 separate commits - as it is done with these 
kinds of commits all around the tree (networking included, see commit 
263173af).

Right?

And i routinely backmerge my fixlets into the body of the patch. In the 
current merge window alone:

 $ earth4:~/v> git-log v2.6.25.. | grep ' \[ mingo@elte'
    [ mingo@elte.hu: minor cleanups. ]
    [ mingo@elte.hu: redesign, splitups, cleanups. ]
    [ mingo@elte.hu: heavily modified, simplified and cleaned up. ]
    [ mingo@elte.hu: do it on gbpages kernels too, there's no clear reason
    >     [ mingo@elte.hu: build fix ]
    [ mingo@elte.hu: build fix ]
    [ mingo@elte.hu: fix boot regression. ]
    [ mingo@elte.hu: x86: fix the pagetable dumper ]

... without creating a separate commit for the fixes.

But it's more than that: in fact i change the code in the _majority of 
commits_ that i accept (various minor errors are very common), without 
creating small fixlets. Most of the patches have to be edited trivially 
for one or another reason - and that's just the code portion - 99% of 
the commit messages of them has to be edited, most of them 
substantially.

So if i were creating commits for each of those edits we'd have ~500-600 
more trivial commits in this merge window alone. And i know you do this 
fix backmerging too and it's the correct maintenance practice IMO.

As an example for this practice, look at the current raw, unprocessed, 
not-yet-backmerged ftrace tree that i just posted to lkml. It has 34 
commits from me:

> >   Ingo Molnar (34):

about 30 of those commits will go away completely by the time i post 
that for upstream.

So not only is that claim patently untrue, it's the _exact opposite_ of 
what i'm doing day to day.

	Ingo

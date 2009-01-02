Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbZABUjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbZABUjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbZABUi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:38:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36089 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbZABUi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:38:57 -0500
Date: Fri, 2 Jan 2009 21:38:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
Message-ID: <20090102203839.GA26850@elte.hu>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 1 Jan 2009, Rusty Russell wrote:
> >
> > OK, this is the bulk of the conversion to the new cpumask operators. 
> > The x86-specific parts (the most aggressive large-NR_CPUS arch) are 
> > going via Ingo's tree.
> 
> This gets lots of conflicts for me. Some of them look simple enough, but 
> not all. io_apic.c gets lots of nasty conflicts, and it _looks_ like I 
> should just pick the version of the file that I already have (because 
> the only thing that comes in from that is yet another merge commit), but 
> kernel/sched.c also gets conflicts in areas with FIXME's etc.
> 
> Rusty, Ingo, can you work this out? I pushed out my current tree.

yes, we have those conflicts all resolved already in the second phase of 
the tip/cpus4096 changes: Mike did all those difficult conflict 
resolutions over the hollidays and i pulled it yesterday.
 
The end result looks nice as a tree but it is not fully cooked yet: since 
i pulled yesterday i found a couple of build and runtime test failures 
with Rusty's latest cpumask tree:

 - architectures that have no __fls (8 out of 21) fail to build:

     arch/cris
     arch/frv
     arch/h8300
     arch/m32r
     arch/m68k
     arch/mn10300
     arch/xtensa

 - there's a new circular locking lockdep splat in CPU hotplug tests when
   the var-cpumask code is enabled. (needs a handful of default-off
   options enabled in the .config)

So i didnt want to push the second phase to you until those known bugs are 
sorted out - i think we need some more time for that - a day or two at 
most.

Linus, would you like to pull that, despite the pending regressions? Can 
send a pull request right away.

Rusty, would it be fine with you if we did all the remaining bits via 
tip/cpus4096? It's your tree and your bits and we wanted to send our 
remaining bits after your tree went to Linus but the conflict resolutions 
from Mike are valuable so i think we should reconsider the ordering.

All the commits you sent to Linus in this pull request are already 
included in tip/cpus4096, the conflicts that Linus hit are all non-trivial 
and Mike resolved them correctly and it merges cleanly with Linus's latest 
tree:

  earth4:~/tip> git pull   
  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask.git master
  From git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask
   * branch            master     -> FETCH_HEAD
  Already up-to-date.

The pending diff is:

  108 files changed, 1442 insertions(+), 979 deletions(-)

which is pretty OK and straightforward.

With that Rusty and Mike has done 99% of the cpumask conversions, so the 
most difficult phase of the conversion should be dealt with in .29. Cool 
stuff.

	Ingo

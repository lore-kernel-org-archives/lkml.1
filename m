Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0CEHo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:44:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47463 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab0CEHo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:44:28 -0500
Date: Fri, 5 Mar 2010 08:44:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ben Skeggs <skeggsb@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305074407.GC19703@elte.hu>
References: <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
 <20100304105624.70fe845e@jbarnes-piketon>
 <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
 <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
 <1267748927.3496.6.camel@nisroch>
 <20100305064955.GA6453@elte.hu>
 <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Fri, Mar 5, 2010 at 8:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > The conclusion is crystal clear, breaking an ABI via a "flag day"
> > cleanup/feature/etc is:
> >
> > ?- wrong
> >
> > ?- harmful
> >
> > ?- limits the developer base
> >
> > ?- limits the tester base
> >
> > ?- wastes time and effort. (fewer developers/testers means that while _this_
> > ? feature was easier to add, all your _future_ features will be a bit harder
> > ? to do. It compounds up.)
> >
> > ?- so it hurts even the very developer who is most convinced that this was the
> > ? right thing to do
> >
> > It's a bad technical decision throughout. It's masochistic and often suicidal
> > to just about any project in essence. I've seen projects that did it once and
> > died just due to that single act of stupidity. I've seen projects that have
> > done it a few times and took the usage hit, limped along with the wounds and
> > never grew to the size they could have achieved. I've seen projects that did
> > it once, took the hit, learned from it and never did it again.
> 
> Agreed. What bothers me in this discussion is that people keep bringing up 
> the fact that nouveau is mostly developed by volunteers and thus it doesn't 
> make sense to make sure it's backwards (or forwards) compatible. But the way 
> I see it, it's the complete opposite. It's _more_ important to support ABIs 
> for community-driven efforts because you're relying on people who by 
> definition don't have time to waste. While the nouveau people might have 
> good intentions, I'm afraid they might be severely limiting their developer 
> and tester base because they're not focused on real world problems (like the 
> ones Linus is seeing).

Yeah. I've seen a few other bad arguments as well:

   'exploding test matrix'

This is often the result of _another_ bad technical decision: 
over-modularization.

Xorg, mesa/libdrm and the kernel DRM drivers pretty share this signature:

 - it's developed by the same tightly knit developer base who often cross
   between these packages. Features often need changes in each component.

 - a developer to be able to do real work has to have the latest sources
   of all these components.

 - a user just uses whatever horizontal version cut the distro did and never
   truly 'mixes' these components as a conscious decision.

 - distros just try to get the latest and most capable but still stable
   version. Desperately so. Often they will create a version mix that was
   never tested by developers in that form. They'll expose users to ABI
   combinations that were never really intended. They have trouble
   bootstrapping and stabilizing those essentially random combinations and
   then have trouble applying stability and security fixes.

The thing is, if development has such characteristics then it's pretty clearly 
not 3-4 separate projects but _one_ abstract project. [*]

So the 'exploding test matrix' is simply the result of: creating ABIs between 
3-4 _artificial components of the same project_ and then going through 
developer hell living with that mistake. [**]

It's a bit as if we split up the kernel into 'microkernel' components, did a 
VFS ABI, MM ABI, drivers ABI, scheduler ABI, networking ABI and arch ABIs, and 
then tried to develop them as separate components.

If we did then then Linux kernel development would slow down massively while 
in reality everyone would _still_ have to have the latest and greatest source 
checked out to do some real development work and to be able to implement 
features that affect the whole kernel ...

Linux would become an epic fail of historic proportions if we ever did that.

	Ingo

[*]  I realize that it's possibly hard for Xorg to merge with mesa and the 
     kernel for license reasons, but my technical observation still stands.

[**] I realize that modularization and many small packages were a clear 
     advantage when we were still all downloading bits via 14.4k modems, but 
     in this day and age of megabit connections that has become a non-issue.
     Rampant over-modularization and the resulting loss of focus on the end
     result (and the resulting explosion of a test matrix) is hurting us _far 
     more_ than the disadvantages of any monolithic could ever hurt. We are 
     seeing the proof of that all day with a 10+ MLOC kernel.

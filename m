Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZDNVjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZDNVjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZDNVji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:39:38 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34338 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZDNVjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:39:37 -0400
Date: Tue, 14 Apr 2009 16:39:34 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, mingo@elte.hu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090414213934.GB17986@us.ibm.com>
References: <20090410023207.GA27788@x200.localdomain> <1239340031.24083.21.camel@nimitz> <20090413091423.GA19236@x200.localdomain> <49E4108A.8050201@cs.columbia.edu> <20090414145830.GA27461@x200.localdomain> <49E4D115.5080601@cs.columbia.edu> <20090414204912.GA28458@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414204912.GA28458@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > >>> * not having CAP_SYS_ADMIN on restart(2)
> > >> Surely you have read already on the containers mailing list that
> > >> for the *time being* we attempt to get as far as possible without
> > >> requiring root privileges, to identify security hot-spots.
> > > 
> > > More or less everything is hotspot.
> > 
> > Going back to my example of a subtree above: what sort of security
> > issues you would have here, assuming all restart operations go via
> > the usual security checks just like syscalls, and we take special
> > care about values we allow as input, e.g. cpu debug registers etc ?
> 
> This is like asking if everything goes through correct security checks
> how will you screw something up. Everything won't go via usual security
> checks.

(Everything which doesn't go through usual security checks gets special
security checks...)

You are asking an administrator to give users setuid-root programs when
they wouldn't otherwise need it.  So now not only is there potential of
security holes in kernel code which was written under the assumption
that 'hey you have privilege when you run this so are trusted'.  You
also have more people running probably even less-vetted userspace code
with privilege.

> Just for giggles, writing exploit for localhost hole becomes easier --
> you very effectively turn off all randomization kernel does because VMA
> boundaries comes from disk.

Hmm, interesting point.

But again you're going on a naive assumption that if restart requires
privilege, only trusted users will use it.  Rather, in the real world,
I claim that unprivileged users will be given more privilege than they
need.

> > BTW, the checks for cpu registers and other values for sanity is
> > needed anyway to ensure that the kernel freak out if wrong input
> > is fed (maliciously or by mistake).
> 
> Out of head, mucking with registers of setuid program is no-no.
> As well as mucking with dirty data of setuid program.

No argument there, no idea why you bring this up.

> Capabilities will come from disk.

Sure.

> Many EPERM checks are suspect.

No idea what you're saying.

> do_arch_prctl(ARCH_SET_GS) has TASK_SIZE check, do you?

We don't support x86_64 yet :)

> > >> And surely you have read there the observation that for the general
> > >> case root privileges will probably be inevitable.
> > >>
> > >> And surely you don't seriously think that adding this check changes
> > >> the "design"...
> > > 
> > > This is not about design now, this is about if you allow restart(2) for
> > > everyone, you open kernel to very very high number of holes of all
> > > types. I wrote about it in reply to your code.
> > > 
> > 
> > And there are many examples where this is not the case. The current
> > patchset (v14-rc3), for example, to the best of my knowledge, does
> > not have such issues (well, need to add checks for validity of regs
> > but there is a FIXME comment :)
> 
> And such an obvious issue like segmentt RPL is fixed? :-)

-serge

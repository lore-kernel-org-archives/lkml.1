Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbZC3BOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbZC3BOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZC3BOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:14:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56724 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbZC3BON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:14:13 -0400
Date: Mon, 30 Mar 2009 03:13:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: fault.c cleanup, what else could it be
Message-ID: <20090330011355.GA11087@elte.hu>
References: <20090329175642.GA26405@x200.localdomain> <20090329232422.GA9873@elte.hu> <20090329234839.GL28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329234839.GL28946@ZenIV.linux.org.uk>
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


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Mar 30, 2009 at 01:24:22AM +0200, Ingo Molnar wrote:
> > 
> > * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > 
> > > I have personally stopped sending anything against pure arch/x86/ 
> > > if there is even a smallest chance it can be prettyfied like this.
> > 
> > Before you volunteer reviewing x86 code for us (thanks for that!), 
> > may i direct your urgent attention at code in your own area of 
> > responsibility - such as fs/proc/base.c:
> > 
> >     total: 85 errors, 39 warnings, 2 checks, 3147 lines checked
> > 
> > I filtered out the relevant ones for you below.
> 
> This is precisely what's wrong with your advocacy.  I actually 
> have no problem with specific instances pointed to by 
> checkpatch.pl in this case; when code in question gets touched, 
> sure, getting rid of those would be OK. *HOWEVER*, implying that 
> this noise should take priority over any real work is bloody 
> insane. [...]

There is simply no excuse for ever having let that crap get there 
into fs/proc/base.c. There is no excuse for ever letting that crap 
grow. The fact that that crap is there is proof of systemic failure 
over the years to keep that code clean.

I dont really want to see "real work" done on code that was not 
properly and cleanly finished in the first place.

Code cleanliness does matter in the long run: easy crap on the 
surface fosters crap deep inside as well. I've yet to see 
crappy-looking but picture perfectly designed code. Crap is removed 
in layers: you start at the most visible outside layer first and go 
down step by step. If you let crap remain on the surface you obscure 
the real bugs.

> [...] And replying to mail that questions the usefulness of such 
> activity with "shut up, do what you've pretty much called 
> pointless and don't come back until you are done"... fie, sir.

Had you taken just a fleeting look at the git log you'd have 
discovered that that mail unfairly singled out a cleanup commit 
which was the preparatory cleanup to a long series of structural 
commits to fault.c:

b319eed: x86, mm: fault.c, simplify kmmio_fault(), cleanup
f8eeb2e: x86, mm: fault.c, update copyrights
cd1b68f: x86, mm: fault.c, give another attempt at prefetch handing before SIGBUS
7c178a2: x86, mm: fault.c, remove #ifdef from fault_in_kernel_space()
d951734: x86, mm: rename TASK_SIZE64 => TASK_SIZE_MAX
c3731c6: x86, mm: fault.c, remove #ifdef from do_page_fault()
1cc9954: x86, mm: fault.c, unify oops handling
8f76614: x86, mm: fault.c, unify oops printing
f2f13a8: x86, mm: fault.c, reorder functions
b180181: x86, mm, kprobes: fault.c, simplify notify_page_fault()
b814d41: x86, mm: fault.c, simplify kmmio_fault()
121d5d0: x86, mm: fault.c, enable PF_RSVD checks on 32-bit too
8c938f9: x86, mm: fault.c, factor out the vm86 fault check
107a036: x86, mm: fault.c, refactor/simplify the is_prefetch() code
2d4a716: x86, mm: fault.c cleanup

And that's really the expected upstream behavior: get code clean 
first, modify it with "real work" after that.

	Ingo

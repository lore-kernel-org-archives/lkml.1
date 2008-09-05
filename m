Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbYIEQxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbYIEQxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbYIEQw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:52:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57511 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYIEQw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:52:59 -0400
Date: Fri, 5 Sep 2008 18:52:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080905165239.GA12645@elte.hu>
References: <20080905154221.GF10292@elte.hu> <48C15D0A.6363.4324231@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C15D0A.6363.4324231@pageexec.freemail.hu>
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


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> > i think Linux is fundamentally different here as we have the source 
> > code, and could apply the randomization technique i mentioned:
> 
> how's that supposed to work for the binary distros, i.e., the majority 
> of end users? [...]

it takes less than 10 minutes to build a full kernel on recent hardware. 
Can be done in the background after install or so.

> [...] and who would look at all the bugreports from such kernels?

yes, in this area debuggability is in straight conflict. Since we can 
assume that both attacker and owner has about the same level of access 
to the system, making the kernel less accessible to an attacker makes it 
less accessible/debuggable to the owner as well.

> > > > [ It would be nice to have a 'randomize instruction scheduling' 
> > > >   option for gcc, to make automated attacks that recognize specific 
> > > >   instruction patterns less reliable. ]
> > 
> > and every box where it matters we could have a _per box_ randomized 
> > kernel image in essence, with non-essential symbols thrown away, and 
> > with a few checks inserted in random locations - inlined and in essence 
> > unrecognizable from the general entropy of randomization.
> > 
> > Not that a randomizing compiler which inserts true, hard to eliminate 
> > entropy would be easy to implement. But once done, the cat and mouse 
> > game is over and the needle is hidden in the hay-stack. At least as long 
> > as transparent rootkits are involved.
> > 
> > a successful attack that wants to disable the checks
> 
> why do you assume that an attacker wants to do that? it's equally 
> possible, and there's even academic research on this in addition to 
> the underground cracking scene, that one simply hides the 
> modifications from the checker.
> 
> from marking your patched code as unreadable to executing it from a 
> different place than what the checker checks, there're many ways to 
> trick such checkers. as far as reality goes, it's never been game over 
> ;).

well at least in the case of Linux we have a fairly good tally of what 
kernel code is supposed to be executable at some given moment after 
bootup, and can lock that list down permanently until the next reboot, 
and give the list to the checker to verify every now and then? Such a 
verification pass certainly wouldnt be cheap though: all kernel 
pagetables have to be scanned and verified, plus all known code (a few 
megabytes typically), and the key CPU data structures.

	Ingo

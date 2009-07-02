Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZGBHWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZGBHWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZGBHWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:22:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50100 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbZGBHWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:22:03 -0400
Date: Thu, 2 Jul 2009 09:21:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Code atomic(64)_read and atomic(64)_set in C not
	CPP [was Re: FRV: Implement atomic64_t]
Message-ID: <20090702072157.GA11596@elte.hu>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <19019.59848.918621.635117@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19019.59848.918621.635117@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Occasionally we get bugs where atomic_read or atomic_set are used 
> on atomic64_t variables or vice versa.  These bugs don't generate 
> warnings on x86 because atomic_read and atomic_set are coded as 
> macros rather than C functions, so we don't get any type-checking 
> on their arguments; similarly for atomic64_read and atomic64_set 
> in 64-bit kernels.
> 
> This converts them to C functions so that the arguments are 
> type-checked and bugs like this will get caught more easily. It 
> also converts atomic_cmpxchg and atomic_xchg, and atomic64_cmpxchg 
> and atomic64_xchg on 64-bit, so we get type-checking on their 
> arguments too.
> 
> Compiling a typical 64-bit x86 config, this generates no new 
> warnings, and the vmlinux text is 86 bytes smaller.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Thanks Paul!

> ---
> Linus Torvalds writes:
> 
> > Btw, Ingo: I looked at the x86-32 versions to be sure, and noticed a 
> > couple of buglets:
> > 
> >  - atomic64_xchg uses "atomic_read()". Sure, it happens to work, since 
> >    the "atomic_read()" is not type-safe, and gets a non-atomic 64-bit 
> >    read, but that looks really really bogus.
> > 
> >    It _should_ use __atomic64_read(), and the 64-bit versions should use a 
> >    different counter name ("counter64"?) or we should use an inline 
> >    function for atomic_read(), so that the type safety issue gets fixed.
> 
> I did this patch a few weeks ago (before the merge window) and 
> sent it to Ingo, Thomas & Peter, but it seems to have got lost.

Yeah, as i noted back then off-list i didnt take it due to it 
causing a criss-cross merge:

| > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
|
| Nice - could someone please remind us later in the merge window to 
| have a look at this again? Right now this needs to go into 
| perfcounters/core - but i'd like to avoid having to do too many 
| cross-changes there.

Linus reminded us ;-)

        Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbXFPTE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbXFPTE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 15:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXFPTES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 15:04:18 -0400
Received: from www.osadl.org ([213.239.205.134]:33752 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751631AbXFPTER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 15:04:17 -0400
Subject: Re: Separate arch patching (Re: [patch-mm 06/25] clockevents: Fix
	resume logic)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <E1HzdMW-0007PJ-Et@flower>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
	 <20070616101636.756850073@inhelltoy.tec.linutronix.de>
	 <E1HzdMW-0007PJ-Et@flower>
Content-Type: text/plain
Date: Sat, 16 Jun 2007 21:04:14 +0200
Message-Id: <1182020654.8176.398.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg,

On Sat, 2007-06-16 at 20:51 +0200, Oleg Verych wrote:
> >  arch/arm/plat-omap/timer32k.c     |    2 +
> 
> Testers and users are most likely to run one particular arch on
> one particular test bench. If individual patches are arch
> separated, i think bisecting will be a little bit easier.

No it is not. See below.

> Thus, i would like to propose separate arch patching (x86_64/i386 mainly).

This change adds an enum entry in a generic header file. _ALL_ users of
clock events have a switch(this_changed_enum) in the set_mode()
function. _ALL_ of them will spit warnings and some of them will even
break, when the fix up is not done in one go.

> Is it possible to do that? (And even set such check in ``checkpatch''?)

It's possible, but results in an commit which will affect bisecting. I'm
not going to send a patch which knowingly breaks bisecting either at
compile or at run time.

> You would say, why? Because current kbuild/kconfig support of builds
> for whole tree.
> 
> That's because to make download, build, test and debug particular arch
> more easily, i'm trying to re-think and re-do some kbuild parts. With
> minimum set of files, downloaded with git one can spend less
> time/bandwidth for starting testing.

Oh, well. That's going to be an interesting feature for git and the
result will be published kernel trees with a total delta of 40MB against
mainline, because someone tweaked the stuff in a way that it contains
only the relevant files for a particular sub architecture. Embedded
folks do this already and it makes it extremely hard to do efficient
trouble shooting on such crippled trees. No thanks.

If we would still have 9600 Baud modem connections I would understand
that, but git is really effective since packing was added, so this
argument is more or less an academic exercise.

	tglx



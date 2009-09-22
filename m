Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZIVH2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZIVH2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZIVH2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:28:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43742 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZIVH2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:28:52 -0400
Date: Tue, 22 Sep 2009 09:28:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] perf_event, powerpc: Fix compilation after big
	perf_counter rename
Message-ID: <20090922072834.GA25470@elte.hu>
References: <19128.4280.813369.589704@cargo.ozlabs.ibm.com> <1253584591.7103.197.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253584591.7103.197.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2009-09-22 at 09:48 +1000, Paul Mackerras wrote:
>
> > This fixes two places in the powerpc perf_event (perf_counter) code 
> > where 'list_entry' needs to be changed to 'group_entry', but were 
> > missed in commit 65abc865 ("perf_counter: Rename list_entry -> 
> > group_entry, counter_list -> group_list").

Oops, indeed - queued up the fix and will send it to Linus shortly - 
thanks!

> Ingo: This is becoming a recurring one now... powerpc build upstream 
> is broken approx everyday by some new perfctr build breakage.
>
> You really aren't build testing other architectures than x86 right ?

On the contrary - i am build testing every architecture on a daily 
basis. (and sometimes i do it multiple times a day - yesterday i did 5 
cross builds during the rename) In fact i am testing more architectures 
than linux-next does.

Here's the log of the test i ran yesterday before i sent those bits to 
Linus:

testing 24 architectures.
                                 (warns)               (warns)
testing      alpha:  -git:  pass (   24),  -tip:  pass (   24)
testing        arm:  -git:  fail (   11),  -tip:  fail (   13)
testing   blackfin:  -git:  pass (    3),  -tip:  pass (    3)
testing       cris:  -git:  fail (   34),  -tip:  pass (   20)
testing        frv:  -git:  fail (   13),  -tip:  fail (   13)
testing      h8300:  -git:  fail (  441),  -tip:  fail (  185)
testing       i386:  -git:  pass (    2),  -tip:  pass (    5)
testing       ia64:  -git:  fail (  172),  -tip:  pass (  160)
testing       m32r:  -git:  pass (   39),  -tip:  pass (   39)
testing       m68k:  -git:  pass (   42),  -tip:  pass (   42)
testing  m68knommu:  -git:  fail (   80),  -tip:  fail (   80)
testing microblaze:  -git:  fail (   14),  -tip:  fail (   14)
testing       mips:  -git:  pass (    6),  -tip:  pass (    6)
testing    mn10300:  -git:  fail (   10),  -tip:  fail (   10)
testing     parisc:  -git:  pass (   26),  -tip:  pass (   26)
testing    powerpc:  -git:  fail (   36),  -tip:  fail (   45)
testing       s390:  -git:  pass (    6),  -tip:  pass (    6)
testing      score:  -git:  fail (   13),  -tip:  fail (   13)
testing         sh:  -git:  fail (   22),  -tip:  fail (   19)
testing      sparc:  -git:  pass (    3),  -tip:  pass (    3)
testing         um:  -git:  pass (    3),  -tip:  pass (    3)
testing     xtensa:  -git:  fail (   46),  -tip:  fail (   46)
testing     x86-64:  -git:  pass (    0),  -tip:  pass (    0)
testing     x86-32:  -git:  pass (    0),  -tip:  pass (    0)

In fact there are architectures that dont build in Linus's tree and 
build in -tip:

testing       cris:  -git:  fail (   34),  -tip:  pass (   20)

Because not only do i test every architecture i also try to fix upstream 
bugs on non-x86 pro-actively. See for example this upstream fix:

 8d7ac69: Blackfin: Fix link errors with binutils 2.19 and GCC 4.3

Nevertheless you are right that i should have caught this particular 
PowerPC build bug - i missed it - sorry about that!

Thanks,

	Ingo

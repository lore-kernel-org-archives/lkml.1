Return-Path: <linux-kernel-owner+w=401wt.eu-S1758452AbXGKRnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbXGKRnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761981AbXGKRne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:43:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37757 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760908AbXGKRnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:43:32 -0400
Date: Wed, 11 Jul 2007 19:42:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070711174252.GA16793@elte.hu>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p734pkbyuu4.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > clockevents-fix-typo-in-acpi_pmc.patch
> > timekeeping-fixup-shadow-variable-argument.patch
> > timerc-cleanup-recently-introduced-whitespace-damage.patch
> > clockevents-remove-prototypes-of-removed-functions.patch
> > clockevents-fix-resume-logic.patch
> > clockevents-fix-device-replacement.patch
> > tick-management-spread-timer-interrupt.patch
> > highres-improve-debug-output.patch
> > hrtimer-speedup-hrtimer_enqueue.patch
> > pcspkr-use-the-global-pit-lock.patch
> > ntp-move-the-cmos-update-code-into-ntpc.patch
> > i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
> > i386-remove-volatile-in-apicc.patch
> > i386-hpet-assumes-boot-cpu-is-0.patch
> > i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
> > x86_64-untangle-asm-hpeth-from-asm-timexh.patch
> > x86_64-use-generic-cmos-update.patch
> > x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
> > x86_64-fix-apic-typo.patch
> > x86_64-convert-to-cleckevents.patch
> > acpi-remove-the-useless-ifdef-code.patch
> > x86_64-hpet-restore-vread.patch
> > x86_64-restore-restore-nohpet-cmdline.patch
> > x86_64-block-irq-balancing-for-timer.patch
> > x86_64-prep-idle-loop-for-dynticks.patch
> > x86_64-enable-high-resolution-timers-and-dynticks.patch
> > x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
> 
> I'm sceptical about the dynticks code. It just rips out the x86-64 
> timing code completely, which needs a lot more review and testing. 
> Probably not .23

What you just did here is a slap in the face to a lot of contributors 
who worked hard on this code :(

Let me tell you about the history of this project first. Arjan wrote the 
first version of it a year ago, and it was added to -rt and tested there 
by many people and went through many iterations and fixes. Chris Wright 
then created a x86_64 clockevents cleanup and dynticks enabling patchset 
from it this spring and sent it to lkml three and a half months ago, on 
March 31:

    http://lwn.net/Articles/229094/

Thomas, the high resolution timers and clockevents maintainer, 
immediately picked up Chris' splitup/splitout/cleanup work and fixed and 
extended it, and sent a first cut to lkml on May 6th:

    http://lwn.net/Articles/233226/

Thomas then sent an updated version of the x86_64 clockevents cleanup 
and dynticks code to lkml (on June 10th), for a second round of review:

    http://lwn.net/Articles/237687/

As Thomas stated it in his submission:

  " The patch set has been tested in the -hrt and -rt trees for quite a 
    while and the initial problems have been sorted out. Thanks to the 
    folks from the PowerTop project for testing and feedback. "

Then on June 16th Thomas sent the third series:

    http://lwn.net/Articles/238834/

(which too was in -rt and was tested there on numerous machines. It was 
also added to -mm.)

Then on June 23rd Thomas sent the fourth series of the x86_64 
clockevents and dynticks code:

    http://lwn.net/Articles/239620/

We finally have someone (Thomas) with core kernel clue who actually 
_cares_ about the x86 time code and does not see it as an ugly chore, 
one who collects the right patches and maintains the -hrt tree and 
co-maintains the -rt tree and interacts with other contributors. What he 
did was _hard_ to do but we are making really good progress:

   http://lkml.org/lkml/2007/7/5/242

   " All in all, personally I'm very happy to see Linux making such a 
     huge step forward with tickless and can't wait for this step to be 
     available in all distros and for all architectures... "

Yes, touching the time code is a pain because both the hardware and the 
kernel has skeletons hidden in the closet, but we are mapping them one 
by one, and we already fixed several kernel skeletons in the process. 
The code is in -mm and there is no open regression related to this queue 
of patches at the moment.

But what is curiously absent from all this positive and dynamic activity 
around these patches on lkml? There is not a single email from Andi 
Kleen, the official maintainer of the x86_64 tree directly reacting to 
this submission in any way, shape or form. Not a single email from you 
thanking Arjan, Chris and Thomas for this amount of cleanup to the 
architecture you are maintaining:

   31 files changed, 698 insertions(+), 1367 deletions(-)

Not a single email from you reviewing the patchset in any meaningful 
way. Not a single email from you to indicate that you even did so much 
as boot into this patchset.

What contribution do we have from you instead? A week before the .23 
merge window is closed, in the very last possible moment, we finally get 
your first reaction to this patchset, albeit in the form of three terse 
sentences:

  > I'm sceptical about the dynticks code. It just rips out the x86-64 
  > timing code completely, which needs a lot more review and testing. 
  > Probably not .23

In the past 3+ months there was not a single email from you indicating 
that you are "doubtful" about this submission, and that you think that 
it needs "lot more review and testing". You dont offer any alternative, 
you dont offer any feedback, no review, no testing, no support, just a 
simple rejection on lkml that prevents this project from going upstream.

Yes, maintainers have veto power and often have to make hard decisions,
but, and let me stress this properly:

   Only if they actually act as honest maintainers!

Altogether 197 emails on lkml discussed these patches, and you were 
Cc:-ed to every one of them. Over a dozen kernel developers reviewed it 
or reacted to the patchset in one way or another. And your only reaction 
to this is silence and a rejection claiming that it needs "lot more 
review"? I'm utterly speechless.

	Ingo

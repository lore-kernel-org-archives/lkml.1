Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYGaQrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYGaQrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYGaQrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:47:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49589 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbYGaQra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:47:30 -0400
Date: Thu, 31 Jul 2008 18:46:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Clemens Ladisch <clemens@ladisch.de>, lkml <linux-kernel@vger.kernel.org>,
       bob.picco@hp.com, venkatesh.pallipadi@intel.com,
       Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch 2.6.27-rc1] /dev/hpet - fixes and cleanup
Message-ID: <20080731164658.GG26393@elte.hu>
References: <200807221508.56672.david-b@pacbell.net> <200807280127.22060.david-b@pacbell.net> <488D8D16.7010502@ladisch.de> <200807291247.38869.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807291247.38869.david-b@pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Minor /dev/hpet updates and bugfixes:
> 
>   * Remove dead code, mostly remnants of an incomplete/unusable
>     kernel interface ... noted when addressing "sparse" warnings:
>       + hpet_unregister() and a routine it calls
>       + hpet_task and all references, including hpet_task_lock
>       + hpet_data.hd_flags (and HPET_DATA_PLATFORM)
> 
>   * Correct and improve boot message:
>       + displays *counter* (shared between comparators) bit width,
>         not *timer* bit widths (which are often mixed)
>       + relabel "timers" as "comparators"; this is less confusing,
>         they are not independent like normal timers are (sigh)
>       + display MHz not Hz; it's never less than 10 MHz.
> 
>   * Tighten and correct the userspace interface code
>       + don't accidentally program comparators in 64-bit mode using
>         32-bit values ... always force comparators into 32-bit mode
>       + provide the correct bit definition flagging comparators with
>         periodic capability ... the ABI is unchanged
> 
>   * Update Documentation/hpet.txt
>       + be more correct and current
>       + expand description a bit
>       + don't mention that now-gone kernel interface
> 
> Plus, add a FIXME comment for something that could cause big trouble
> on systems with more capable HPETs than at least Intel seems to ship. 
> 
> It seems that few folk use this userspace interface; it's not very
> usable given the general lack of HPET IRQ routing.  I'm told that
> the only real point of it any more is to mmap for fast timestamps;
> IMO that's handled better through the gettimeofday() vsyscall.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> I CC'd everyone who MAINTAINERS says maintains HPET.  Odd to have
> four entries!!
> 
> And re that kernel interface ... IMO, worth having a relatively 
> generic interface for hardware timers instead of inventing a new 
> interface for each new bit of hardware.  Embedded systems tend to have 
> at least half a dozen timers to spare.

i've asked Clemens of how to merge this and we'll do it via 
tip/timers/hpet - so i queued it up there with the ACK of Clemens.

I also merged it up to latest -git. (the documentation bits already 
moved, etc.)

I suspect this is a 2.6.27 change, given its fix nature, but it will 
need some cooking in linux-next (via auto-timers-next) before this can 
be sent to Linus.

	Ingo

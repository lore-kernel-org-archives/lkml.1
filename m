Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYHRVMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYHRVMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYHRVMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:12:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47459 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbYHRVMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:12:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: oprofile + hibernation = badness
Date: Mon, 18 Aug 2008 23:15:59 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Pavel Machek" <pavel@suse.cz>, "Robert Richter" <robert.richter@amd.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@linux.intel.com>,
       "Philippe Elie" <phil.el@wanadoo.fr>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com> <200808182251.31113.rjw@sisk.pl> <19f34abd0808181408q8a38fc0hfaff02fab6e20681@mail.gmail.com>
In-Reply-To: <19f34abd0808181408q8a38fc0hfaff02fab6e20681@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808182316.00854.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of August 2008, Vegard Nossum wrote:
> On Mon, Aug 18, 2008 at 10:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Apparently nmi_suspend() conflicts with oprofile somehow.  Also, the offlining
> > of non-boot CPUs may confuse it.  It would be helpful to check if the CPU
> > hotplug works with oprofile.
> 
> That is a good suggestion :-)
> 
> Here is offlining:
> 
> CPU 1 is now offline
> lockdep: fixing up alternatives.
> SMP alternatives: switching to UP code
> CPU0 attaching NULL sched-domain.
> WQ on CPU0, prefer CPU1
> CPU1 attaching NULL sched-domain.
> CPU0 attaching sched-domain:
>  domain 0: span 0 level CPU
>   groups: 0
> WQ on CPU0, prefer CPU1
> WQ on CPU0, prefer CPU1
> WQ on CPU0, prefer CPU1
> [repeat last message indefinitely]
> 
> Here is onlining:
> 
> Booting processor 1/1 ip 6000
> Initializing CPU#1
> WQ on CPU0, prefer CPU1
> WQ on CPU0, prefer CPU1
> Calibrating delay using timer specific routine.. 5986.15 BogoMIPS (lpj=29930790)
> CPU: Trace cache: 12K uops, L1 D cache: 16K
> CPU: L2 cache: 2048K
> CPU: Physical Processor ID: 0
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#1.
> CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
> CPU1: Thermal monitoring enabled
> x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 05
> checking TSC synchronization [CPU#0 -> CPU#1]:
> Measured 120 cycles TSC warp between CPUs, turning off TSC clock.
> Marking TSC unstable due to check_tsc_sync_source failed
> APIC error on CPU1: 00(40)
> Clockevents: could not switch to one-shot mode:<7>APIC error on CPU1: 40(40)
>  lapic is not functional.
> Could not switch to high resolution mode on CPU 0
> Clockevents: could not switch to one-shot mode: lapic is not functional.
> Could not switch to high resolution mode on CPU 1
> APIC error on CPU1: 40(40)
> [sched domains messages
> WQ on CPU0, prefer CPU1
> APIC error on CPU1: 40(40)
> [repeat last message 9 times]
> 
> Then follows this pattern indefinitely:
> 
> WQ on CPU0, prefer CPU1
> APIC error on CPU1: 40(40)
> [repeat last message 9 times]
> 
> That's basically the same thing as I saw with suspend. So it can be
> reproduced easily with CPU hotplug.

Well, I don't know who's the right person to ask about the CPU hotplug.
Andrew, can you help please?

Rafael

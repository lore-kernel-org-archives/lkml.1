Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbYHRVI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbYHRVI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYHRVIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:08:47 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:21197 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYHRVIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=p2i+Huj582tGxnPVFPi1Kjuxe15p+q5IuG5aiNtDkAFDSTouzhf5wDu/IdZglAi9JN
         KS35ES9RzoORDrHHCLQ+kMM0EBN50jM1+R/P0d8VPdkvF1B/gbbVP7pd0DzEB1ACVyHA
         cj0eoNovlJoHze5rcIU19zJY1VUtuNNZVbSWE=
Message-ID: <19f34abd0808181408q8a38fc0hfaff02fab6e20681@mail.gmail.com>
Date: Mon, 18 Aug 2008 23:08:45 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: oprofile + hibernation = badness
Cc: "Pavel Machek" <pavel@suse.cz>, "Robert Richter" <robert.richter@amd.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@linux.intel.com>,
       "Philippe Elie" <phil.el@wanadoo.fr>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200808182251.31113.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com>
	 <200808182251.31113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 10:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Apparently nmi_suspend() conflicts with oprofile somehow.  Also, the offlining
> of non-boot CPUs may confuse it.  It would be helpful to check if the CPU
> hotplug works with oprofile.

That is a good suggestion :-)

Here is offlining:

CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
WQ on CPU0, prefer CPU1
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0 level CPU
  groups: 0
WQ on CPU0, prefer CPU1
WQ on CPU0, prefer CPU1
WQ on CPU0, prefer CPU1
[repeat last message indefinitely]

Here is onlining:

Booting processor 1/1 ip 6000
Initializing CPU#1
WQ on CPU0, prefer CPU1
WQ on CPU0, prefer CPU1
Calibrating delay using timer specific routine.. 5986.15 BogoMIPS (lpj=29930790)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
CPU1: Thermal monitoring enabled
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 05
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 120 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed
APIC error on CPU1: 00(40)
Clockevents: could not switch to one-shot mode:<7>APIC error on CPU1: 40(40)
 lapic is not functional.
Could not switch to high resolution mode on CPU 0
Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 1
APIC error on CPU1: 40(40)
[sched domains messages
WQ on CPU0, prefer CPU1
APIC error on CPU1: 40(40)
[repeat last message 9 times]

Then follows this pattern indefinitely:

WQ on CPU0, prefer CPU1
APIC error on CPU1: 40(40)
[repeat last message 9 times]

That's basically the same thing as I saw with suspend. So it can be
reproduced easily with CPU hotplug.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

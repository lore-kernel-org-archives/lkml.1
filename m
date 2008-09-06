Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYIFMnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYIFMnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 08:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYIFMmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 08:42:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYIFMmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 08:42:52 -0400
Date: Sat, 6 Sep 2008 14:42:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: venkatesh.pallipadi@intel.com
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [RFC 0/4] Using HPET in MSI mode and setting up per CPU HPET
	timers
Message-ID: <20080906124234.GG30964@elte.hu>
References: <20080906010214.229910000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906010214.229910000@intel.com>
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


* venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> wrote:

> Patchset that uses HPET timers in MSI mode (when supported) and sets 
> up per CPU HPET timers. This removes the dependency on IRQ0 timer 
> broadcast with LAPIC stopping in deep C-state, on platforms that 
> support HPET MSI mode.
> 
> On my test system with dual core CPU, the number of timer related 
> interrupts (HPET_MSI + IRQ0 + LAPIC) comes down from 180 to 95 over a 
> period of 10s, with these patches. This is on an idle system with 
> tickless enabled and when system is idle.
> 
> Patches against tip.

cool stuff!

this is _really_ how a modern dynticks system should look like on x86 - 
proper per CPU hardware timers that are southbridge based.

There's a few routine checks this new has to pass: we've got to see how 
widely this works and whether there are any bugs/quirks to take care of, 
so i created a separate feature topic for it: tip/timers/hpet-percpu.

This tip/timers/hpet-percpu feature topic tree is based on irq/sparseirq 
+ timers/hpet + timers/urgent - which had some changes in the hpet area. 
I merged up the conflicts - please double check the result. I also did 
cleanups for a few style problems that were present in hpet.c.

I've merged it into tip/master as well and will run a few tests before 
pushing it out.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbXLSTdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbXLSTdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbXLSTdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:33:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44544 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbXLSTdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:33:16 -0500
Date: Wed, 19 Dec 2007 20:32:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
Message-ID: <20071219193255.GA2158@elte.hu>
References: <20071219183443.GA547@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219183443.GA547@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Aviod TLB flush IPIs during C3 states by voluntary leave_mm() before 
> entering C3.
> 
> The performance impact of TLB flush on C3 should not be significant 
> with respect to C3 wakeup latency. Also, CPUs tend to flush TLB in 
> hardware while in C3 anyways.
> 
> On a 8 logical CPU system, running make -j2, the number of tlbflush 
> IPIs goes down from 40 per second to ~ 0. Total number of interrupts 
> during the run of this workload was ~1200 per second, which makes it 
> ~3% savings in wakeups.
> 
> There was no measurable performance or power impact however.

thanks, applied to x86.git. Nice and elegant patch!

Btw., since the TLB flush state machine is really subtle and fragile, 
could you try to run the following mmap stresstest i wrote some time 
ago:

   http://redhat.com/~mingo/threaded-mmap-stresstest/

for a couple of hours. It runs nr_cpus threads which then do a "random 
crazy mix" of mappings/unmappings/remappings of a 800 MB memory window. 
The more sockets/cores, the crazier the TLB races get ;-)

	Ingo

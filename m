Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbXLHTmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbXLHTmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbXLHTmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:42:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXLHTmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:42:38 -0500
Date: Sat, 8 Dec 2007 20:42:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Message-ID: <20071208194211.GA579@elte.hu>
References: <82e4877d0712071453h38795e36of26324a4b123fa6c@mail.gmail.com> <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com> <alpine.LFD.0.99999.0712080821220.3070@localhost.localdomain> <82e4877d0712080710g205ba93ag12ee204b15d70fdb@mail.gmail.com> <82e4877d0712080736v12c1e31at9149655ae000fe50@mail.gmail.com> <20071208154755.GA5255@elte.hu> <82e4877d0712080800j6572734ek78a76cf7bb17a7e0@mail.gmail.com> <20071208191330.GA21186@elte.hu> <82e4877d0712081133y49fec9bfyee30a3010b37c435@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0712081133y49fec9bfyee30a3010b37c435@mail.gmail.com>
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


* Parag Warudkar <parag.warudkar@gmail.com> wrote:

> Even on 100% idle I get variations that are approx in the same range 
> when not idle. Clocksource is hpet if that matters.  Next I think I 
> will disable CPU_IDLE, Tickless

also try the hpet=disable boot option.

> My ssh connection just died - another lockup in dmesg -
> 
> BUG: soft lockup - CPU#1 stuck for 14s! [sshd:509]

this would suggest that the softlockup watchdog is correct and indeed 
there was some lockup of sorts?

> $> while :; do time usleep 1111111; done
> real    0m1.112s
> real    0m1.385s
> real    0m1.112s
> real    0m1.112s
> real    0m1.279s

this, if done on an idle system, looks anomalous to me. Does 
hpet=disable help?

	Ingo

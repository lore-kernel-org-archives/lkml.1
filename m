Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbXD2Qmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbXD2Qmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXD2Qmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:42:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48226 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbXD2Qmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:42:40 -0400
Date: Sun, 29 Apr 2007 18:42:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Lee Revell <rlrevell@joe-job.com>, tglx@linutronix.de,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: High Resolution Timer DOS
Message-ID: <20070429164230.GA23337@elte.hu>
References: <4633C269.9050806@free.fr> <1177798389.7646.320.camel@localhost.localdomain> <75b66ecd0704281537s54134967ybc3ddef0b87b6bf5@mail.gmail.com> <20070429071743.GA4532@elte.hu> <4634C2F0.8050101@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4634C2F0.8050101@free.fr>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* matthieu castet <castet.matthieu@free.fr> wrote:

> Ok, may be DOS was not the correct term, [...]

ok, good that have that issue put aside ;-)

> [...] but with the 2.6.21 hrt there is a great difference between an 
> infinite loop and the high-rate context-switching task (you can try 
> attached programs). With the first I the system is still responsive, 
> with the latter it isn't (new process take lot's of time to get 
> created, other process are very slow). If it is "just 'CPU time used 
> up'", why I see a such difference between the 2 cases ?

this is a pure scheduler thing: the scheduler treats sleepers 
differently than CPU hogs. Try the same test for example under the 
(ob'plug) CFS scheduler:

   http://redhat.com/~mingo/cfs-scheduler/

and you'll see small_sleep.c being handled the same way as 
infinite_loop.c. This is a CFS box with 20 small_sleep's running:

 top - 20:41:02 up 1 min,  2 users,  load average: 4.92, 1.27, 0.43
 Tasks:  89 total,  22 running,  67 sleeping,   0 stopped,   0 zombie
 Cpu(s):  5.2%us, 46.5%sy,  1.7%ni, 17.7%id, 28.5%wa,  0.3%hi,  0.1%si,  0.0%st
 Mem:   2053204k total,   103300k used,  1949904k free,    12096k buffers
 Swap:  4096564k total,        0k used,  4096564k free,    43040k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  2208 mingo     20   0  1576  256  208 R  4.5  0.0   0:01.08 small_sleep
  2252 mingo     20   0  1580  260  208 R  4.5  0.0   0:00.71 small_sleep
  2254 mingo     20   0  1576  256  208 R  4.5  0.0   0:00.61 small_sleep

and the system is still completely usable.

This isnt really about timers - you can achieve similar effects without 
using any timers.

	Ingo

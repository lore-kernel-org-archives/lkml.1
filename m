Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYI2Izh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYI2Izh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYI2Iz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:55:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60157 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbYI2Iz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:55:29 -0400
Date: Mon, 29 Sep 2008 10:55:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck fixlets (for -tip)
Message-ID: <20080929085512.GA2190@elte.hu>
References: <20080928180652.GA8500@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080928180652.GA8500@localhost.localdomain>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi Ingo,
> 
> Here is the fixlets branch, including bitfields API. I think it would 
> be very nice if you could make this a *separate* branch in -tip, say 
> kmemcheck-fixlets or so, as it may touch any part of the kernel and 
> doesn't carry the acks of those maintainers.
> 
> With these patches, you should be able to include kmemcheck in 
> auto-testing again. At least it works for me :-)

FYI, i've reactivated kmemcheck on one of the -tip auto-test boxes 
earlier today and it's looking good so far - for example a 32-bit 
allyesconfig-ish config booted in just fine with kmemcheck enabled. 
Also, the box is very usable interactively - while previous one could 
always tell whether there's kmemcheck active.

[ only one CPU is active, but we knew that. We've still got this 
  test-commit:

     21d01a4: x86: add functions for duplicating page tables

  it's not in tip/master but we still have it around. ]

btw., is there any easy way to tell from within a script what the 
current status of kmemcheck is? In particular, whether it's running. 
Normally i have this in the syslog:

 [    0.448022] kmemcheck: "Bugs, beware!"
 [    0.452002] kmemcheck: Limiting number of CPUs to 1.

but this time the log was too large so this bit was snipped out and i 
was unsure about it - needed a second bootup with a larger buffer to 
make sure. With lockdep we've got the 'debug_locks' /proc/lockdep_stats.

also, all kmemcheck warnings follow the usual WARN_ON() format, so that 
automated tests can pick it up, correct? -tip testing does so many 
bootups that there's no chance to notice non-system-crashing bugs and 
printouts but via automated means.

	Ingo

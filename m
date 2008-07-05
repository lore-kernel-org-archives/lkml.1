Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbYGEGjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbYGEGjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 02:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYGEGjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 02:39:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50668 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYGEGjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 02:39:41 -0400
Date: Sat, 5 Jul 2008 08:39:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Oops/Warning report of the week of July 4th 2008
Message-ID: <20080705063917.GA11599@elte.hu>
References: <486EA0D6.2040504@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486EA0D6.2040504@linux.intel.com>
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> Rank 8: tick_broadcast_oneshot_control (softlockup)
> 	Reported 91 times (634 total reports)
>
> 	Some interaction between tickless and systems with an AMD CPU 
> 	and an ATI chipset (eg only seen on systems that both have an 
> 	AMD cpu and an ATI chipset) Current suspicion is some kind of 
> 	time-warp problem that causes the softlockup code to trigger 
> 	incorrectly
>
>       This softlockup was last seen in version 2.6.25.9,
> 	and first seen in 2.6.24-rc4. More info:
>
> 	http://www.kerneloops.org/searchweek.php?search=tick_broadcast_oneshot_control

ok, so it's a false positive due to bad timer readout, not a real 
lockup. That probably also explains how it was able to show up in such 
numbers - the system kept functioning just fine so every system that 
produced this warning was able to report it to kerneloops.org.

i'll think about extending the softlockup code with time warp detection 
and reporting - that would be a useful facility in itself as right now 
there's nothing that warns about time warps in monotonic system time.

	Ingo

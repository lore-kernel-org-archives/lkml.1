Return-Path: <linux-kernel-owner+w=401wt.eu-S965287AbXDPIr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbXDPIr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 04:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXDPIr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 04:47:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49739 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965287AbXDPIr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 04:47:57 -0400
Date: Mon, 16 Apr 2007 10:47:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: surya.prabhakar@wipro.com, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, npiggin@suse.de, efault@gmx.de,
       arjan@infradead.org, tglx@linutronix.de, wli@holomorphy.com
Subject: Re: [TEST RESULT]massive_intr.c -- cfs/vanilla/sd-0.40
Message-ID: <20070416084724.GA10912@elte.hu>
References: <1176540546.2702.15.camel@bluegenie> <20070414120220.GA2346@elte.hu> <877iscsp1x.wl%takeuchi_satoru@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877iscsp1x.wl%takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:

> > btw., other schedulers might work better with some more test-time: 
> > i'd suggest to use 60 seconds (./massive_intr 10 60) [or maybe more, 
> > using more threads] to see long-term fairness effects.
> 
> I tested CFS with massive_intr. I did long term, many CPUs, and many 
> processes cases.
> 
> Test environment
> ================
> 
>  - kernel:         2.6.21-rc6-CFS
>  - run time:       300 secs
>  - # of CPU:       1 or 4
>  - # of processes: 200 or 800
> 
> Result
> ======
> 
>   +---------+-----------+-------+------+------+--------+
>   |   # of  |   # of    | avg   | max  | min  |  stdev |
>   |   CPUs  | processes | (*1)  | (*2) | (*3) |  (*4)  |
>   +---------+-----------+-------+------+------+--------+
>   | 1(i386) |           | 117.9 |  123 |  115 |    1.2 |
>   +---------|       200 +-------+------+------+--------+
>   |         |           | 750.2 |  767 |  735 |   10.6 |
>   | 4(ia64) +-----------+-------+------+------+--------+
>   |         |   800(*5) | 187.3 |  189 |  186 |    0.8 |
>   +---------+-----------+-------+------+------+--------+
> 
>   *1) average number of loops among all processes
>   *2) maximum number of loops among all processes
>   *3) minimum number of loops among all processes
>   *4) standard deviation
>   *5) Its # of processes per CPU is equal to first test case.
> 
> Pretty good! CFS seems to be fair in any situation.

thanks for testing this! Indeed the min-max values and standard 
deviation look all pretty healthy. (They in fact seem to be better than 
the other patch of mine against upstream that you tested, correct?)

[ And there's also another nice little detail in your feedback: CFS
  actually builds, boots and works fine on ia64 too ;-) ]

	Ingo

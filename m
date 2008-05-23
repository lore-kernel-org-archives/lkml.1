Return-Path: <linux-kernel-owner+w=401wt.eu-S1764911AbYEWBmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764911AbYEWBmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762891AbYEWBmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:42:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760719AbYEWBmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:42:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it is queued
In-Reply-To: Oleg Nesterov's message of  Friday, 23 May 2008 01:18:09 +0400 <20080522211809.GA451@tv-sign.ru>
References: <20080517151420.GA9496@tv-sign.ru>
	<20080521022046.1501F26FA1C@magilla.localdomain>
	<20080521115414.GA147@tv-sign.ru>
	<20080521184245.5BABF26FA24@magilla.localdomain>
	<alpine.LFD.1.10.0805211146350.3081@woody.linux-foundation.org>
	<20080521193348.64E8C26FA24@magilla.localdomain>
	<alpine.LFD.1.10.0805211245131.3081@woody.linux-foundation.org>
	<20080521230135.BF65A26FA24@magilla.localdomain>
	<20080522111211.GA117@tv-sign.ru>
	<20080522215057.DCDF326FA24@magilla.localdomain>
	<20080522211809.GA451@tv-sign.ru>
X-Zippy-Says: Do you guys know we just passed thru a BLACK HOLE in space?
Message-Id: <20080523014135.BDD2526FA24@magilla.localdomain>
Date: Thu, 22 May 2008 18:41:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So. Let's suppose that (say) SIGHUP is pending, and the posix timer
> sends SIGHUP too. In that case the new SIGHUP is added, and if the
> previous one was infoless the new one "hides" it: collect_signal()
> won't see 2 distinct signals, it will find only 1 signal and clear
> the bit in sigpending->signal.

That is correct behavior.  Signals < SIGRTMIN do not queue.  (POSIX says
it's implementation-defined whether they do, and in Linux they don't.)
When a signal does not queue, it's unspecified whether the the one that
is ever actually seen is the first one or the last one (or any in between),
so the siginfo_t details showing the second one in your example is fine.


Thanks,
Roland

Return-Path: <linux-kernel-owner+w=401wt.eu-S937079AbXGSFuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937079AbXGSFuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 01:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXGSFu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 01:50:28 -0400
Received: from www.osadl.org ([213.239.205.134]:58877 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755216AbXGSFu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 01:50:27 -0400
Subject: Re: [PATCH] posix-timer: fix deletion race
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Katz <jeremy.katz@windriver.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
In-Reply-To: <Pine.LNX.4.63.0707181631450.3157@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
	 <1184662429.12353.426.camel@chaos>
	 <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
	 <1184703427.12353.476.camel@chaos>
	 <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
	 <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain>
	 <1184738755.12353.481.camel@chaos> <1184741938.12353.484.camel@chaos>
	 <Pine.LNX.4.63.0707181159010.3157@localhost.localdomain>
	 <Pine.LNX.4.63.0707181631450.3157@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 07:50:21 +0200
Message-Id: <1184824221.12353.526.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 16:43 -0700, Jeremy Katz wrote:
> On Wed, 18 Jul 2007, Jeremy Katz wrote:
> 
> > On Wed, 18 Jul 2007, Thomas Gleixner wrote:
> >
> >>> Also can you please enable CONFIG_PROVE_LOCKING, which might catch any
> >>> locking problem, which might be related to this.
> >> 
> >> Another test: Can you please disable CONFIG_SCHED_SMT to narrow it down
> >> further ?
> >
> > I'll try both of these.
> 
> I'm still seeing the sys_timer_delete version with your patch, and 
> sys_timer_delete and posix_timer_event without. The itimer_delete version 
> is currently missing in action, but getting any particular one to perform 
> on demand is currently not in my power.

Ok, let me summarize:

2.6.22 + hrt6

Both problems are there whether CONFIG_SCHED_SMT is on or not

2.6.22 + hrt6 + posixtimer patch

Both problems are there whether CONFIG_SCHED_SMT is on
The timer callback problem is gone when CONFIG_SCHED_SMT is off

Correct ?

	tglx



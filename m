Return-Path: <linux-kernel-owner+w=401wt.eu-S934658AbXEMQpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934658AbXEMQpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759242AbXEMQpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:45:00 -0400
Received: from www.osadl.org ([213.239.205.134]:43257 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759104AbXEMQo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:44:58 -0400
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <1179043652.22481.243.camel@localhost.localdomain>
References: <20070430102837.748238000@linutronix.de>
	 <20070511132846.5ebf4437.akpm@linux-foundation.org>
	 <200705112302.47726.rjw@sisk.pl> <200705112309.15996.rjw@sisk.pl>
	 <20070511235607.83ad0eb5.akpm@linux-foundation.org>
	 <1178959563.22481.126.camel@localhost.localdomain>
	 <20070512020056.a24cf472.akpm@linux-foundation.org>
	 <1178961489.22481.133.camel@localhost.localdomain>
	 <20070512030754.90488f79.akpm@linux-foundation.org>
	 <1178970253.22481.143.camel@localhost.localdomain>
	 <20070512095145.0cf58a57.akpm@linux-foundation.org>
	 <1178989302.22481.185.camel@localhost.localdomain>
	 <20070512102350.04126320.akpm@linux-foundation.org>
	 <1178999770.22481.211.camel@localhost.localdomain>
	 <20070512181140.50140334.akpm@linux-foundation.org>
	 <1179043652.22481.243.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 13 May 2007 18:48:07 +0200
Message-Id: <1179074887.22481.271.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 10:07 +0200, Thomas Gleixner wrote:
> > > Can you send me your .config please ?
> > > 
> > 
> > http://userweb.kernel.org/~akpm/config-sony.txt
> 
> No luck. 

I'm making progress. After fiddling with the config options I get a
solid lockup of netconsole during boot :(

But also lockdep itself is broken on my box, so I would not see warnings
anyway:

     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |irq event stamp: 472
hardirqs last  enabled at (472): [<c01e8bba>] irqsafe2A_rlock_12+0x94/0xa1
hardirqs last disabled at (471): [<c0109541>] native_sched_clock+0x55/0xe8
softirqs last  enabled at (468): [<c01e8ba5>] irqsafe2A_rlock_12+0x7f/0xa1
softirqs last disabled at (464): [<c01e8b31>] irqsafe2A_rlock_12+0xb/0xa1
FAILED| [<c0104d21>] dump_trace+0x61/0x1e7
 [<c0104ec1>] show_trace_log_lvl+0x1a/0x30
 [<c0105a1b>] show_trace+0x12/0x14
 [<c0105a73>] dump_stack+0x15/0x17
 [<c01e6971>] dotest+0x6b/0x3ce
 [<c01efc1f>] locking_selftest+0x915/0x1a5a
 [<c04a0a0a>] start_kernel+0x1d5/0x2a7
 =======================

.... more of those

-----------------------------------------------------------------
BUG:   6 unexpected failures (out of 218) - debugging disabled! |
-----------------------------------------------------------------

	tglx



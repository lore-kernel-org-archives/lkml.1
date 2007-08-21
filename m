Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbXHUJsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbXHUJsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbXHUJsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:48:22 -0400
Received: from ozlabs.org ([203.10.76.45]:59603 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbXHUJsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:48:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18122.46304.556919.568565@cargo.ozlabs.ibm.com>
Date: Tue, 21 Aug 2007 19:48:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com
Subject: Re: [accounting regression since rc1]  scheduler updates
In-Reply-To: <20070821093434.GB12025@elte.hu>
References: <20070812163225.GA11996@elte.hu>
	<200708141037.48001.borntraeger@de.ibm.com>
	<20070820154529.GA300@elte.hu>
	<200708211017.02998.borntraeger@de.ibm.com>
	<20070821084243.GB1144@elte.hu>
	<1187687476.7623.8.camel@localhost>
	<20070821093434.GB12025@elte.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> my feeling is that it gives us generally higher-quality scheduling if we 
> drive all things scheduler via virtual time. Do you agree with that?

On PowerPC at least, while we can measure virtual time, there is no
hardware facility for getting an interrupt after a certain amount of
virtual time has elapsed, but there is a facility to get an interrupt
after an elapsed real-time interval.  So sched_clock() could easily
change to measure virtual time, but I don't see how to make
scheduler_tick() be driven off virtual time.  It sounds like s390 is
the same.

> it seems you'd like accounting to be sensitive to 'external load' - i.e. 
> you'd like an 'internal' top to show the 'real' CPU accounting, right? 
> 
> Wouldnt it be more consistent if a virtual box would not show any 
> dependency on external load? (i.e. it would slow down all of its 
> internal functionality transparently, without exposing it via /proc. The 

The tools that use the data in /proc get unhappy if user time + system
time + hardirq time + softirq time + idle time + stolen time doesn't
add up to real time.  The way we handle that is by making stolen time
represent the time taken away by the hypervisor (and on PowerPC with
SMT, the time taken by the other thread too).

Paul.

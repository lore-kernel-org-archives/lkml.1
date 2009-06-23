Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbZFWVmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbZFWVmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZFWVl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:41:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48331 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZFWVl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:41:58 -0400
Subject: Re: [GIT pull] ntp updates for 2.6.31
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Miroslav Lichvar <mlichvar@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20090623133625.GA3026@elte.hu>
References: <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com>
	 <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com>
	 <20090616090647.GD13771@elte.hu> <20090616125248.GA23541@localhost>
	 <1245253102.6067.94.camel@jstultz-laptop>
	 <20090617172325.GA32332@localhost> <20090617172601.GA3493@elte.hu>
	 <20090618121320.GA13025@localhost> <20090623095745.GC30634@elte.hu>
	 <20090623131628.GA11827@localhost>  <20090623133625.GA3026@elte.hu>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 14:41:56 -0700
Message-Id: <1245793316.3305.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 15:36 +0200, Ingo Molnar wrote:
> The PPS patches i've seen just export IRQ timestamps to user-space.
> 
> That is not very robust in my opinion when it comes to do time 
> approximations - to get quick, low-latency action and precise 
> measurements it's best to keep the critical path as short as 
> possible, and within a single source code repository: i.e. within 
> the kernel.
> 
> There's little policy really, other than setting some general 
> parameters. NTPd can still provide the raw _network time_ 
> timestamps, as that is probably best fetched by user-space and fed 
> to the kernel.

At some point that stops being NTP. NTP has quite a bit of userland
policy for filtering and managing a number of different network clocks
(other ntp servers, PPS sources, etc).

>From what you're describing (direct offset from a hardware time device
used to steer the clock directly in kernel), you might want to look at
the STP code in s390 (stp_sync_clock).

thanks
-john


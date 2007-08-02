Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbXHBPm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbXHBPm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbXHBPmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:42:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50462 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbXHBPmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:42:49 -0400
Date: Thu, 2 Aug 2007 17:42:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: SD still better than CFS for 3d   ?(was Re: 2.6.23-rc1)
Message-ID: <20070802154228.GA12371@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <1185839164.27166.7.camel@localhost> <1185863461.3092.4.camel@twins> <20070731085713.GA15136@elte.hu> <1186011827.2482.1.camel@localhost> <20070802121018.GA11900@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802121018.GA11900@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Kasper,

could you please try the "chew-max" latency-printing utility:

   http://people.redhat.com/mingo/cfs-scheduler/tools/chew-max.c

if you start it on an idle system it prints a single line:

  $ ./chew-max
  pid 14506, prio   0, interval of 99984800 nsec

and prints nothing else. It continues looping and looping (using up 100% 
of CPU time), and the moment it's preempted, it prints a line about that 
preemption latency. Under higher load it will print something like this:

  out for   63 ms [max:   66], ran for    5 ms, load   7
  out for   85 ms [max:   85], ran for    4 ms, load   5
  out for    7 ms [max:   85], ran for    0 ms, load   0
  out for  105 ms [max:  105], ran for    3 ms, load   3
  out for  174 ms [max:  174], ran for    6 ms, load   3
  out for  219 ms [max:  219], ran for    3 ms, load   1
  out for   78 ms [max:  219], ran for    3 ms, load   3

so that we get a picture of your latencies, could you run this tool why 
you are seeing those 'bad' desktop latencies? (Since your CPU has two 
cores it might make sense to run two instances of chew-max.)

record the latencies like this:

  ./chew-max > chew1.out &
  ./chew-max > chew2.out &

and send us the chew1.out and chew2.out files (bzip2 -9 compressed). 
Thanks!

	Ingo

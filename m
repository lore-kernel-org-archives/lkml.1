Return-Path: <linux-kernel-owner+w=401wt.eu-S1765614AbXF1WAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765614AbXF1WAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761387AbXF1WAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:00:38 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:60941 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760915AbXF1WAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:00:37 -0400
Date: Thu, 28 Jun 2007 18:00:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dan Williams <dan.j.williams@intel.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
In-Reply-To: <e9c3a7c20706281423p27059e90qe7f986d7485753a7@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0706281758560.27847@gandalf.stny.rr.com>
References: <20070622040014.234651401@goodmis.org>  <20070622204058.GA11777@elte.hu>
  <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> 
 <20070622215953.GA22917@elte.hu>  <e9c3a7c20706251846v17347ab2n4a1d314734528c95@mail.gmail.com>
  <1182823276.5493.240.camel@localhost.localdomain> 
 <e9c3a7c20706251912i77ac75a0o60981590a08c34e6@mail.gmail.com> 
 <Pine.LNX.4.58.0706280823020.19012@gandalf.stny.rr.com> 
 <e9c3a7c20706281102l5db2e91alf465e7983d68f284@mail.gmail.com> 
 <Pine.LNX.4.58.0706281632510.27157@gandalf.stny.rr.com>
 <e9c3a7c20706281423p27059e90qe7f986d7485753a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 28 Jun 2007, Dan Williams wrote:

> > CONFIG_PREEMPT?
> >
> Everything thus far has been CONFIG_PREEMPT=n (the default for this platform).
>
> With CONFIG_PREEMPT=y the resync is back in the 50MB/s range.

So with upping the prio for the work queue you got back your performance?

>
> [iop-adma: hi-prio workqueue, CONFIG_PREEMPT=y]
> iq81340mc:~# cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid5 sdd[4] sdc[2] sdb[1] sda[0]
>       468872448 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>       [=>...................]  recovery =  5.8% (9136404/156290816)
> finish=46.1min speed=53161K/sec
>
> The tasklet configuration stays in 50MB/s ballpark, and the default
> priority (nice -5) workqueue case remains in the 30's with
> CONFIG_PREEMPT=n.

[noted: should be CONFIG_PREEMPT=y]

This is expected. Seems you may have otherthings running at a higher prio.

-- Steve


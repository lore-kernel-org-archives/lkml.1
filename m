Return-Path: <linux-kernel-owner+w=401wt.eu-S1759087AbXETVgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087AbXETVgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbXETVgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:36:47 -0400
Received: from www.osadl.org ([213.239.205.134]:54399 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756648AbXETVgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:36:46 -0400
Subject: Re: [BUG] local_softirq_pending storm
From: Thomas Gleixner <tglx@linutronix.de>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <200705200253.44992.kernel@prachanda.hub>
References: <200705091942.22920.kernel@prachanda.hub>
	 <200705191525.28400.kernel@prachanda.hub>
	 <1179601868.12981.127.camel@chaos>
	 <200705200253.44992.kernel@prachanda.hub>
Content-Type: text/plain
Date: Sun, 20 May 2007 23:43:08 +0200
Message-Id: <1179697388.6570.26.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-20 at 02:53 +0530, Anant Nitya wrote:
> > 1 == TASK_INTERRUPTIBLE, so we know that ksoftirqd was not woken up. At
> > least it is not a scheduler problem.
> >
> > I work out a more complex debug patch and pester you to test once I'm
> > done.
> No problem :)

You asked for it :)

Please patch 2.6.22-rc2 with

http://tglx.de/projects/hrtimers/2.6.22-rc2/patch-2.6.22-rc2-hrt2.patch
and
http://www.tglx.de/private/tglx/ht-debug/tracer.diff

Compile it with the config

http://www.tglx.de/private/tglx/ht-debug/config.debug

You should find something like:

(         swapper-0    |#0): new 67173 us user-latency.

along with the familiar "NOHZ ......" message in your log file.

Once that happened please do:

$ cat /proc/latency_trace >trace.txt

compress it and send it to me along with the full dmesg output or put
both up to some place, where I can download it.

Michal,

IIRC you encountered the same P4/HT related wreckage. Can you do the
same ?

Thanks,

	tglx



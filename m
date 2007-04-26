Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbXDZXCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbXDZXCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbXDZXCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:02:40 -0400
Received: from mail33.syd.optusnet.com.au ([211.29.132.104]:53347 "EHLO
	mail33.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643AbXDZXCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:02:38 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: [REPORT] cfs-v6-rc2 vs sd-0.46 vs 2.6.21-rc7
Date: Fri, 27 Apr 2007 08:59:36 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Michael Gerdau <mgd@technosis.de>,
       Nick Piggin <npiggin@suse.de>, Bill Davidsen <davidsen@tmr.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Gene Heskett <gene.heskett@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <200704261312.25571.mgd@technosis.de> <20070426120723.GA4092@elte.hu>
In-Reply-To: <20070426120723.GA4092@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704270859.37931.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007 22:07, Ingo Molnar wrote:
> * Michael Gerdau <mgd@technosis.de> wrote:
> > Hi list,
> >
> > find below a test comparing
> >     2.6.21-rc7 (mainline)
> >     2.6.21-rc7-sd046
> >     2.6.21-rc7-cfs-v6-rc2(*) (X @ nice 0)
> >     2.6.21-rc7-cfs-v6-rc2(*) (X @ nice -10)
> > running on a dualcore x86_64.
>
> thanks for the testing!

Very interesting indeed but fairly complicated as well.

> as a summary: i think your numbers demonstrate it nicely that the
> shorter 'timeslice length' that both CFS and SD utilizes does not have a
> measurable negative impact on your workload. To measure the total impact
> of 'timeslicing' you might want to try the exact same workload with a
> much higher 'timeslice length' of say 400 msecs, via:
>
>     echo 400000000 > /proc/sys/kernel/sched_granularity_ns  # on CFS
>     echo 400 > /proc/sys/kernel/rr_interval                 # on SD

I thought that the effective "timeslice" on CFS was double the 
sched_granularity_ns so wouldn't this make the effective timeslice double 
that of what you're setting SD to? Anyway the difference between 400 and 
800ms timeslices is unlikely to be significant so I don't mind.

-- 
-ck

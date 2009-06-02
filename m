Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbZFBLtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbZFBLtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759784AbZFBLt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:49:28 -0400
Received: from fifo99.com ([67.223.236.141]:60524 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759575AbZFBLt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:49:27 -0400
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
From: Daniel Walker <dwalker@fifo99.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090602075409.GA19294@linux-sh.org>
References: <20090602071718.GA17710@linux-sh.org>
	 <1243927502.23657.5619.camel@twins> <20090602073515.GB17710@linux-sh.org>
	 <1243928495.23657.5642.camel@twins>  <20090602075409.GA19294@linux-sh.org>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 04:49:26 -0700
Message-Id: <1243943366.6592.434.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 16:54 +0900, Paul Mundt wrote:
>  unsigned long long __attribute__((weak)) sched_clock(void)
>  {
> -       return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> -                                       * (NSEC_PER_SEC / HZ);
> +       unsigned long long time;
> +       struct clocksource *clock;
> +
> +       rcu_read_lock();
> +       clock = rcu_dereference(sched_clocksource);
> +       time = cyc2ns(clock, clocksource_read(clock));
> +       rcu_read_unlock();
> +
> +       return time;
>  }

My concerns with the locking here still stand. Nothing you've said or
done bolsters the clocksource in modules argument. I think what your
planning for sh clocksources seems very inelegant. I would imagine a
better solution is out there. I'd prefer if you just leave sched_clock
alone.

Daniel


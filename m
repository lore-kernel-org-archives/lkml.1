Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab0BVJFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 04:05:01 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:56209 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0BVJE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 04:04:59 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <2375c9f91002220034m1beec51co7385a1cdbbcce7d2@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
	 <1266749023.5468.1.camel@jlt3.sipsolutions.net>
	 <7b6bb4a51002210255t5ceaeb84r1438461085446385@mail.gmail.com>
	 <7b6bb4a51002210312o2a1d070aneb54c107aeab6952@mail.gmail.com>
	 <1266750881.10419.1.camel@jlt3.sipsolutions.net>
	 <1266751349.10419.2.camel@jlt3.sipsolutions.net>
	 <2375c9f91002220034m1beec51co7385a1cdbbcce7d2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 10:04:50 +0100
Message-ID: <1266829490.5609.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 16:34 +0800, Américo Wang wrote:
> On Sun, Feb 21, 2010 at 7:22 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2010-02-21 at 12:14 +0100, Johannes Berg wrote:
> >
> >>         printk("got cpu\n");
> >>         for_each_online_cpu(i) {
> >>                 sm_work = per_cpu_ptr(stop_machine_work,
> i);
> >>                 INIT_WORK(sm_work, stop_cpu);
> >>                 queue_work_on(i, stop_machine_wq, sm_work);
> >>         }
> >>         /* This will release the thread on our CPU. */
> >>         put_cpu();
> >>         printk("put cpu\n");
> >
> > As odd as that may be, it hangs in put_cpu() here.
> >
> 
> Hmm, does adding synchronize_sched() in _cpu_down() help?

No luck.

johannes


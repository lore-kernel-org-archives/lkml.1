Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab0BULWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 06:22:47 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:55111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0BULWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 06:22:45 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1266750881.10419.1.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
	 <1266749023.5468.1.camel@jlt3.sipsolutions.net>
	 <7b6bb4a51002210255t5ceaeb84r1438461085446385@mail.gmail.com>
	 <7b6bb4a51002210312o2a1d070aneb54c107aeab6952@mail.gmail.com>
	 <1266750881.10419.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Feb 2010 12:22:29 +0100
Message-ID: <1266751349.10419.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-21 at 12:14 +0100, Johannes Berg wrote:

>         printk("got cpu\n");
>         for_each_online_cpu(i) {
>                 sm_work = per_cpu_ptr(stop_machine_work, i);
>                 INIT_WORK(sm_work, stop_cpu);
>                 queue_work_on(i, stop_machine_wq, sm_work);
>         }
>         /* This will release the thread on our CPU. */
>         put_cpu();
>         printk("put cpu\n");

As odd as that may be, it hangs in put_cpu() here.

johannes


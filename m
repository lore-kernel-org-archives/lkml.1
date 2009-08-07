Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZHGK4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZHGK4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbZHGK4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:56:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54129 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233AbZHGK4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:56:37 -0400
Date: Fri, 7 Aug 2009 12:56:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] ftrace: add tracepoint for timer
Message-ID: <20090807105616.GA24916@elte.hu>
References: <4A7A4153.3040207@cn.fujitsu.com> <20090806024804.GB4685@kryten> <4A7A4C45.3040008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7A4C45.3040008@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> Anton Blanchard wrote:
> > Hi,
> > 
> >> Example ftrace output:
> >>   insmod-1712  [000]   145.901459: timer_init: timer=d0ace4b4
> >>   insmod-1712  [000]   145.901469: timer_start: timer=d0ace4b4 func=timer_fun expires=4294813629 timeout=199
> >>   <idle>-0     [000]   146.100230: timer_cancel: timer=d0ace4b4
> >>   <idle>-0     [000]   146.100233: timer_expire: timer=d0ace4b4 jiffies=4294813629
> >>   <idle>-0     [000]   146.100627: timer_callback_done: func=d0ace4b4
> > 
> > Sorry I haven't followed the thread, but I was wondering why you 
> > changed the name of the entry and exit tracepoints (ie 
> > timer_entry/timer_exit).
> > 
> > I think consistent naming is important to match the other static 
> > tracepoints, such as softirq_entry/softirq_exit, 
> > irq_entry/irq_exit and tasklet_entry/tasklet_exit.
> 
> I rename timer_entry/timer_exit to 
> timer_expire/timer_callback_done just to match this series:
> 
> *_init() -> *_start() -> *_expire()...
> 
> It's a complete timer's lifecycle.

timer _handler_ entry/exit is a pretty good lifecycle name as well - 
and it nicely fits into the irq/softirq naming Anton mentioned. 
Maybe this list:

 timer_init
 timer_start
 timer_expire_entry
 timer_expire_exit
 timer_cancel

works for you Anton?

	Ingo

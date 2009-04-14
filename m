Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZDNXzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZDNXzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 19:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZDNXzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 19:55:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36287 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZDNXzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 19:55:36 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 5/4] ftrace, workqueuetrace: display work name
Cc: kosaki.motohiro@jp.fujitsu.com, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090414211620.GB5968@nowhere>
References: <20090414125142.C63D.A69D9226@jp.fujitsu.com> <20090414211620.GB5968@nowhere>
Message-Id: <20090415085310.AC0D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 15 Apr 2009 08:55:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > ------------------------------
> > # tracer: nop
> > #
> > #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > #              | |       |          |         |
> >           <idle>-0     [003]  1540.844960: workqueue_insertion: thread=events/3:30 func=e1000_watchdog_task+0x0/0x6ae [e1000e] work=&adapter->watchdog_task
> >           <idle>-0     [003]  1540.844964: workqueue_insertion: thread=events/3:30 func=vmstat_update+0x0/0x3f work=vmstat_work
> >            <...>-30    [003]  1540.844969: workqueue_handler_entry: thread=events/3:30 latency=0ms func=e1000_watchdog_task+0x0/0x6ae [e1000e] work=&adapter-
> > >watchdog_task
> >            <...>-30    [003]  1540.845003: workqueue_handler_exit: thread=events/3:30 func=e1000_watchdog_task+0x0/0x6ae [e1000e] work=&adapter->watchdog_tas
> > k
> >            <...>-30    [003]  1540.845004: workqueue_handler_entry: thread=events/3:30 latency=0ms func=vmstat_update+0x0/0x3f work=vmstat_work
> >            <...>-30    [003]  1540.845007: workqueue_handler_exit: thread=events/3:30 func=vmstat_update+0x0/0x3f work=vmstat_work
> > 
> > This patch increase kernel-size for work name string table.
> > But actually, lockdep already have work name string table. then if you already use lockdep,
> > you don't get kernel-size increasing by this patch.
> 
> I don't know. Does it happen that frequently for a function to be used
> by several works?
> If so, this feature may be indeed interesting.

No, it's really rare.
in last discuttion, "per work" tracing is one of the key-word.
then, I add this.

but, if frequency is important, I can drop it.




Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbZGYQ13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbZGYQ13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 12:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbZGYQ12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 12:27:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:38132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZGYQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 12:27:28 -0400
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
 breakpoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <20090725155129.GB749@Krystal>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
	 <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
	 <1248354493.26273.2.camel@twins>
	 <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com>
	 <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere>
	 <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere>
	 <20090725155129.GB749@Krystal>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 18:27:09 +0200
Message-Id: <1248539229.5780.30.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-25 at 11:51 -0400, Mathieu Desnoyers wrote:
> I agree with your idea to split the hardware counter management from
> virtual per-process counters. IMO, this limited resource needs to be
> managed centrally at one location and because system-wide level
> performance counters do not need to flip the performance counters
> depending on the current task.

System wide counters never care about the task state.

Its task counters we sometimes don't re-program counters for on context
switch when both tasks have the same configuration, saving greatly on
context switch costs.

>  We can easily think of an embedded system
> where providing system-wide performance counters would be important (for
> tracing for instance), but which would compile-out the per-task
> performance counters to save space.

That doesn't make sense, the per task/global parts of perf counters are
tightly interwoven and don't differ much.

> Note that you will have to deal with some policy here, because you can
> have performance counter reservation asked from both the kernel
> (for either kernel and per-task watchpoints) and from userspace (for
> per-task watchpoints).

cpu counters can be both kernel and user
task counter can be both kernel and user.

Your above use of 'and' doesn't make sense.


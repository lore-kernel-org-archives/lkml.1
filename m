Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbYKGQVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbYKGQVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYKGQVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:21:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398AbYKGQVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:21:22 -0500
Date: Fri, 7 Nov 2008 08:19:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Nicolas Pitre <nico@cam.org>,
       Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 07/18] Trace clock core
Message-Id: <20081107081939.4bcdf25b.akpm@linux-foundation.org>
In-Reply-To: <20081107161237.GA22134@Krystal>
References: <20081107052336.652868737@polymtl.ca>
	<20081107053349.699011457@polymtl.ca>
	<20081106215256.a9f01ec4.akpm@linux-foundation.org>
	<20081107061643.GA798@Krystal>
	<20081106222656.8e35d9d5.akpm@linux-foundation.org>
	<20081107161237.GA22134@Krystal>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 11:12:38 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Andrew Morton (akpm@linux-foundation.org) wrote:
> > On Fri, 7 Nov 2008 01:16:43 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > > Is there something we should be fixing in m68k?
> > > > 
> > > 
> > > Yes, but I fear it's going to go deep into include hell :-(
> > 
> > Oh, OK.  I thought that the comment meant that m68k's on_each_cpu()
> > behaves differently at runtime from other architectures (and wrongly).
> > 
> > If it's just some compile-time #include snafu then that's far less
> > of a concern.
> > 
> 
> Should I simply remove this comment then ?
> 

umm, it could perhaps be clarified - mention that it's needed for an
include order problem.

It's a bit odd.  Surely by the time we've included these:

+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+#include <linux/cpu.h>
+#include <linux/timex.h>
+#include <linux/bitops.h>
+#include <linux/trace-clock.h>
+#include <linux/smp.h>

someone has already included sched.h, and the definition of
_LINUX_SCHED_H will cause the later inclusion to not change anything?


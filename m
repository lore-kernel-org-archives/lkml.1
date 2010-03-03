Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0CCRQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:16:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:35148 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab0CCRQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:16:38 -0500
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
 events
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1267636046.10871.74.camel@gandalf.stny.rr.com>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
	 <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
	 <1267632387.10871.59.camel@gandalf.stny.rr.com>
	 <1267634258.25158.88.camel@laptop>
	 <1267636046.10871.74.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 18:16:35 +0100
Message-ID: <1267636595.25158.93.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 12:07 -0500, Steven Rostedt wrote:
> oops, my bad :-), I thought this was in the x86 arch directory. For the
> University, I was helping them with adding trace points for page faults
> when I came across this in arch/x86/mm/fault.c:
> 
>         perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
> 
> 
> This is what I actually was wondering about. Why is it a "perf only"
> trace point instead of a TRACE_EVENT()?

Because I wanted to make perf usable without having to rely on funny
tracepoints. That is, I am less worried about committing software
counters to ABI than I am about TRACE_EVENT(), which still gives me a
terribly uncomfortable feeling.

Also, building with all CONFIG_TRACE_*=n will still yield a usable perf,
which is something the embedded people might fancy, all that TRACE stuff
adds lots of code.


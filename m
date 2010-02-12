Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab0BLTKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:10:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab0BLTKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:10:39 -0500
X-Authority-Analysis: v=1.0 c=1 a=evUlCkV8MkoA:10 a=G84pBB-zaXpDWVkEYcwA:9 a=WlydrxPbYKLWdOvIlkkTOu8rhX8A:4 a=YQDlljpXE8zri9AN:21 a=BBr-RQy023Hu6V0u:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100212190907.954438555@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 12 Feb 2010 14:09:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 0/2][RFC] tracing: Showing symbols for TRACE_EVENT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re-sending since my first try was missing a '>' from Frederic's
 email address, and it screwed up quilt mail ]

The __print_symbolic() macro is used by TRACE_EVENT TP_printk to convert
numbers into symbols. But if those numbers are defined as ENUMS, it works
fine for ftrace trace output, but a parser reading the binary trace
will not know how to translate the enum into a number.

The first patch creates a EXTRACT_TRACE_SYMBOL(sym) macro that
a <events>.h file can add to extract out all the enums that it uses
in TRACE_EVENTs. These symbols will then appear in the event_symbols
file in the events/ directory.

The second patch converts softirq symbols in include/trace/events/irq.h

This is an RFC patch set. I want to get your feedback before I push
this out of my git repo.

Thanks,

-- Steve



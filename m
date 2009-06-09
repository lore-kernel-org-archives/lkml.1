Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZFIXhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZFIXhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZFIXhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:37:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64432 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZFIXhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:37:32 -0400
Date: Tue, 9 Jun 2009 19:37:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/8] [GIT PULL] simplify the print fmt in the event format
 files
In-Reply-To: <20090609232649.GA6945@elte.hu>
Message-ID: <alpine.DEB.2.00.0906091936590.30552@gandalf.stny.rr.com>
References: <20090609215211.307980196@goodmis.org> <20090609232341.GB23846@elte.hu> <20090609232649.GA6945@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Ingo Molnar wrote:

> 
> there's one test failure:
> 
> [    0.723000] calling  event_trace_init+0x0/0x13d @ 1
> [    0.725000] ------------[ cut here ]------------
> [    0.726000] WARNING: at kernel/trace/trace_read_binary.c:547 ftrace_initialize_print+0x673/0x690()
> [    0.727000] Hardware name: System Product Name
> [    0.728000] error in format type: 'sting:name> (<uint:wait_usec>.<printf:wait_nsec_rem:03lu> us)'
> [    0.729000] Modules linked in:
> [    0.730000] Pid: 1, comm: swapper Not tainted 2.6.30-rc8-tip-02137-g9d24ef9-dirty #51704
> [    0.731000] Call Trace:
> [    0.732000]  [<c10470aa>] warn_slowpath_common+0x65/0x95
> [    0.733000]  [<c1047118>] warn_slowpath_fmt+0x29/0x2c
> [    0.734000]  [<c10a14ef>] ftrace_initialize_print+0x673/0x690
> [    0.735000]  [<c10afa33>] ? kstrdup+0x2b/0x46
> [    0.736000]  [<c109cabc>] ? trace_define_field+0xa1/0xf5
> [    0.737000]  [<c106c0d5>] ftrace_define_fields_lock_acquired+0x132/0x13b
> [    0.738000]  [<c109cdbe>] event_create_dir+0x2ae/0x307
> [    0.739000]  [<c1973bf3>] ? event_trace_init+0x0/0x13d
> [    0.740000]  [<c1973d00>] event_trace_init+0x10d/0x13d
> [    0.741000]  [<c1001074>] do_one_initcall+0x6a/0x177
> [    0.742000]  [<c103329c>] ? kernel_map_pages+0xd2/0xe3
> [    0.743000]  [<c10690d2>] ? trace_hardirqs_on+0xb/0xd
> [    0.744000]  [<c1067855>] ? put_lock_stats+0xd/0x21
> [    0.745000]  [<c106795f>] ? lock_release_holdtime+0xf6/0xfb
> [    0.746000]  [<c10fc97c>] ? proc_register+0x14b/0x15c
> [    0.747000]  [<c15f05db>] ? _spin_unlock+0x2c/0x41
> [    0.748000]  [<c10fc97c>] ? proc_register+0x14b/0x15c
> [    0.749000]  [<c10fcaaf>] ? create_proc_entry+0x80/0x96
> [    0.750000]  [<c1086004>] ? register_irq_proc+0x91/0xad
> [    0.751000]  [<c1086078>] ? init_irq_proc+0x58/0x65
> [    0.752000]  [<c195f2d1>] kernel_init+0x100/0x151
> [    0.753000]  [<c195f1d1>] ? kernel_init+0x0/0x151
> [    0.754000]  [<c101b7e3>] kernel_thread_helper+0x7/0x10
> [    0.755000] ---[ end trace a7919e7f17c0a725 ]---
> [    0.758000] initcall event_trace_init+0x0/0x13d returned 0 after 33203 usecs
> [    0.759000] calling  ksym_tracer_stat_init+0x0/0x27 @ 1
> 
> config below.

I hit it too when I turned on lockstat. I have it fixed in my next 
release.

-- Steve

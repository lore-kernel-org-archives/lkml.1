Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbZHGLd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbZHGLd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbZHGLd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:33:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55987 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZHGLd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:33:56 -0400
Date: Fri, 7 Aug 2009 13:33:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
Message-ID: <20090807113349.GA31673@elte.hu>
References: <20090804111412.GA20942@elte.hu> <20090804113555.GA28198@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com> <1249633282.32113.613.camel@twins> <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com> <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com> <20090807112421.GB30014@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807112421.GB30014@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Metzger, Markus T <markus.t.metzger@intel.com> wrote:
> 
> > Ingo, what exactly do you mean by "locks up"? Is the kernel 
> > hanging or is perf record hanging?
> 
> it was a hard hang - box was not pingable, etc.

the moment i tried kernel-mode BTS tracing (i.e. -e branches, not -e 
branches:u) it hung hard again:

  titan:~> perf record -o /dev/null -f -e branches -c 1 ./loop_1b_instructions

this time i had a serial console attached - there's a perfcounters 
warning prior the hang - attached below. Peter, any ideas?

	Ingo

[  995.556131] ------------[ cut here ]------------
[  995.557128] WARNING: at kernel/perf_counter.c:1191 __perf_counter_task_sched_out+0x48/0x6b()
[  995.557128] Hardware name:         
[  995.557128] Modules linked in:
[  995.557128] Pid: 2008, comm: perf Tainted: G   M       2.6.31-rc5-tip #1350
[  995.557128] Call Trace:
[  995.557128]  <IRQ>  [<ffffffff810a20d9>] ? __perf_counter_task_sched_out+0x48/0x6b
[  995.557128]  [<ffffffff81044880>] warn_slowpath_common+0x77/0xa4
[  995.557128]  [<ffffffff810448bc>] warn_slowpath_null+0xf/0x11
[  995.557128]  [<ffffffff810a20d9>] __perf_counter_task_sched_out+0x48/0x6b
[  995.557128]  [<ffffffff810a4c75>] perf_counter_task_tick+0x61/0x9d
[  995.557128]  [<ffffffff810408b1>] scheduler_tick+0x112/0x237
[  995.557128]  [<ffffffff8104eb58>] update_process_times+0x4f/0x60
[  995.557128]  [<ffffffff81065186>] tick_sched_timer+0x6e/0x8e
[  995.557128]  [<ffffffff8105bff5>] __run_hrtimer+0x71/0xa5
[  995.557128]  [<ffffffff8105c23f>] hrtimer_interrupt+0xef/0x149
[  995.557128]  [<ffffffff810208b8>] smp_apic_timer_interrupt+0x83/0x96
[  995.557128]  [<ffffffff8100c6b3>] apic_timer_interrupt+0x13/0x20
[  995.557128]  <EOI>  [<ffffffff811465ac>] ? __log_space_left+0x0/0x2f
[  995.557128]  [<ffffffff811439a6>] ? start_this_handle+0x302/0x373
[  995.557128]  [<ffffffff810a6e09>] ? lock_page+0x11/0x29
[  995.557128]  [<ffffffff81143b66>] ? journal_start+0x95/0xc5
[  995.557128]  [<ffffffff8113d67f>] ? ext3_journal_start_sb+0x4a/0x4c
[  995.557128]  [<ffffffff81135d3e>] ? ext3_write_begin+0x9c/0x1e2
[  995.557128]  [<ffffffff810a66ef>] ? generic_perform_write+0xb4/0x1a7
[  995.557128]  [<ffffffff810a7dc8>] ? generic_file_buffered_write+0x6d/0x10c
[  995.557128]  [<ffffffff810a825c>] ? __generic_file_aio_write_nolock+0x25e/0x292
[  995.557128]  [<ffffffff810efa74>] ? mntput_no_expire+0x24/0xe8
[  995.557128]  [<ffffffff810a86a4>] ? generic_file_aio_write+0x67/0xc3
[  995.557128]  [<ffffffff811313ff>] ? ext3_file_write+0x1e/0x9f
[  995.557128]  [<ffffffff810da4dc>] ? do_sync_write+0xe7/0x12d
[  995.557128]  [<ffffffff8111f6d4>] ? show_map_vma+0x1c1/0x1d0
[  995.557128]  [<ffffffff811dabfa>] ? __up_read+0x9e/0xa8
[  995.557128]  [<ffffffff81059a10>] ? autoremove_wake_function+0x0/0x38
[  995.557128]  [<ffffffff8111e941>] ? m_stop+0x2b/0x4d
[  995.557128]  [<ffffffff8119a140>] ? security_file_permission+0x11/0x13
[  995.557128]  [<ffffffff810daeb8>] ? vfs_write+0xab/0x105
[  995.557128]  [<ffffffff810dafd6>] ? sys_write+0x47/0x6f
[  995.557128]  [<ffffffff8100bbab>] ? system_call_fastpath+0x16/0x1b
[  995.557128] ---[ end trace ff0d385da11eb1c5 ]---

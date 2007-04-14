Return-Path: <linux-kernel-owner+w=401wt.eu-S1030608AbXDNGV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608AbXDNGV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 02:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030694AbXDNGV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 02:21:27 -0400
Received: from gw.goop.org ([64.81.55.164]:53361 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030608AbXDNGV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 02:21:26 -0400
Message-ID: <462072C2.4070605@goop.org>
Date: Fri, 13 Apr 2007 23:20:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc6 + firstfloor patches: BUG: sleeping function called from
 invalid context at kernel/sched,.c:3643
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing this:

Apr 13 21:55:34 localhost kernel: BUG: sleeping function called from invalid context at kernel/sched.c:3643
Apr 13 21:55:34 localhost kernel: in_atomic():1, irqs_disabled():0
Apr 13 21:55:34 localhost kernel: 1 lock held by events/0/8:
Apr 13 21:55:34 localhost kernel:  #0:  (dbs_mutex){--..}, at: [<c032046b>] mutex_lock+0x1f/0x23
Apr 13 21:55:34 localhost kernel:  [<c0106f25>] show_trace_log_lvl+0x1a/0x30
Apr 13 21:55:34 localhost kernel:  [<c0107588>] show_trace+0x12/0x14
Apr 13 21:55:34 localhost kernel:  [<c0107650>] dump_stack+0x16/0x18
Apr 13 21:55:34 localhost kernel:  [<c011a56a>] __might_sleep+0xe5/0xeb
Apr 13 21:55:34 localhost kernel:  [<c031f194>] wait_for_completion+0x1a/0xaa
Apr 13 21:55:34 localhost kernel:  [<c011bea3>] set_cpus_allowed+0x6e/0x8c
Apr 13 21:55:34 localhost kernel:  [<c010f490>] acpi_cpufreq_target+0x18d/0x262
Apr 13 21:55:34 localhost kernel:  [<c02ae6d5>] __cpufreq_driver_target+0x27/0x32
Apr 13 21:55:34 localhost kernel:  [<c02b0d2b>] do_dbs_timer+0x190/0x1d2
Apr 13 21:55:34 localhost kernel:  [<c012ecde>] run_workqueue+0x8f/0x15f
Apr 13 21:55:34 localhost kernel:  [<c012f4ab>] worker_thread+0xf8/0x124
Apr 13 21:55:34 localhost kernel:  [<c0131cf0>] kthread+0xb5/0xe1
Apr 13 21:55:34 localhost kernel:  [<c0106b07>] kernel_thread_helper+0x7/0x10
Apr 13 21:55:34 localhost kernel:  =======================
Apr 13 21:55:34 localhost kernel: BUG: scheduling while atomic: events/0/0x00000002/8
Apr 13 21:55:34 localhost kernel: 1 lock held by events/0/8:
Apr 13 21:55:34 localhost kernel:  #0:  (dbs_mutex){--..}, at: [<c032046b>] mutex_lock+0x1f/0x23
Apr 13 21:55:34 localhost kernel:  [<c0106f25>] show_trace_log_lvl+0x1a/0x30
Apr 13 21:55:34 localhost kernel:  [<c0107588>] show_trace+0x12/0x14
Apr 13 21:55:34 localhost kernel:  [<c0107650>] dump_stack+0x16/0x18
Apr 13 21:55:34 localhost kernel:  [<c031e971>] __sched_text_start+0x79/0x86a
Apr 13 21:55:34 localhost kernel:  [<c031f1ee>] wait_for_completion+0x74/0xaa
Apr 13 21:55:34 localhost kernel:  [<c011bea3>] set_cpus_allowed+0x6e/0x8c
Apr 13 21:55:34 localhost kernel:  [<c010f490>] acpi_cpufreq_target+0x18d/0x262
Apr 13 21:55:34 localhost kernel:  [<c02ae6d5>] __cpufreq_driver_target+0x27/0x32
Apr 13 21:55:34 localhost kernel:  [<c02b0d2b>] do_dbs_timer+0x190/0x1d2
Apr 13 21:55:34 localhost kernel:  [<c012ecde>] run_workqueue+0x8f/0x15f
Apr 13 21:55:34 localhost kernel:  [<c012f4ab>] worker_thread+0xf8/0x124
Apr 13 21:55:34 localhost kernel:  [<c0131cf0>] kthread+0xb5/0xe1
Apr 13 21:55:34 localhost kernel:  [<c0106b07>] kernel_thread_helper+0x7/0x10
[...repeat ad nauseum...]


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbXDNVND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbXDNVND (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbXDNVND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:13:03 -0400
Received: from gw.goop.org ([64.81.55.164]:45134 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbXDNVNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:13:01 -0400
Message-ID: <462143B9.6080907@goop.org>
Date: Sat, 14 Apr 2007 14:12:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc6 + firstfloor patches: BUG: sleeping function called
 from invalid context at kernel/sched,.c:3643
References: <462072C2.4070605@goop.org> <200704141338.50058.ak@suse.de>
In-Reply-To: <200704141338.50058.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Fixed now. The latest sched-clock was leaking preempt counts during
> cpu frequency changes.
>   

No, that didn't help.  I think its cpufreq:

Apr 14 13:58:29 localhost kernel: BUG: scheduling while atomic: swapper/0x00000002/1
Apr 14 13:58:29 localhost kernel: 2 locks held by swapper/1:
Apr 14 13:58:29 localhost kernel:  #0:  (&per_cpu(cpu_policy_rwsem, cpu)){--..}, at: [<c02af1ec>] lock_policy_rwsem_write
+0x35/0x5f
Apr 14 13:58:29 localhost kernel:  #1:  (userspace_mutex){--..}, at: [<c032046b>] mutex_lock+0x1f/0x23
Apr 14 13:58:29 localhost kernel:  [<c0106f25>] show_trace_log_lvl+0x1a/0x30
Apr 14 13:58:29 localhost kernel:  [<c0107588>] show_trace+0x12/0x14
Apr 14 13:58:29 localhost kernel:  [<c0107650>] dump_stack+0x16/0x18
Apr 14 13:58:29 localhost kernel:  [<c031e971>] __sched_text_start+0x79/0x86a
Apr 14 13:58:29 localhost kernel:  [<c031f1ee>] wait_for_completion+0x74/0xaa
Apr 14 13:58:29 localhost kernel:  [<c011bea3>] set_cpus_allowed+0x6e/0x8c
Apr 14 13:58:29 localhost kernel:  [<c010f490>] acpi_cpufreq_target+0x18d/0x262
Apr 14 13:58:29 localhost kernel:  [<c02ae6d5>] __cpufreq_driver_target+0x27/0x32
Apr 14 13:58:29 localhost kernel:  [<c02aff0b>] cpufreq_governor_userspace+0x120/0x154
Apr 14 13:58:29 localhost kernel:  [<c02ae888>] __cpufreq_governor+0x77/0xab
Apr 14 13:58:29 localhost kernel:  [<c02aee6a>] __cpufreq_set_policy+0x109/0x11a
Apr 14 13:58:29 localhost kernel:  [<c02af32d>] cpufreq_set_policy+0x32/0x6c
Apr 14 13:58:29 localhost kernel:  [<c02afc11>] cpufreq_add_dev+0x347/0x3ea
Apr 14 13:58:29 localhost kernel:  [<c024a15e>] sysdev_driver_register+0x62/0xaf
Apr 14 13:58:29 localhost kernel:  [<c02af85a>] cpufreq_register_driver+0x82/0xf2
Apr 14 13:58:29 localhost kernel:  [<c0454f24>] acpi_cpufreq_init+0x8d/0x93
Apr 14 13:58:29 localhost kernel:  [<c04497c7>] init+0x14b/0x241
Apr 14 13:58:29 localhost kernel:  [<c0106b07>] kernel_thread_helper+0x7/0x10
Apr 14 13:58:29 localhost kernel:  =======================
Apr 14 13:58:29 localhost kernel: initcall at 0xc0454e97: acpi_cpufreq_init+0x0/0x93(): returned with preemption imbalance


    J

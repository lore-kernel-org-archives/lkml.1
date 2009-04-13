Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbZDMXhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbZDMXhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZDMXhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:37:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53430 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbZDMXhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:37:20 -0400
Date: Mon, 13 Apr 2009 19:36:33 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Subject: Scheduling while atomic in tty code with cdc-acm driver, kernel
 2.6.29.1
Message-ID: <20090413193633.33ce0710@dhcp-100-2-144.bos.redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: sleeping function called from invalid context at kernel/mutex.c:88
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
Pid: 0, comm: swapper Not tainted 2.6.29.1-54.fc11.x86_64 #1
Call Trace:
 <IRQ>  [<ffffffff8104255c>] __might_sleep+0x10b/0x110
 [<ffffffff813a8f2c>] mutex_lock+0x22/0x38
 [<ffffffff8103f597>] ? enqueue_task_fair+0x2a/0x6d
 [<ffffffff8122f794>] echo_char+0x25/0x81
 [<ffffffff81230e03>] n_tty_receive_buf+0x309/0xe50
 [<ffffffff8103be38>] ? task_rq_unlock+0x11/0x13
 [<ffffffff81042d5c>] ? default_wake_function+0x12/0x14
 [<ffffffff8103a1e0>] ? __wake_up_common+0x4e/0x84
 [<ffffffff8104fe2d>] ? __tasklet_schedule+0x77/0x8e
 [<ffffffff8102af47>] ? default_spin_lock_flags+0x9/0xe
 [<ffffffff81232a48>] ? tty_ldisc_try+0x3c/0x44
 [<ffffffff81233781>] flush_to_ldisc+0x10c/0x19f
 [<ffffffff81233864>] tty_flip_buffer_push+0x50/0x61
 [<ffffffffa03ab6ef>] acm_rx_tasklet+0x10c/0x28c [cdc_acm]
 [<ffffffff81050025>] tasklet_action+0x8e/0xf8
 [<ffffffff81050803>] __do_softirq+0x94/0x179
 [<ffffffff810127cc>] call_softirq+0x1c/0x30
 [<ffffffff8101394e>] do_softirq+0x52/0xb9
 [<ffffffff81050426>] irq_exit+0x53/0x90
 [<ffffffff81013c77>] do_IRQ+0x12c/0x151
 [<ffffffff81011f13>] ret_from_intr+0x0/0x2e
 <EOI>  [<ffffffff812187bd>] ? acpi_idle_enter_bm+0x28f/0x2de
 [<ffffffff812187b5>] ? acpi_idle_enter_bm+0x287/0x2de
 [<ffffffff812ee957>] ? cpuidle_idle_call+0x8d/0xc2
 [<ffffffff810102c7>] ? cpu_idle+0x68/0xb3
 [<ffffffff813a435c>] ? start_secondary+0x199/0x19e



Partial trace by kernel line numbers:

drivers/char/n_tty.c:828

drivers/char/n_tty.c:1160

drivers/char/tty_buffer.c:444

drivers/char/tty_buffer.c:486
  if (tty->low_latency)
    flush_to_ldisc(&tty->buf.work.work);  

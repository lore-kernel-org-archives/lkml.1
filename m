Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab0CLNJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:09:35 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:55341 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0CLNJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:09:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=aigVp26XI4rvhD2ofBsh7mKQ1EqOmHGhJ5pEMy6mVIPMkQa410h58QxpQQ/wt30qsJ
         2AKrSqNlxJkxWAGIaIc6Vwi0XWxUrtBxWZt6DYIFp/ctN/8XygI2g304TOZ19LkmBlNr
         a6wKQTkdQmO8zXo5f1wI+8KmlTXC7Vmgjr/Qo=
MIME-Version: 1.0
Date: Fri, 12 Mar 2010 14:09:31 +0100
X-Google-Sender-Auth: fb48f86171abfebd
Message-ID: <520f0cf11003120509j1dd6f2cicb1d87b0a16d31dd@mail.gmail.com>
Subject: [BUG REPORT] MAX_STACK_TRACE_ENTRIES too low! in v2.6.33-rt6
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just fyi: Note, I do have a large number of debug options
turned on, that could influence this.
This occurred on a Lenovo T500 Laptop, and x86_64 v2.6.33-rt6

BUG: MAX_STACK_TRACE_ENTRIES too low!
turning off the locking correctness validator.
Pid: 3334, comm: pulseaudio Not tainted 2.6.33-rt6 #1
Call Trace:
 [<ffffffff8106d099>] save_trace+0xab/0xb3
 [<ffffffff8106d123>] add_lock_to_list+0x82/0xc2
 [<ffffffff81076387>] ? rt_mutex_adjust_prio+0x1f/0x3e
 [<ffffffff81070a77>] __lock_acquire+0xbdc/0xda3
 [<ffffffff81037c1d>] ? finish_task_switch+0x77/0xf4
 [<ffffffff81037ba6>] ? finish_task_switch+0x0/0xf4
 [<ffffffff81070d16>] lock_acquire+0xd8/0xf5
 [<ffffffff81076387>] ? rt_mutex_adjust_prio+0x1f/0x3e
 [<ffffffff8135c971>] _raw_spin_lock_irqsave+0x47/0x7f
 [<ffffffff81076387>] ? rt_mutex_adjust_prio+0x1f/0x3e
 [<ffffffff81076387>] rt_mutex_adjust_prio+0x1f/0x3e
 [<ffffffff8135b51c>] rt_mutex_slowunlock+0x6d/0x76
 [<ffffffff8135b52e>] rt_mutex_unlock+0x9/0xb
 [<ffffffff81078115>] rt_up_read+0x3b/0x40
 [<ffffffff81043cd1>] ? exit_mm+0xd4/0x156
 [<ffffffff81043ce4>] exit_mm+0xe7/0x156
 [<ffffffff810979e0>] ? audit_free_context+0xa7/0xd0
 [<ffffffff810457f7>] do_exit+0x1fe/0x784
 [<ffffffff8106ee4c>] ? trace_hardirqs_on_caller+0x113/0x13e
 [<ffffffff81097ca0>] ? audit_syscall_entry+0x114/0x140
 [<ffffffff81045e59>] complete_and_exit+0x0/0x1f
 [<ffffffff81002c2b>] system_call_fastpath+0x16/0x1b

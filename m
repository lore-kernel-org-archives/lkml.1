Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbXCDQ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbXCDQ2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXCDQ2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:28:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:42555 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXCDQ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:28:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T/1gCkhMKScm3gNZTF5gRPPu/+FUA31gYRg0v4qY+Xq+0Xb6ptRo7DzAbOzvhT/sYLrCW/9b8dqKg8B2Vu3IMD97D33ZnXTr7OjkuH8zB/Wc8rJHPrzGYGu7VnS6DFiQVVSNjkHYnjYpq2CCqoyCMMoPUaXDHqLF09jmlXmfJ5Y=
Subject: HR timers soft lockup on resume from suspend to ram
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= RISS <frederic.riss@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Mar 2007 17:28:24 +0100
Message-Id: <1173025704.11244.22.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With recent git versions, my system won't resume from suspend to ram. At
resume time, the kernel hangs just after printing "Enabling non-boot
CPUs ...". This is on a Core Duo system (Mac Mini). Looking at the BUG,
it looks related to hrtimers.

When the system is hung, and I press on the power button, I get this
backtrace (copied from the screen, netconsole won't allow to capture
it): 

BUG: soft lockup detected on CPU#0!
  [<c0155c88>] softlockup_tick+0xa8/0x110
  [<c0130283>] update_process_times+0x33/0x80
  [<c014215b>] tick_sched_timer+0x5b/0xc0
  [<c013e3f3>] hrtimer_interrupt+0x143/0x1d0
  [<c01172e0>] smp_apic_timer_interrupt+0x50/0x80
  [<c0104e4c>] apic_timer_interrupt+0x28/0x30
  [<c0372926>] _spin_unlock_irq+0x6/0x30
  [<c0370488>] __sched_text_start+0x308/0x880
  [<c0372909>] _spin_unlock_irqrestore+0x19/0x30
  [<c01378ee>] worker_thread+0x12e/0x170
  [<c0120a50>] default_wake_function+0x0/0x10
  [<c01377c0>] worker_thread+0x0/0x170
  [<c013a88a>] kthread+0xba/0xf0
  [<c013a7d0>] kthread+0x0/0xf0
  [<c0104fb3>] kernel_thread_helper+0x7/0x14
  ======================

I get it every time I press on the power button.

Fred.


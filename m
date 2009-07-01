Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZGAESo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZGAESo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZGAESg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:18:36 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:54023 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZGAESf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:18:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=t1tj7jhb0eEJY2fXct0XgVPSKW+o9N+MXu3zlBdXyrq1ZALGFIZfaebjq7U0wzlmRy
         PlBHc6nP3tXCrxp/APc7HvtDaAdoRTpPEgP4FWD+LsDpzncdNg5J+fVlXnpTbqVOlJZG
         EUDiauIg3Helg79OoUjYlxnmdu+DL67XzSkkk=
MIME-Version: 1.0
Date: Tue, 30 Jun 2009 21:18:35 -0700
Message-ID: <86802c440906302118oa181b2fm9599137bb2314129@mail.gmail.com>
Subject: pci_stub and kvm
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       jbarnes@virtuousgeek.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 1966.343286]
[ 1966.343288] =======================================================
[ 1966.356756] [ INFO: possible circular locking dependency detected ]
[ 1966.356759] 2.6.31-rc1-tip-00978-g99123e5-dirty #438
[ 1966.356761] -------------------------------------------------------
[ 1966.356764] events/0/387 is trying to acquire lock:
[ 1966.356766]  (&kvm->lock){+.+.+.}, at: [<ffffffff8100af27>]
kvm_assigned_dev_interrupt_work_handler+0x42/0x13a
[ 1966.356786]
[ 1966.356787] but task is already holding lock:
[ 1966.356789]  (&match->interrupt_work){+.+...}, at:
[<ffffffff810986e9>] worker_thread+0x175/0x2f6
[ 1966.356797]
[ 1966.356798] which lock already depends on the new lock.
[ 1966.356799]
[ 1966.356800]
[ 1966.356801] the existing dependency chain (in reverse order) is:
[ 1966.356803]
[ 1966.356803] -> #1 (&match->interrupt_work){+.+...}:
[ 1966.356809]        [<ffffffff810b3bf6>] __lock_acquire+0x1396/0x1710
[ 1966.356817]        [<ffffffff810b403c>] lock_acquire+0xcc/0x104
[ 1966.356821]        [<ffffffff810994a8>] __cancel_work_timer+0x121/0x247
[ 1966.356825]        [<ffffffff8109962c>] cancel_work_sync+0x23/0x39
[ 1966.356828]        [<ffffffff8100b280>] kvm_deassign_irq+0xf1/0x183
[ 1966.356832]        [<ffffffff8100db6c>] kvm_vm_ioctl+0x8c8/0xc1a
[ 1966.356837]        [<ffffffff81156e56>] vfs_ioctl+0x3e/0xa3
[ 1966.356846]        [<ffffffff8115741c>] do_vfs_ioctl+0x4be/0x511
[ 1966.356850]        [<ffffffff811574c5>] sys_ioctl+0x56/0x8d
[ 1966.356854]        [<ffffffff81034fdb>] system_call_fastpath+0x16/0x1b
[ 1966.356860]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1966.356869]
[ 1966.356870] -> #0 (&kvm->lock){+.+.+.}:
[ 1966.356872]        [<ffffffff810b392b>] __lock_acquire+0x10cb/0x1710
[ 1966.356875]        [<ffffffff810b403c>] lock_acquire+0xcc/0x104
[ 1966.356878]        [<ffffffff81cde487>] mutex_lock_nested+0x75/0x2fa
[ 1966.356886]        [<ffffffff8100af27>]
kvm_assigned_dev_interrupt_work_handler+0x42/0x13a
[ 1966.356890]        [<ffffffff81098743>] worker_thread+0x1cf/0x2f6
[ 1966.356892]        [<ffffffff8109e335>] kthread+0xa8/0xb0
[ 1966.356899]        [<ffffffff8103609a>] child_rip+0xa/0x20
[ 1966.356906]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1966.356908]
[ 1966.356909] other info that might help us debug this:
[ 1966.356909]
[ 1966.356911] 2 locks held by events/0/387:
[ 1966.356913]  #0:  (events){+.+.+.}, at: [<ffffffff810986e9>]
worker_thread+0x175/0x2f6
[ 1966.356917]  #1:  (&match->interrupt_work){+.+...}, at:
[<ffffffff810986e9>] worker_thread+0x175/0x2f6
[ 1966.356922]
[ 1966.356923] stack backtrace:
[ 1966.356925] Pid: 387, comm: events/0 Not tainted
2.6.31-rc1-tip-00978-g99123e5-dirty #438
[ 1966.356928] Call Trace:
[ 1966.356932]  [<ffffffff810b2362>] print_circular_bug_tail+0xd0/0xef
[ 1966.356935]  [<ffffffff810b2232>] ? check_noncircular+0xec/0x14c
[ 1966.356939]  [<ffffffff810b392b>] __lock_acquire+0x10cb/0x1710
[ 1966.356942]  [<ffffffff8100af27>] ?
kvm_assigned_dev_interrupt_work_handler+0x42/0x13a
[ 1966.356947]  [<ffffffff810af6f7>] ? save_trace+0x4e/0xc2
[ 1966.356950]  [<ffffffff810b2836>] ? check_irq_usage+0xc6/0xf0
[ 1966.356953]  [<ffffffff8100af27>] ?
kvm_assigned_dev_interrupt_work_handler+0x42/0x13a
[ 1966.356956]  [<ffffffff810b403c>] lock_acquire+0xcc/0x104
[ 1966.356959]  [<ffffffff8100af27>] ?
kvm_assigned_dev_interrupt_work_handler+0x42/0x13a
[ 1966.356962]  [<ffffffff810986e9>] ? worker_thread+0x175/0x2f6
[ 1966.356965]  [<ffffffff81cde487>] mutex_lock_nested+0x75/0x2fa
[ 1966.356968]  [<ffffffff8100af27>] ?
kvm_assigned_dev_interrupt_work_handler+0x42/0x13a
[ 1966.356972]  [<ffffffff8100af27>] ?
kvm_assigned_dev_interrupt_work_handler+0x42/0x13a
[ 1966.356975]  [<ffffffff810986e9>] ? worker_thread+0x175/0x2f6
[ 1966.356977]  [<ffffffff810986e9>] ? worker_thread+0x175/0x2f6
[ 1966.356980]  [<ffffffff810986e9>] ? worker_thread+0x175/0x2f6
[ 1966.356983]  [<ffffffff8100af27>]
kvm_assigned_dev_interrupt_work_handler+0x42/0x13a
[ 1966.356986]  [<ffffffff81098743>] worker_thread+0x1cf/0x2f6
[ 1966.356989]  [<ffffffff810986e9>] ? worker_thread+0x175/0x2f6
[ 1966.356992]  [<ffffffff8100aee5>] ?
kvm_assigned_dev_interrupt_work_handler+0x0/0x13a
[ 1966.356996]  [<ffffffff8109e788>] ? autoremove_wake_function+0x0/0x63
[ 1966.356998]  [<ffffffff81098574>] ? worker_thread+0x0/0x2f6
[ 1966.357001]  [<ffffffff8109e335>] kthread+0xa8/0xb0
[ 1966.357005]  [<ffffffff8103609a>] child_rip+0xa/0x20
[ 1966.357008]  [<ffffffff81035a3c>] ? restore_args+0x0/0x30
[ 1966.357011]  [<ffffffff8109e28d>] ? kthread+0x0/0xb0
[ 1966.357014]  [<ffffffff81036090>] ? child_rip+0x0/0x20
[ 1966.600740] pci-stub 0000:83:00.0: irq 150 for MSI/MSI-X
[ 1966.601061] pci-stub 0000:83:00.0: irq 150 for MSI/MSI-X

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbZCaOKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbZCaOKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbZCaOKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:10:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:29888 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbZCaOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:10:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SjvPTS+wWtK4evSaK5bq3OQ+G5YaElRcHkVj7tHSVpum/v6+CCElAhoCE6DlQ3aZJS
         rT9rlIagx0oTRoK95bDtOCSh1y/j9HZFumbKLIFK78lKWECVyBXwSv+9OHjPuPonnCbm
         PQjAwYy8Q6gvd30f3COMU7aKugMbPKUEXmpCc=
MIME-Version: 1.0
Date: Tue, 31 Mar 2009 22:10:25 +0800
Message-ID: <d82e647a0903310710y1b60b674u30eb59fa64e52276@mail.gmail.com>
Subject: 2.6.29-05154-g8a9b290 : possible irq lock inversion dependency 
	detected
From: Ming Lei <tom.leiming@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  118.036894]
[  118.036899] =========================================================
[  118.036913] [ INFO: possible irq lock inversion dependency detected ]
[  118.036924] 2.6.29-05154-g8a9b290 #79
[  118.036931] ---------------------------------------------------------
[  118.036940] swapper/0 just changed the state of lock:
[  118.036948]  (fasync_lock){..+.}, at: [<ffffffff8031f138>]
kill_fasync+0x33/0x5e
[  118.036978] but this lock took another, hard-irq-unsafe lock in the past:
[  118.036986]  (&f->f_lock){--..}
[  118.036998]
[  118.036999] and interrupts could create inverse lock ordering between them.
[  118.037003]
[  118.037011]
[  118.037013] other info that might help us debug this:
[  118.037022] 4 locks held by swapper/0:
[  118.037029]  #0:  (&serio->lock){++..}, at: [<ffffffff8047efdb>]
serio_interrupt+0x2d/0xc4
[  118.037059]  #1:  (&dev->event_lock){+...}, at:
[<ffffffff80484d8d>] input_event+0x47/0x8e
[  118.037087]  #2:  (rcu_read_lock){..--}, at: [<ffffffff80483086>]
input_pass_event+0x0/0x13e
[  118.037115]  #3:  (rcu_read_lock){..--}, at: [<ffffffffa01f76f6>]
evdev_event+0x0/0x15e [evdev]
[  118.037154]
[  118.037156] the first lock's dependencies:
[  118.037164] -> (fasync_lock){..+.} ops: 0 {
[  118.037187]    initial-use  at:
[  118.037198]
[<ffffffff802859c7>] __lock_acquire+0x7eb/0x1702
[  118.037217]
[<ffffffff8028693f>] lock_acquire+0x61/0x84
[  118.037233]
[<ffffffff8057a718>] _write_lock_irq+0x4c/0x91
[  118.037251]
[<ffffffff8031eab1>] fasync_helper+0x80/0x172
[  118.037268]
[<ffffffff8043d2b1>] tty_fasync+0x67/0x18e
[  118.037285]
[<ffffffff804406d1>] tty_release_dev+0x7f/0x6a7
[  118.037301]
[<ffffffff80440d17>] tty_release+0x1e/0x2a
[  118.037316]
[<ffffffff8030f168>] __fput+0x17e/0x2ba
[  118.037334]
[<ffffffff8030f2c8>] fput+0x24/0x2f
[  118.037349]
[<ffffffff8030ad55>] filp_close+0x79/0x8e
[  118.037365]
[<ffffffff802553ef>] put_files_struct+0xca/0x12b
[  118.037382]
[<ffffffff802554a3>] exit_files+0x53/0x64
[  118.037397]
[<ffffffff802578a1>] do_exit+0x3c6/0xd20
[  118.037412]
[<ffffffff8025831b>] sys_exit_group+0x0/0x1b
[  118.037428]
[<ffffffff80258332>] sys_exit_group+0x17/0x1b
[  118.037444]
[<ffffffff8020bd62>] system_call_fastpath+0x16/0x1b
[  118.037462]
[<ffffffffffffffff>] 0xffffffffffffffff
[  118.037481]    in-hardirq-R at:
[  118.037492]
[<ffffffffffffffff>] 0xffffffffffffffff
[  118.037496]  }
[  118.037496]  ... key      at: [<ffffffff80830e18>] fasync_lock+0x18/0x40
[  118.037496]  -> (&f->f_lock){--..} ops: 0 {
[  118.037496]     initial-use  at:
[  118.037496]
[<ffffffff802859c7>] __lock_acquire+0x7eb/0x1702
[  118.037496]
[<ffffffff8028693f>] lock_acquire+0x61/0x84
[  118.037496]
[<ffffffff8057a312>] _spin_lock+0x40/0x84
[  118.037496]
[<ffffffff8031eb5a>] fasync_helper+0x129/0x172
[  118.037496]
[<ffffffff8043d2b1>] tty_fasync+0x67/0x18e
[  118.037496]
[<ffffffff804406d1>] tty_release_dev+0x7f/0x6a7
[  118.037496]
[<ffffffff80440d17>] tty_release+0x1e/0x2a
[  118.037496]
[<ffffffff8030f168>] __fput+0x17e/0x2ba
[  118.037496]
[<ffffffff8030f2c8>] fput+0x24/0x2f
[  118.037496]
[<ffffffff8030ad55>] filp_close+0x79/0x8e
[  118.037496]
[<ffffffff802553ef>] put_files_struct+0xca/0x12b
[  118.037496]
[<ffffffff802554a3>] exit_files+0x53/0x64
[  118.037496]
[<ffffffff802578a1>] do_exit+0x3c6/0xd20
[  118.037496]
[<ffffffff8025831b>] sys_exit_group+0x0/0x1b
[  118.037496]
[<ffffffff80258332>] sys_exit_group+0x17/0x1b
[  118.037496]
[<ffffffff8020bd62>] system_call_fastpath+0x16/0x1b
[  118.037496]
[<ffffffffffffffff>] 0xffffffffffffffff
[  118.037496]     softirq-on-W at:
[  118.037496]
[<ffffffff802859ae>] __lock_acquire+0x7d2/0x1702
[  118.037496]
[<ffffffff8028693f>] lock_acquire+0x61/0x84
[  118.037496]
[<ffffffff8057a312>] _spin_lock+0x40/0x84
[  118.037496]
[<ffffffff8034c2c1>] sys_epoll_ctl+0x2b5/0x688
[  118.037496]
[<ffffffff8020bd62>] system_call_fastpath+0x16/0x1b
[  118.037496]
[<ffffffffffffffff>] 0xffffffffffffffff
[  118.037496]     hardirq-on-W at:
[  118.037496]
[<ffffffff80285986>] __lock_acquire+0x7aa/0x1702
[  118.037496]
[<ffffffff8028693f>] lock_acquire+0x61/0x84
[  118.037496]
[<ffffffff8057a312>] _spin_lock+0x40/0x84
[  118.037496]
[<ffffffff8034c2c1>] sys_epoll_ctl+0x2b5/0x688
[  118.037496]
[<ffffffff8020bd62>] system_call_fastpath+0x16/0x1b
[  118.037496]
[<ffffffffffffffff>] 0xffffffffffffffff
[  118.037496]   }
[  118.037496]   ... key      at: [<ffffffff814c35b8>] __key.24598+0x0/0x8
[  118.037496]  ... acquired at:
[  118.037496]    [<ffffffff80286569>] __lock_acquire+0x138d/0x1702
[  118.037496]    [<ffffffff8028693f>] lock_acquire+0x61/0x84
[  118.037496]    [<ffffffff8057a312>] _spin_lock+0x40/0x84
[  118.037496]    [<ffffffff8031eb5a>] fasync_helper+0x129/0x172
[  118.037496]    [<ffffffff8043d2b1>] tty_fasync+0x67/0x18e
[  118.037496]    [<ffffffff804406d1>] tty_release_dev+0x7f/0x6a7
[  118.037496]    [<ffffffff80440d17>] tty_release+0x1e/0x2a
[  118.037496]    [<ffffffff8030f168>] __fput+0x17e/0x2ba
[  118.037496]    [<ffffffff8030f2c8>] fput+0x24/0x2f
[  118.037496]    [<ffffffff8030ad55>] filp_close+0x79/0x8e
[  118.037496]    [<ffffffff802553ef>] put_files_struct+0xca/0x12b
[  118.037496]    [<ffffffff802554a3>] exit_files+0x53/0x64
[  118.037496]    [<ffffffff802578a1>] do_exit+0x3c6/0xd20
[  118.037496]    [<ffffffff8025831b>] sys_exit_group+0x0/0x1b
[  118.037496]    [<ffffffff80258332>] sys_exit_group+0x17/0x1b
[  118.037496]    [<ffffffff8020bd62>] system_call_fastpath+0x16/0x1b
[  118.037496]    [<ffffffffffffffff>] 0xffffffffffffffff
[  118.037496]
[  118.037496]
[  118.037496] the second lock's dependencies:
[  118.037496] -> (&f->f_lock){--..} ops: 0 {
[  118.037496]    initial-use  at:
[  118.037496]
[<ffffffff802859c7>] __lock_acquire+0x7eb/0x1702
[  118.037496]
[<ffffffff8028693f>] lock_acquire+0x61/0x84
[  118.037496]
[<ffffffff8057a312>] _spin_lock+0x40/0x84
[  118.037496]
[<ffffffff8031eb5a>] fasync_helper+0x129/0x172
[  118.037496]
[<ffffffff8043d2b1>] tty_fasync+0x67/0x18e
[  118.037496]
[<ffffffff804406d1>] tty_release_dev+0x7f/0x6a7
[  118.037496]
[<ffffffff80440d17>] tty_release+0x1e/0x2a
[  118.037496]
[<ffffffff8030f168>] __fput+0x17e/0x2ba
[  118.037496]
[<ffffffff8030f2c8>] fput+0x24/0x2f
[  118.037496]
[<ffffffff8030ad55>] filp_close+0x79/0x8e
[  118.037496]
[<ffffffff802553ef>] put_files_struct+0xca/0x12b
[  118.037496]
[<ffffffff802554a3>] exit_files+0x53/0x64
[  118.037496]
[<ffffffff802578a1>] do_exit+0x3c6/0xd20
[  118.037496]
[<ffffffff8025831b>] sys_exit_group+0x0/0x1b
[  118.037496]
[<ffffffff80258332>] sys_exit_group+0x17/0x1b
[  118.037496]
[<ffffffff8020bd62>] system_call_fastpath+0x16/0x1b
[  118.037496]
[<ffffffffffffffff>] 0xffffffffffffffff
[  118.037496]    softirq-on-W at:
[  118.037496]
[<ffffffff802859ae>] __lock_acquire+0x7d2/0x1702
[  118.037496]
[<ffffffff8028693f>] lock_acquire+0x61/0x84
[  118.037496]
[<ffffffff8057a312>] _spin_lock+0x40/0x84
[  118.037496]
[<ffffffff8034c2c1>] sys_epoll_ctl+0x2b5/0x688
[  118.037496]
[<ffffffff8020bd62>] system_call_fastpath+0x16/0x1b
[  118.037496]
[<ffffffffffffffff>] 0xffffffffffffffff
[  118.037496]    hardirq-on-W at:
[  118.037496]
[<ffffffff80285986>] __lock_acquire+0x7aa/0x1702
[  118.037496]
[<ffffffff8028693f>] lock_acquire+0x61/0x84
[  118.037496]
[<ffffffff8057a312>] _spin_lock+0x40/0x84
[  118.037496]
[<ffffffff8034c2c1>] sys_epoll_ctl+0x2b5/0x688
[  118.037496]
[<ffffffff8020bd62>] system_call_fastpath+0x16/0x1b
[  118.037496]
[<ffffffffffffffff>] 0xffffffffffffffff
[  118.037496]  }
[  118.037496]  ... key      at: [<ffffffff814c35b8>] __key.24598+0x0/0x8
[  118.037496]
[  118.037496] stack backtrace:
[  118.037496] Pid: 0, comm: swapper Not tainted 2.6.29-05154-g8a9b290 #79
[  118.037496] Call Trace:
[  118.037496]  <IRQ>  [<ffffffff80283a8f>] print_irq_inversion_bug+0x181/0x192
[  118.037496]  [<ffffffff80283b38>] check_usage_forwards+0x98/0xa0
[  118.037496]  [<ffffffff802841b8>] mark_lock+0x5db/0xa35
[  118.037496]  [<ffffffff802858ac>] __lock_acquire+0x6d0/0x1702
[  118.037496]  [<ffffffff8028693f>] lock_acquire+0x61/0x84
[  118.037496]  [<ffffffff8031f138>] ? kill_fasync+0x33/0x5e
[  118.037496]  [<ffffffff8057aab1>] _read_lock+0x43/0x86
[  118.037496]  [<ffffffff8031f138>] ? kill_fasync+0x33/0x5e
[  118.037496]  [<ffffffff8031f138>] kill_fasync+0x33/0x5e
[  118.037496]  [<ffffffffa01f7377>] evdev_pass_event+0x6e/0x77 [evdev]
[  118.037496]  [<ffffffffa01f77a9>] evdev_event+0xb3/0x15e [evdev]
[  118.037496]  [<ffffffffa01f76f6>] ? evdev_event+0x0/0x15e [evdev]
[  118.037496]  [<ffffffff80483134>] input_pass_event+0xae/0x13e
[  118.037496]  [<ffffffff80483086>] ? input_pass_event+0x0/0x13e
[  118.037496]  [<ffffffff80483a5f>] input_handle_event+0x44e/0x508
[  118.037496]  [<ffffffff80484db0>] input_event+0x6a/0x8e
[  118.037496]  [<ffffffff8048959f>] atkbd_interrupt+0x378/0x6f5
[  118.037496]  [<ffffffff8047f01e>] serio_interrupt+0x70/0xc4
[  118.037496]  [<ffffffff80480685>] i8042_interrupt+0x2c5/0x332
[  118.037496]  [<ffffffff802a535d>] handle_IRQ_event+0x10c/0x167
[  118.037496]  [<ffffffff802a71e7>] handle_edge_irq+0x1c5/0x227
[  118.037496]  [<ffffffff8020f0e3>] handle_irq+0x166/0x174
[  118.037496]  [<ffffffff8057b2cb>] __irqentry_text_start+0x63/0xfd
[  118.037496]  [<ffffffff8020c753>] ret_from_intr+0x0/0x16
[  118.037496]  <EOI>  [<ffffffffa023170f>] ?
acpi_idle_enter_bm+0x42d/0x4f1 [processor]
[  118.037496]  [<ffffffffa0231715>] ? acpi_idle_enter_bm+0x433/0x4f1
[processor]
[  118.037496]  [<ffffffffa023170f>] ? acpi_idle_enter_bm+0x42d/0x4f1
[processor]
[  118.037496]  [<ffffffff8049e7f4>] ? menu_select+0x77/0x121
[  118.037496]  [<ffffffff8049d6ab>] ? cpuidle_idle_call+0xab/0x154
[  118.037496]  [<ffffffff8020ab1f>] ? cpu_idle+0x8d/0x117
[  118.037496]  [<ffffffff80570552>] ? start_secondary+0x3d2/0x3f5
[  124.245246] fuse init (API version 7.11)
[  124.245375] device: 'fuse': device_add
[  124.245577] PM: Adding info for No Bus:fuse
[  124.265980] device: '0:17': device_add


-- 
Lei Ming

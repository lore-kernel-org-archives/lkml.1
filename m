Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbYEKTdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbYEKTdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbYEKTd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:33:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33638 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbYEKTd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:33:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: kgdb test suite failure
Date: Sun, 11 May 2008 21:32:56 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: jason.wessel@windriver.com, kgdb-bugreport@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <a4423d670805090714iaae7d4fj2883889ede15a4be@mail.gmail.com>
In-Reply-To: <a4423d670805090714iaae7d4fj2883889ede15a4be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805112132.57229.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added some CCs.]

On Friday, 9 of May 2008, Alexander Beregalov wrote:
> Hi
> I tried to run the latest git kernel and got the following error.
> 
> See an attachment for full dmesg.
> 
> kgdbts: ERROR PUT: end of test buffer on 'do_fork_test' line 5
> expected OK got $E02#a7
> ------------[ cut here ]------------
> WARNING: at drivers/misc/kgdbts.c:721 run_simple_test+0x1de/0x20e()
> Modules linked in:
> Pid: 6, comm: khelper Not tainted 2.6.26-rc1-00279-g28a4acb #12
> [<c011a00a>] warn_on_slowpath+0x41/0x6c
> [<c011aa77>] ? vprintk+0x3e7/0x407
> [<c0254cf4>] ? number+0x10d/0x1cf
> [<c012d3da>] ? sched_clock_cpu+0x70/0x88
> [<c011aaac>] ? printk+0x15/0x17
> [<c02ae228>] run_simple_test+0x1de/0x20e
> [<c02adc15>] kgdbts_put_char+0x14/0x16
> [<c013d7ba>] put_packet+0x6b/0xbb
> [<c013e8bc>] kgdb_handle_exception+0xa19/0xb21
> [<c0119400>] ? do_fork+0x0/0x19e
> [<c010e9e3>] kgdb_notify+0x103/0x140
> [<c035ac89>] notifier_call_chain+0x2b/0x4a
> [<c035accd>] __atomic_notifier_call_chain+0x25/0x36
> [<c035acea>] atomic_notifier_call_chain+0xc/0xe
> [<c012cd15>] notify_die+0x2d/0x2f
> [<c03597fd>] do_int3+0x32/0x6c
> [<c0359293>] int3+0x27/0x2c
> [<c0119400>] ? do_fork+0x0/0x19e
> [<c010176c>] ? kernel_thread+0x73/0x7b
> [<c01263d1>] ? ____call_usermodehelper+0x0/0xe7
> [<c01263d1>] ? ____call_usermodehelper+0x0/0xe7
> [<c0103740>] ? kernel_thread_helper+0x0/0x10
> [<c0126236>] __call_usermodehelper+0x33/0x4d
> [<c0126686>] run_workqueue+0xba/0x187
> [<c012664c>] ? run_workqueue+0x80/0x187
> [<c0126203>] ? __call_usermodehelper+0x0/0x4d
> [<c0126ea6>] worker_thread+0x80/0x8c
> [<c01291bd>] ? autoremove_wake_function+0x0/0x30
> [<c0126e26>] ? worker_thread+0x0/0x8c
> [<c01290fc>] kthread+0x39/0x61
> [<c01290c3>] ? kthread+0x0/0x61
> [<c0103747>] kernel_thread_helper+0x7/0x10
> =======================
> ---[ end trace b9faa95810ce9135 ]---
> e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
>  Tx Queue             <0>
>  TDH                  <2a>
>  TDT                  <2a>
>  next_to_use          <2a>
>  next_to_clean        <14>
> buffer_info[next_to_clean]
>  time_stamp           <fffeb89e>
>  next_to_watch        <14>
>  jiffies              <fffebb63>
>  next_to_watch.status <1>
> khelper used greatest stack depth: 2516 bytes left
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<00000000>]
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> kgdbts: BP mismatch 0 expected c0119400
> ------------[ cut here ]------------
> WARNING: at drivers/misc/kgdbts.c:302 check_and_rewind_pc+0x9a/0xb4()
> Modules linked in:
> Pid: 6, comm: khelper Tainted: G        W 2.6.26-rc1-00279-g28a4acb #12
> [<c011a00a>] warn_on_slowpath+0x41/0x6c
> [<c011aa77>] ? vprintk+0x3e7/0x407
> [<c0119400>] ? do_fork+0x0/0x19e
> [<c012d3da>] ? sched_clock_cpu+0x70/0x88
> [<c0116d4e>] ? cpu_clock+0x115/0x12c
> [<c0119400>] ? do_fork+0x0/0x19e
> [<c011aaac>] ? printk+0x15/0x17
> [<c0119400>] ? do_fork+0x0/0x19e
> [<c02ae96d>] check_and_rewind_pc+0x9a/0xb4
> [<c0119400>] ? do_fork+0x0/0x19e
> [<c02adb7a>] validate_simple_test+0x22/0x69
> [<c02ae1eb>] run_simple_test+0x1a1/0x20e
> [<c02adc15>] kgdbts_put_char+0x14/0x16
> [<c013d7ba>] put_packet+0x6b/0xbb
> [<c013e8bc>] kgdb_handle_exception+0xa19/0xb21
> [<c010e9e3>] kgdb_notify+0x103/0x140
> [<c035ac89>] notifier_call_chain+0x2b/0x4a
> [<c035accd>] __atomic_notifier_call_chain+0x25/0x36
> [<c035acea>] atomic_notifier_call_chain+0xc/0xe
> [<c012cd15>] notify_die+0x2d/0x2f
> [<c0359303>] __die+0x61/0xc6
> [<c0103dec>] die+0x87/0x106
> [<c035aae1>] do_page_fault+0x4e3/0x59d
> [<c035a5fe>] ? do_page_fault+0x0/0x59d
> [<c010176c>] ? kernel_thread+0x73/0x7b
> [<c0359102>] error_code+0x6a/0x70
> [<c010176c>] ? kernel_thread+0x73/0x7b
> [<c01263d1>] ? ____call_usermodehelper+0x0/0xe7
> [<c01263d1>] ? ____call_usermodehelper+0x0/0xe7
> [<c0103740>] ? kernel_thread_helper+0x0/0x10
> [<c0126236>] ? __call_usermodehelper+0x33/0x4d
> [<c0126686>] ? run_workqueue+0xba/0x187
> [<c012664c>] ? run_workqueue+0x80/0x187
> [<c0126203>] ? __call_usermodehelper+0x0/0x4d
> [<c0126ea6>] ? worker_thread+0x80/0x8c
> [<c01291bd>] ? autoremove_wake_function+0x0/0x30
> [<c0126e26>] ? worker_thread+0x0/0x8c
> [<c01290fc>] ? kthread+0x39/0x61
> [<c01290c3>] ? kthread+0x0/0x61
> [<c0103747>] ? kernel_thread_helper+0x7/0x10
> =======================
> ---[ end trace b9faa95810ce9135 ]---
> kgdbts: ERROR PUT: end of test buffer on 'do_fork_test' line 3
> expected do_fork got
> $e201000000b0c6f70000000000000000000000006c1710c01141800054bfc6f7Б^A
> ------------[ cut here ]------------
> WARNING: at drivers/misc/kgdbts.c:721 run_simple_test+0x1de/0x20e()
> Modules linked in:
> Pid: 6, comm: khelper Tainted: G        W 2.6.26-rc1-00279-g28a4acb #12
> [<c011a00a>] warn_on_slowpath+0x41/0x6c
> [<c011aa77>] ? vprintk+0x3e7/0x407
> [<c0119400>] ? do_fork+0x0/0x19e
> [<c012d3da>] ? sched_clock_cpu+0x70/0x88
> [<c0116d4e>] ? cpu_clock+0x115/0x12c
> [<c0119400>] ? do_fork+0x0/0x19e
> [<c011aaac>] ? printk+0x15/0x17
> [<c011aaac>] ? printk+0x15/0x17
> [<c02ae228>] run_simple_test+0x1de/0x20e
> [<c02adc15>] kgdbts_put_char+0x14/0x16
> [<c013d7ba>] put_packet+0x6b/0xbb
> [<c013e8bc>] kgdb_handle_exception+0xa19/0xb21
> [<c010e9e3>] kgdb_notify+0x103/0x140
> [<c035ac89>] notifier_call_chain+0x2b/0x4a
> [<c035accd>] __atomic_notifier_call_chain+0x25/0x36
> [<c035acea>] atomic_notifier_call_chain+0xc/0xe
> [<c012cd15>] notify_die+0x2d/0x2f
> [<c0359303>] __die+0x61/0xc6
> [<c0103dec>] die+0x87/0x106
> [<c035aae1>] do_page_fault+0x4e3/0x59d
> [<c035a5fe>] ? do_page_fault+0x0/0x59d
> [<c010176c>] ? kernel_thread+0x73/0x7b
> [<c0359102>] error_code+0x6a/0x70
> [<c010176c>] ? kernel_thread+0x73/0x7b
> [<c01263d1>] ? ____call_usermodehelper+0x0/0xe7
> [<c01263d1>] ? ____call_usermodehelper+0x0/0xe7
> [<c0103740>] ? kernel_thread_helper+0x0/0x10
> [<c0126236>] ? __call_usermodehelper+0x33/0x4d
> [<c0126686>] ? run_workqueue+0xba/0x187
> [<c012664c>] ? run_workqueue+0x80/0x187
> [<c0126203>] ? __call_usermodehelper+0x0/0x4d
> [<c0126ea6>] ? worker_thread+0x80/0x8c
> [<c01291bd>] ? autoremove_wake_function+0x0/0x30
> [<c0126e26>] ? worker_thread+0x0/0x8c
> [<c01290fc>] ? kthread+0x39/0x61
> [<c01290c3>] ? kthread+0x0/0x61
> [<c0103747>] ? kernel_thread_helper+0x7/0x10
> =======================
> ---[ end trace b9faa95810ce9135 ]---
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth

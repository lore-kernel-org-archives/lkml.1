Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbYJTImI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYJTImI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 04:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbYJTIlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 04:41:55 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:1610 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYJTIly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 04:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E4ltbR51xmH9HLhGk3ubSZs5wjiJOmlvlMGdoiKMxqxbZoMaIB0svxHDbKfqEIULku
         7yIJgnRGcR6VJwo0OO56y65utj2htrv+G6gqyrGF+23+sbjX5gYlhrzEp0UblcRxTdVS
         N7ZImMD36VINQ1Y2aBgA4G7ollZc4yszi6sFo=
Message-ID: <331b791d0810200141w6f8449c8mb56bd2f2e12a03ff@mail.gmail.com>
Date: Mon, 20 Oct 2008 10:41:52 +0200
From: "Thibaut BOYER" <tboyer.dev@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Oops with PREEMPT-RT on 2.6.26.5-rt9
In-Reply-To: <331b791d0810200043t40c35142q8781ec28d16fbc07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <331b791d0810200043t40c35142q8781ec28d16fbc07@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get the following Oops each time I'm loading a (home-made) driver.
The Oops seems to happen because of rt_down or rt_down_timeout. (I
didn't find exactly which one was responsible of that)
Does someone have any idea of this Oops origin ?

Thanks for your help
TB

Here is the output of dmesg, after the command insmod cp16xx.ko :

cp16xx_init: calls pci_module_init()
cp16xx_pci_probe: begin
cp16xx_init_pci: begin
cp16xx_init_pci: bar1 start=0xed040000 size=0x10000
cp16xx_init_pci: bar2 start=0xea800000 size=0x10000
cp16xx_init_pci: bar3 start=0xea000000 size=0x800000
cp16xx_init_pci: bar4 start=0xec000000 size=0x1000000
cp16xx_init_pci: bar5 start=0xe8000000 size=0x2000000
cp16xx_init_pci: virtual address register_bar_ptr 0xde980000
cp16xx_init_pci: virtual address dpram_bar_ptr 0xdf200000
cp16xx_init_pci: virtual address dpram_config_area_ptr 0xdf300000
cp16xx_init_pci: swi_version=0x20051600(must be 0x2005xxxx)
cp16xx_init_pci: got PNIO phys 13510000, virt d3510000, size 0x10000
cp16xx_init_pci: got TRACE phys 134ec000, virt d34ec000, size 0x408
cp16xx_l2_get_dma_pool: l2eth_dma_page_order=7, pages = log2N =128
cp16xx_l2_get_dma_pool: got L2 phys 00c00000, virt c0c00000, size 0x80000
cp16xx_init_pci: end
cp16xx_pci_probe: got major 253 allocated
cp16xx_dprlib_setup: begin
cp16xx_dprlib_setup: end
cp16xx_init_irq: begin
cp16xx_init_irq: request irq 18, card 0xde830000
cp16xx_init_irq: request irq 18  -> OK
cp16xx_init_irq: end
cp16xx_daemon_start: create new kernel thread
cp16xx_daemon: begin
cp16xx_daemon: start wait for FW to be ready
DPRLIB_start: ->DPRLIB_start
dprlib_init_dpram: -> init_dpram
dprlib_start_threads: -> start_thread
dprlib_start_all_tasks_and_semaphores: start
dprlib_start_all_tasks_and_semaphores: Semaphores are created, now
begin to create threads
dprlib_proc: start
dprlib_proc: wait
cp16xx_pci_probe: end
cp16xx_init: end
dprlib_start_all_tasks_and_semaphores: exit
dprlib_start_threads: start_thread <-
dprlib_trigger_intr: IRQ Host->FW, C=0xa5a070a0, M=0xa5a07777, MRC=0xa5a07777
dprlib_init_dpram: wait till config interrupt comes from FW (init_dpram)
dprlib_proc: wait END
dprlib_config_proc: start
dprlib_config_proc: exit
dprlib_proc: wait
dprlib_init_dpram: interrupt coming from FW (init_dpram)
dprlib_init_dpram: Driver version 0x79, FW version 0x71
dprlib_init_channels: -> init_channels
dprlib_init_channels: *** we're before rt_down loop ***
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<00000000>]
*pde = 00000000
Oops: 0000 [#1] PREEMPT
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in: cp16xx(P) e100 mii

Pid: 5, comm: sirq-timer/0 Tainted: P          (2.6.26.5-rt9-ipipe #2)
EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
EIP is at 0x0
EAX: dc11df0c EBX: 00000000 ECX: 00000001 EDX: 00000000
ESI: dc11df0c EDI: c0498e20 EBP: ddc29f58 ESP: ddc29f40
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 preempt:00000001
Process sirq-timer/0 (pid: 5, ti=ddc29000 task=ddc44d80 task.ti=ddc29000)
Stack: c0133e3a 00000000 c0498ea4 00000202 c050af80 fffffffd ddc29f6c c0134a38
       c050af80 ddc29f6c 00000202 ddc29fa0 c0126452 00000001 00000002 c050aab0
       ddc29f88 c013da9b ddc29fa0 00000046 00000002 00000002 c050aab0 fffffffd
Call Trace:
 [<c0133e3a>] ? run_hrtimer_pending+0x5a/0x110
 [<c0134a38>] ? hrtimer_run_pending+0x48/0xe0
 [<c0126452>] ? run_timer_softirq+0x82/0x2c0
 [<c013da9b>] ? trace_hardirqs_on+0xb/0x10
 [<c012298d>] ? ksoftirqd+0x10d/0x230
 [<c0122880>] ? ksoftirqd+0x0/0x230
 [<c0130716>] ? kthread+0x46/0x80
 [<c01306d0>] ? kthread+0x0/0x80
 [<c0103cf3>] ? kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:ddc29f40
---[ end trace ce167a848c96a955 ]---

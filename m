Return-Path: <linux-kernel-owner+w=401wt.eu-S1762020AbYDUQ1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020AbYDUQ1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYDUQ04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:26:56 -0400
Received: from ns.theshore.net ([67.18.92.50]:46350 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbYDUQ0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:26:55 -0400
Message-ID: <480CC04C.2020100@theshore.net>
Date: Mon, 21 Apr 2008 12:26:52 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: pvops - xen - unable to handle kernel paging request
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen: 3.2.1-rc5 64bit
dom0: 2.6.16.38 PAE
domU: 2.6.25 PAE	

BUG: unable to handle kernel paging request at 15c38554
IP: [<c0103195>] xen_make_pte+0x45/0x50
Oops: 0000 [#1] SMP
Modules linked in:

Pid: 3105, comm: java Not tainted (2.6.25-linode9 #1)
EIP: 0061:[<c0103195>] EFLAGS: 00010246 CPU: 0
EIP is at xen_make_pte+0x45/0x50
EAX: c06e3000 EBX: 80000555 ECX: 55555555 EDX: 55555555
ESI: 00000065 EDI: 00000555 EBP: 00000000 ESP: d4fadef0
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
Process java (pid: 3105, ti=d4fac000 task=d4f04ef0 task.ti=d4fac000)
Stack: 80000555 55555060 c01620da b7f0d000 00000071 d4d51ff0 00000000 
000b7f0c
        00000000 c051c60a c012c3e0 c06b4574 05633ebe b7f0c000 d5f4d85c 
03dfa0e0
        00000000 d4e40900 00000070 00000001 00000000 d4f9d010 d4fa4df8 
c129f26c
Call Trace:
  [<c01620da>] mprotect_fixup+0x3da/0x600
  [<c051c60a>] _spin_lock_irq+0xa/0x30
  [<c012c3e0>] run_timer_softirq+0x130/0x190
  [<c0162489>] sys_mprotect+0x189/0x240
  [<c0106bce>] syscall_call+0x7/0xb
  =======================
Code: 3d 82 e3 63 c0 00 89 ca 74 1c 89 d0 31 d2 0f a4 c2 0c c1 e0 0c 89 
d3 09 f0 89 c1 83 e1 e7 89 da 89 c8 5b 5e c3 90 a1 9c 8a 6a c0 <8b> 14 
88 81 e2 ff ff ff 7f eb d4 83 ec 0c 89 74 24 04 89 c6 83
EIP: [<c0103195>] xen_make_pte+0x45/0x50 SS:ESP 0069:d4fadef0
---[ end trace d31c003629c776dd ]---
------------[ cut here ]------------
Kernel BUG at c0113a9b [verbose debug info unavailable]
invalid opcode: 0000 [#2] SMP
Modules linked in:

Pid: 3105, comm: java Tainted: G      D  (2.6.25-linode9 #1)
EIP: 0061:[<c0113a9b>] EFLAGS: 00010002 CPU: 0
EIP is at paravirt_enter_lazy_cpu+0x1b/0x20
EAX: c069e16c EBX: d4e40900 ECX: 00000001 EDX: 00c37000
ESI: c060c200 EDI: 00000000 EBP: d4f04ef0 ESP: d4fadc0c
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
Process java (pid: 3105, ti=d4fac000 task=d4f04ef0 task.ti=d4fac000)
Stack: c051ac80 00000002 d4fadc3c d4fadc34 00000000 d4f05050 d4f05050 
c12d8e80
        00000000 05633e7e 0000ffff 00000000 00000000 00000000 d4e40934 
00000002
        d4f04ef0 d4fadc7c c051c0c5 d4e4093c c051c69c 00000000 00000000 
d4e40934
Call Trace:
  [<c051ac80>] schedule+0x150/0x5f0
  [<c051c0c5>] rwsem_down_failed_common+0x95/0x1a0
  [<c051c69c>] _spin_unlock_irqrestore+0xc/0x10
  [<c051c21d>] rwsem_down_read_failed+0x1d/0x24
  [<c051c287>] call_rwsem_down_read_failed+0x7/0xc
  [<c051b91a>] down_read+0xa/0x10
  [<c0140bfe>] futex_wake+0x2e/0x100
  [<c0141bdc>] do_futex+0xdc/0xb90
  [<c03728a6>] memmove+0x36/0x50
  [<c039412b>] scrup+0x8b/0x110
  [<c013a807>] atomic_notifier_call_chain+0x17/0x20
  [<c039407d>] notify_update+0x1d/0x30
  [<c039518d>] vt_console_print+0x1ed/0x2d0
  [<c0394fa0>] vt_console_print+0x0/0x2d0
  [<c0122dee>] __call_console_drivers+0x5e/0x70
  [<c051c69c>] _spin_unlock_irqrestore+0xc/0x10
  [<c014272d>] sys_futex+0x9d/0x130
  [<c0123830>] vprintk+0x1c0/0x390
  [<c012073f>] mm_release+0x7f/0x90
  [<c01248d2>] exit_mm+0x12/0xe0
  [<c012636c>] do_exit+0x14c/0x6d0
  [<c0123a1b>] printk+0x1b/0x20
  [<c010857f>] die+0x17f/0x180
  [<c0115624>] do_page_fault+0x564/0xa20
  [<c015a70b>] __do_fault+0x1ab/0x4d0
  [<c01150c0>] do_page_fault+0x0/0xa20
  [<c051c932>] error_code+0x72/0x78
  [<c0103195>] xen_make_pte+0x45/0x50
  [<c01620da>] mprotect_fixup+0x3da/0x600
  [<c051c60a>] _spin_lock_irq+0xa/0x30
  [<c012c3e0>] run_timer_softirq+0x130/0x190
  [<c0162489>] sys_mprotect+0x189/0x240
  [<c0106bce>] syscall_call+0x7/0xb
  =======================
Code: b8 01 00 00 00 e9 d6 ff ff ff 8d b6 00 00 00 00 64 8b 15 10 e1 69 
c0 b8 6c e1 69 c0 8b 0c 10 85 c9 75 08 c7 04 10 02 00 00 00 c3 <0f> 0b 
eb fe 90 b8 02 00 00 00 e9 a6 ff ff ff 8d b6 00 00 00 00
EIP: [<c0113a9b>] paravirt_enter_lazy_cpu+0x1b/0x20 SS:ESP 0069:d4fadc0c
---[ end trace d31c003629c776dd ]---
Fixing recursive fault but reboot is needed!

-Chris

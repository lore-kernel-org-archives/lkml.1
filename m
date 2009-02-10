Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbZBJFln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbZBJFln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 00:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZBJFle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 00:41:34 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56429 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZBJFld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 00:41:33 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Message-Id: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 14:41:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I periodically test kernel on stress workload.
Unfortunately, recent kerenel don't survive >24H.

It paniced with following stack.
Do you have any suggestions?

thanks!


My test box:
  CPU: ia64 x8
  MEM: 8GB (4GB x2node)


=================================================================
PQ-muneda login: Unable to handle kernel paging request at virtual address a040000000403400
etex[669958]: Oops 8813272891392 [1]
Modules linked in: binfmt_misc nls_iso8859_1 nls_cp437 dm_multipath scsi_dh fan sg e100 thermal button container processor mii dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod lpfc mptspi mptscsih mptbase ehci_hcd ohci_hcd uhci_hcd usbcore

Pid: 669958, CPU 2, comm:                 etex
psr : 0000101008026038 ifs : 800000000000028a ip  : [<a0000001001c45e0>]    Not tainted (2.6.29-rc3)
ip is at kfree+0x40/0x2a0
unat: 0000000000000000 pfs : 0000000000000205 rsc : 0000000000000003
rnat: 00000000498f1c7b bsps: 0000000000000000 pr  : 00000000005655ab
ldrs: 0000000000000000 ccv : 0000000000000130 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000100123210 b6  : a0000001001231e0 b7  : a000000100014d20
f6  : 1003e006caf999642a000 f7  : 1003e000000000183c978
f8  : 1003e0000000080000000 f9  : 100099ba0000000000000
f10 : 10014d28eb1b735286a15 f11 : 1003e000000000034a3ac
r1  : a000000100f680c0 r2  : 000000000000012f r3  : 0000000000403400
r8  : 00000000000100d0 r9  : a0000001001231e0 r10 : e000000002b6d148
r11 : a000000100d69018 r12 : e00000408a78fe20 r13 : e00000408a780000
r14 : 0000000000000130 r15 : a040000000000000 r16 : ffffffffdead4ead
r17 : 00000000dead4ead r18 : a000000100cd2274 r19 : a000000100d796b8
r20 : 0000000000004000 r21 : 0000000000004000 r22 : 000000000000000a
r23 : a0000001009a95b8 r24 : a0000001000ec2a0 r25 : e00001600999b1e0
r26 : 0000000000004000 r27 : e000000001116a48 r28 : 0000000000000002
r29 : e00000408a780d54 r30 : 0000000000004000 r31 : 0000000000004000

Call Trace:
 [<a000000100017780>] show_stack+0x80/0xa0
                                sp=e00000408a78f9f0 bsp=e00000408a781418
 [<a000000100018080>] show_regs+0x880/0x8c0
                                sp=e00000408a78fbc0 bsp=e00000408a7813b8
 [<a000000100040290>] die+0x1b0/0x2e0
                                sp=e00000408a78fbc0 bsp=e00000408a781370
 [<a0000001007add90>] ia64_do_page_fault+0x810/0xb00
                                sp=e00000408a78fbc0 bsp=e00000408a781310
 [<a00000010000c860>] ia64_native_leave_kernel+0x0/0x270
                                sp=e00000408a78fc50 bsp=e00000408a781310
 [<a0000001001c45e0>] kfree+0x40/0x2a0
                                sp=e00000408a78fe20 bsp=e00000408a7812c0
 [<a000000100123210>] free_user_ns+0x30/0x60
                                sp=e00000408a78fe20 bsp=e00000408a7812a0
 [<a00000010037a320>] kref_put+0xe0/0x100
                                sp=e00000408a78fe20 bsp=e00000408a781278
 [<a0000001000c5bf0>] free_uid+0x110/0x1a0
                                sp=e00000408a78fe20 bsp=e00000408a781250
 [<a0000001000ec340>] put_cred_rcu+0xa0/0xe0
                                sp=e00000408a78fe30 bsp=e00000408a781228
 [<a00000010012db90>] __rcu_process_callbacks+0x2f0/0x580
                                sp=e00000408a78fe30 bsp=e00000408a7811e0
 [<a00000010012de70>] rcu_process_callbacks+0x50/0xc0
                                sp=e00000408a78fe30 bsp=e00000408a7811c0
 [<a0000001000b7ac0>] __do_softirq+0x220/0x320
                                sp=e00000408a78fe30 bsp=e00000408a781120
 [<a0000001000b7c30>] do_softirq+0x70/0xc0
                                sp=e00000408a78fe30 bsp=e00000408a7810c0
 [<a0000001000b7d00>] irq_exit+0x80/0xa0
                                sp=e00000408a78fe30 bsp=e00000408a7810a8
 [<a000000100014600>] ia64_handle_irq+0x1e0/0x400
                                sp=e00000408a78fe30 bsp=e00000408a781030
 [<a00000010000c860>] ia64_native_leave_kernel+0x0/0x270
                                sp=e00000408a78fe30 bsp=e00000408a781030
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..


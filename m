Return-Path: <linux-kernel-owner+w=401wt.eu-S1761673AbXFAOwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673AbXFAOwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759785AbXFAOv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:51:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43763 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761410AbXFAOv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:51:58 -0400
Date: Fri, 1 Jun 2007 10:51:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: udev-095 problem with gregkh-all-2.6.22-rc3
Message-ID: <Pine.LNX.4.44L0.0706011043240.2556-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg and Kay:

When I boot 2.6.22-rc3 plus gregkh-all-2.6.22-rc3.patch, with an FC6
system (which includes a no-doubt somewhat altered version of udev
095), I get the follow message:

[   32.898870] kernel BUG at block/ll_rw_blk.c:3728!
[   32.898922] invalid opcode: 0000 [#1]
[   32.898971] PREEMPT SMP 
[   32.899088] Modules linked in: evdev e100 ohci_hcd ehci_hcd mii uhci_hcd usbcore
[   32.899433] CPU:    0
[   32.899435] EIP:    0060:[<c01c6770>]    Not tainted VLI
[   32.899437] EFLAGS: 00010246   (2.6.22-rc3 #1)
[   32.899590] EIP is at put_io_context+0x12/0x7c
[   32.899642] eax: cf0391e0   ebx: cf0391e0   ecx: cf1be000   edx: c01cccd4
[   32.899698] esi: 00000010   edi: cf13b480   ebp: cf1bff4c   esp: cf1bff44
[   32.899753] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[   32.899808] Process start_udev (pid: 948, ti=cf1be000 task=cf13b480 task.ti=cf1be000)
[   32.899864] Stack: c02a6727 cf0391e0 cf1bff58 c01c9364 cf1bff80 cf1bff94 c012439e cf643478 
[   32.900242]        cf1bffb0 c011979c 00000001 00000000 00000001 cf13b534 c010402c cf1bff80 
[   32.900620]        cf1bff80 cf0d11c0 00000000 00575284 cf1bffa8 c0124436 00000000 00575284 
[   32.900997] Call Trace:
[   32.901086]  [<c0104fa1>] show_trace_log_lvl+0x1a/0x2f
[   32.901177]  [<c0105053>] show_stack_log_lvl+0x9d/0xa5
[   32.901265]  [<c0105248>] show_registers+0x1ed/0x32c
[   32.901354]  [<c0105497>] die+0x110/0x211
[   32.901440]  [<c0105622>] do_trap+0x8a/0xa3
[   32.901527]  [<c010598d>] do_invalid_op+0x88/0x92
[   32.901614]  [<c02a6aaa>] error_code+0x72/0x78
[   32.901703]  [<c01c9364>] exit_io_context+0x6d/0x70
[   32.901792]  [<c012439e>] do_exit+0x6bd/0x6e5
[   32.901881]  [<c0124436>] sys_exit_group+0x0/0x11
[   32.901968]  [<c0124445>] sys_exit_group+0xf/0x11
[   32.902055]  [<c0103f5a>] sysenter_past_esp+0x5f/0x99
[   32.902144]  =======================
[   32.902192] Code: ff eb 14 89 90 c0 01 00 00 89 90 c4 01 00 00 89 88 90 00 00 00 31 c0 c9 c3 55 89 e5 53 83 ec 04 89 c3 85 c0 74 6b 83 38 00 75 04 <0f> 0b eb fe 90 ff 08 0f 94 c0 84 c0 74 58 b8 01 00 00 00 e8 86 
[   32.904543] EIP: [<c01c6770>] put_io_context+0x12/0x7c SS:ESP 0068:cf1bff44
[   32.904718] Fixing recursive fault but reboot is needed!

This doesn't happen under vanilla 2.6.22-rc3.

Is this udev's fault or is it a problem in the kernel?  If it is udev's 
fault, is it fixed in more recent versions?

Alan Stern


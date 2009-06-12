Return-Path: <linux-kernel-owner+w=401wt.eu-S932499AbZFLRrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbZFLRrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZFLRrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:47:13 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:64443 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbZFLRrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:47:12 -0400
Date: Fri, 12 Jun 2009 18:12:08 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Subject: [BUG 2.6.30] Panic in rt2860sta when disabling wireless (eeepc)
Message-ID: <506FC67D10%linux@youmustbejoking.demon.co.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org, gregkh@suse.de, Darren Salt 
 <linux@youmustbejoking.demon.co.uk>
User-Agent: Messenger-Pro/2.58.3.3080 (Qt/4.5.1) (Linux-x86_64)
X-NuLabour-Date: Fri, 8960 Dec 1984 18:12:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the following panic when I disable wireless on my 901 if the
interface is associated: Fn-F2 with current eeepc-acpi-scripts git reliably
triggers it, as does writing 0 to /etc/class/rfkill/rfkill0/state.

(I've also noticed that, should this panic occur while X is active,
inteldrmfb doesn't quite manage to switch back to text mode and not all of
the text may be sent via netconsole.)


BUG: unable to handle kernel NULL pointer dereference at 0000000f
IP: [<c02f1c87>] RTMPWriteTxDescriptor+0xd/0x3f
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/LNXSYSTM:00/device:00/ASUS010:00/rfkill/rfkill0/state
Modules linked in: rfcomm l2cap bluetooth joydev uvcvideo videodev v4l1_compat

Pid: 174, comm: kacpi_notify Not tainted (2.6.30-eee901 #2) 901
EIP: 0060:[<c02f1c87>] EFLAGS: 00010202 CPU: 1
EIP is at RTMPWriteTxDescriptor+0xd/0x3f
EAX: f87c2000 EBX: 00000000 ECX: 00000001 EDX: 00000000
ESI: 00000000 EDI: 0000002a EBP: 00000000 ESP: f7229de0
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kacpi_notify (pid: 174, ti=f7228000 task=f70bac60 task.ti=f7228000)
Stack:
 00000000 f87c2000 c032c632 00000000 f6759430 f87c2000 00000001 c02f38cf
 f6759420 0000002a f6745480 031f5096 f87c5980 00745480 f6759420 00000001
 00000001 0000002a f6759420 0000002a f6759420 f87c2000 f670a800 00000000
Call Trace:
 [<c032c632>] ? RtmpPCIMgmtKickOut+0x3a/0xc7
 [<c02f38cf>] ? MlmeHardTransmitMgmtRing+0x263/0x278
 [<c02f3dba>] ? MiniportMMRequest+0x103/0x16d
 [<c0307692>] ? MlmeDisassocReqAction+0x116/0x1a2
 [<c031bf8b>] ? rt28xx_close+0xe8/0x1ef
 [<c0214fd0>] ? acpi_os_execute_deferred+0x0/0x25
 [<c031c119>] ? MainVirtualIF_close+0x2e/0x39
 [<c0369a1b>] ? dev_close+0x5b/0x73
 [<c0369a9f>] ? rollback_registered+0x6c/0xda
 [<c0369b3c>] ? unregister_netdevice+0x2f/0x54
 [<c0369b70>] ? unregister_netdev+0xf/0x15
 [<c040e9d2>] ? rt2860_remove_one+0x30/0x82
 [<c020247a>] ? pci_device_remove+0x16/0x35
 [<c027fb15>] ? __device_release_driver+0x42/0x60
 [<c027fbc8>] ? device_release_driver+0x15/0x1e
 [<c027f8f9>] ? bus_remove_device+0x55/0x60
 [<c027e0bb>] ? device_del+0xe9/0x125
 [<c027e0ff>] ? device_unregister+0x8/0x10
 [<c01fee10>] ? pci_stop_dev+0x20/0x3a
 [<c01feec1>] ? pci_remove_bus_device+0x9/0x8f
 [<c032d20f>] ? eeepc_rfkill_notify+0x9f/0xbd
 [<c02210dd>] ? acpi_ev_notify_dispatch+0x4c/0x55
 [<c0214fed>] ? acpi_os_execute_deferred+0x1d/0x25
 [<c012cef4>] ? worker_thread+0x106/0x192
 [<c012f430>] ? autoremove_wake_function+0x0/0x2b
 [<c012cdee>] ? worker_thread+0x0/0x192
 [<c012f360>] ? kthread+0x42/0x6a
 [<c012f31e>] ? kthread+0x0/0x6a
 [<c010321f>] ? kernel_thread_helper+0x7/0x10
Code: 00 03 45 28 8a 53 07 88 43 06 0f b6 c4 83 e0 0f 83 e2 f0 09 c2 88 53 07 58 5b 5e 5f 5d c3 56 89 d6 83 a0 28 f0 01 00 ef 84 c9 53 <8a> 5e 0f 0f 95 c1 8a 54 24 0c 83 e3 f8 83 e2 03 09 cb 01 d2 09 
EIP: [<c02f1c87>] RTMPWriteTxDescriptor+0xd/0x3f SS:ESP 0068:f7229de0
CR2: 000000000000000f
---[ end trace f918b4539928a58c ]---
Kernel panic - not syncing: Fatal exception in interrupt

-- 
| Darren Salt      | linux at youmustbejoking | nr. Ashington, | Doon
| Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + Output less CO2 => avoid massive flooding.    TIME IS RUNNING OUT *FAST*.

I am not young enough to know everything.

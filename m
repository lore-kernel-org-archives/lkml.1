Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYGVL0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYGVL0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYGVLZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:25:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:6685 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYGVLZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:25:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lLWrohl2Kybs/Wa5tQJLIhvxgcBWLkMCTtNgdQ2klvFWoZbeQnEzxYOMnWJSb1Nyd+
         N1te3eHjkOt4ywfwskg84K1+Sv3+b7CVbSmc5rbwNWmje3UIowFvdg8tKgsw0WvS+vWw
         pYDEbeafr7xFYM3QquqzpzDyLj7OQdQmOCQVs=
Message-ID: <f1c9d250807220425w693a0692s4662ca624b2c343e@mail.gmail.com>
Date: Tue, 22 Jul 2008 16:55:49 +0530
From: Tej <bewith.tej@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: PANIC with linux-next-2.6.26-next-20080718
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080721132027.GD28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f1c9d250807210348w58aa132che5543cb30a33ee60@mail.gmail.com>
	 <20080721132027.GD28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 6:50 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Jul 21, 2008 at 04:18:35PM +0530, Tej Parkash wrote:
>> while testing linux-next with commit
>> "commit 43a2c1df777e18dfb0ba48d03b4f8b8ff80f1b57"
>> Author: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date:   Fri Jul 18 19:27:47 2008 +1000
>>
>> machine hang with the following panic. config/cpuinfo/lspci are attached.
>> trying git-bisect.
>
> Apply the patch below or try the current linux-next where vfs-next is
> rebased on top of net-next with that sucker folded in.
>

after applying the patch suggested by you, kernel panic with different
message. same config used.

mesg captured on serial console:
--snip--
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/inp3
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 21 (level, low) -> IRQ 21
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.17.
modprobe: FATAL: Could not load /lib/modules/2.6.26-next-20080718/modules.dep: y

modprobe used greatest stack depth: 7012 bytes left
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ALSA device list:
  #0: HDA Intel at 0x50220000 irq 22
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Starting balanced_irq
Using IPI No-Shortcut mode
registered taskstats version 1
  Magic number: 0:149:12
usb_host usb_host1: hash matches
------------[ cut here ]------------
kernel BUG at security/selinux/avc.c:883!
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file:
Modules linked in:

Pid: 1, comm: swapper Not tainted (2.6.26-next-20080718 #23)
EIP: 0060:[<c02e8680>] EFLAGS: 00010246 CPU: 1
EIP is at avc_has_perm_noaudit+0x19/0x2d7
EAX: 00000001 EBX: 00000006 ECX: 00000006 EDX: 00000003
ESI: f7812370 EDI: f7877e20 EBP: f7877e04 ESP: f7877db0
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f7876000 task=f7878000 task.ti=f7876000)
Stack: f7877dc0 0006c058 00000003 00000001 00000001 00000000 00000000 f740ab00
       f7877efc f7877dfc c028aebd f7877e64 f74020b0 00000004 019ff37b f78f0001
       019ff37b f740ab00 00000006 f7812370 f7877e20 f7877e40 c02e9313 00000000
Call Trace:
 [<c028aebd>] ? __d_lookup+0x9b/0xd7
 [<c02e9313>] ? avc_has_perm+0x22/0x43
 [<c02846d8>] ? __link_path_walk+0x953/0xa66
 [<c02e9ddd>] ? inode_has_perm+0x5e/0x68
 [<c02ec76a>] ? selinux_inode_permission+0xff/0x108
 [<c02e6f15>] ? security_inode_permission+0x1a/0x20
 [<c0282609>] ? permission+0xc8/0xdc
 [<c028263f>] ? vfs_permission+0x10/0x12
 [<c027b31a>] ? sys_faccessat+0xb7/0x152
 [<c022670e>] ? insert_resource+0x24/0x15a
 [<c022ec60>] ? flush_cpu_workqueue+0x2a/0x66
 [<c07456b1>] ? pci_mmcfg_insert_resources+0xc1/0xf6
 [<c027b3c5>] ? sys_access+0x10/0x12
 [<c072364a>] ? kernel_init+0x223/0x247
 [<c0748602>] ? tcp_congestion_default+0x0/0xf
 [<c021d429>] ? schedule_tail+0x19/0x48
 [<c020376a>] ? ret_from_fork+0x6/0x1c
 [<c0723427>] ? kernel_init+0x0/0x247
 [<c0723427>] ? kernel_init+0x0/0x247
 [<c0204427>] ? kernel_thread_helper+0x7/0x10
 =======================
Code: b6 7d c0 89 55 ec eb bb 83 c4 14 89 f8 5b 5e 5f 5d c3 55 89 e5 57 56 53 8
EIP: [<c02e8680>] avc_has_perm_noaudit+0x19/0x2d7 SS:ESP 0068:f7877db0
---[ end trace 7ce084a488fdd36e ]---
usb usb3: suspend_rh (auto-stop)
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D   2.6.26-next-20080718 #23
 [<c02215b1>] panic+0x3f/0xe1
 [<c0223fa8>] do_exit+0x5b/0x720
 [<c0221fa6>] ? printk+0x15/0x17
 [<c022136e>] ? print_oops_end_marker+0x1e/0x23
 [<c0204b14>] die+0x127/0x12f
 [<c0554a30>] do_trap+0x8a/0xa3
 [<c0204b93>] ? do_invalid_op+0x0/0x76
 [<c0204bff>] do_invalid_op+0x6c/0x76
 [<c02e8680>] ? avc_has_perm_noaudit+0x19/0x2d7
 [<c02e932a>] ? avc_has_perm+0x39/0x43
 [<c0554732>] error_code+0x72/0x78
 [<c02e8680>] ? avc_has_perm_noaudit+0x19/0x2d7
 [<c028aebd>] ? __d_lookup+0x9b/0xd7
 [<c02e9313>] avc_has_perm+0x22/0x43
 [<c02846d8>] ? __link_path_walk+0x953/0xa66
 [<c02e9ddd>] inode_has_perm+0x5e/0x68
 [<c02ec76a>] selinux_inode_permission+0xff/0x108
 [<c02e6f15>] security_inode_permission+0x1a/0x20
usb usb4: suspend_rh (auto-stop)
 [<c0282609>] permission+0xc8/0xdc
 [<c028263f>] vfs_permission+0x10/0x12
 [<c027b31a>] sys_faccessat+0xb7/0x152
 [<c022670e>] ? insert_resource+0x24/0x15a
 [<c022ec60>] ? flush_cpu_workqueue+0x2a/0x66
 [<c07456b1>] ? pci_mmcfg_insert_resources+0xc1/0xf6
 [<c027b3c5>] sys_access+0x10/0x12
 [<c072364a>] kernel_init+0x223/0x247
 [<c0748602>] ? tcp_congestion_default+0x0/0xf
 [<c021d429>] ? schedule_tail+0x19/0x48
 [<c020376a>] ? ret_from_fork+0x6/0x1c
 [<c0723427>] ? kernel_init+0x0/0x247
 [<c0723427>] ? kernel_init+0x0/0x247
 [<c0204427>] kernel_thread_helper+0x7/0x10
 =======================


As suggested by you latest

thanks
tej parkashlinux-next20080721  is not showing the same panic but a
differnt panic.

BUG: Int 14: CR2 b0017833
     EDI 00000082 ESI 00000000 EBP c059be88 ESP c059be5c
     EBX f000ec62 EDX 0000000e ECX c0595480 EAX f000ec62
     err 00000000 EIP c0181ca0  CS 00000060 flg 00010082

Below link suggested a patch to solve the bug, after applying the
patch the machine booted normally
http://lkml.org/lkml/2008/7/14/444

sorry for some noise.

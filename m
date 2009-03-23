Return-Path: <linux-kernel-owner+w=401wt.eu-S1759641AbZCWQz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbZCWQz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbZCWQzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:55:19 -0400
Received: from bytemail.bytemark.co.uk ([212.110.161.227]:39115 "EHLO
	bytemail.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbZCWQzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:55:18 -0400
X-Greylist: delayed 1570 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2009 12:55:17 EDT
Message-ID: <49C7B8D0.8050804@bytemark.co.uk>
Date: Mon, 23 Mar 2009 16:29:04 +0000
From: Peter Taphouse <pete@bytemark.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Soft lockups/crashes with 2.6.27/2.6.28
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

We run a number of dual opteron machines with 2.6.27 or 2.6.28 (vanilla
from www.kernel.org) and roughly once per week or so a handful of them
start to output the following type of message to syslog (over the
network) before becoming unresponsive.  ssh will stop answering, and
there's no output on the serial console that we've got them hooked up to
- - though a sysrq to reboot them can be successful.

There are a few different userspace processes that can cause the soft
lockup, and they start being emmitted anything up to 30 minutes before
the machine fully dies.  The kernel is 64bit, the userspace 32bit - and
the machines all have 32G RAM with 2x Opteron 2300 series CPUs, and
they're each running a number of kvm guests.

The correlation between crashing and not crashing seems to be the amount
of guests that are running, though we're not oversubscribing the memory
and so we're working around by unloading some of the machines.

On one machine I was logged on at the time and managed to trigger an
oops by running "iptables -L -n".

Does anyone have any ideas where to start debugging this one?  I've got
plenty more of the kernel backtraces...

TIA,

kernel: [745740.540752] BUG: soft lockup - CPU#3 stuck for 61s!
[iptables:15729]\n
kernel: [745740.540752] Modules linked in: sg ip6table_filter ip6_tables
tun kvm_amd kvm xt_NOTRACK ipt_addrtype iptable_raw ipt_REJECT xt_state
xt_tcpudp iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
 nf_conntrack iptable_filter ip_tables x_tables loop reiserfs ext2
bonding ipv6 3w_xxxx rtc button evdev i2c_nforce2 shpchp i2c_core
pci_hotplug pcspkr dm_mirror dm_log dm_snapshot dm_mod ata_generic ehci_h
cd ohci_hcd thermal processor fan thermal_sys sata_nv 3w_9xxx forcedeth
sd_mod raid1 md_mod\n
kernel: [745740.540752] CPU 3:\n
kernel: [745740.540752] Modules linked in: sg ip6table_filter ip6_tables
tun kvm_amd kvm xt_NOTRACK ipt_addrtype iptable_raw ipt_REJECT xt_state
xt_tcpudp iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
 nf_conntrack iptable_filter ip_tables x_tables loop reiserfs ext2
bonding ipv6 3w_xxxx rtc button evdev i2c_nforce2 shpchp i2c_core
pci_hotplug pcspkr dm_mirror dm_log dm_snapshot dm_mod ata_generic ehci_h
cd ohci_hcd thermal processor fan thermal_sys sata_nv 3w_9xxx forcedeth
sd_mod raid1 md_mod\n
kernel: [745740.540752] Pid: 15729, comm: iptables Not tainted 2.6.27.19
#1\n
kernel: [745740.540752] RIP: 0010:[<ffffffff80262ea7>]
[<ffffffff80262ea7>] csd_flag_wait+0x7/0x10\n
kernel: [745740.540752] RSP: 0000:ffff880284801c40  EFLAGS: 00000202\n
kernel: [745740.540752] RAX: 00000000000008fc RBX: 0000000000000007 RCX:
0000000000000001\n
kernel: [745740.540752] RDX: 00000000000000fc RSI: 00000000000008fc RDI:
ffff88028bc8aac0\n
kernel: [745740.540752] RBP: 0000000009019000 R08: 0000000000000000 R09:
ffffffff807276b0\n
kernel: [745740.540752] R10: 0000000000000000 R11: ffffffff80225420 R12:
ffffffff80229952\n
kernel: [745740.540752] R13: ffff88026e1facc0 R14: ffff88041d0db960 R15:
ffff880284801c68\n
kernel: [745740.540752] FS:  0000000000000000(0000)
GS:ffff88041e48d5c0(0063) knlGS:00000000f7da26c0\n
kernel: [745740.540752] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b\n
kernel: [745740.540752] CR2: 000000000901c000 CR3: 0000000284daf000 CR4:
00000000000006e0\n
kernel: [745740.540752] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000\n
kernel: [745740.540752] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400\n
kernel: [745740.540752] \n
kernel: [745740.540752] Call Trace:\n
kernel: [745740.540752]  [<ffffffff8026328d>] ?
smp_call_function_mask+0x13d/0x240\n
kernel: [745740.540752]  [<ffffffff804edd7a>] ? error_exit+0x0/0x70\n
kernel: [745740.540752]  [<ffffffff802a1b31>] ?
unmap_kernel_range+0x2c1/0x330\n
kernel: [745740.540752]  [<ffffffff8021e230>] ? do_flush_tlb_all+0x0/0x30\n
kernel: [745740.540752]  [<ffffffff8024495d>] ? on_each_cpu+0x1d/0x50\n
kernel: [745740.540752]  [<ffffffff802a1c07>] ? remove_vm_area+0x67/0x80\n
kernel: [745740.540752]  [<ffffffff802a1ccf>] ? __vunmap+0x2f/0xc0\n
kernel: [745740.540752]  [<ffffffffa01b55b8>] ?
compat_do_ipt_get_ctl+0x348/0x370 [ip_tables]\n
kernel: [745740.540752]  [<ffffffff80486f1a>] ?
compat_nf_sockopt+0x6a/0xf0\n
kernel: [745740.540752]  [<ffffffff80492a5b>] ?
compat_ip_getsockopt+0xbb/0xe0\n
kernel: [745740.540752]  [<ffffffff80477054>] ?
compat_sys_getsockopt+0x74/0x1d0\n
kernel: [745740.540752]  [<ffffffff804eda6b>] ?
_spin_lock_irqsave+0x2b/0x40\n
kernel: [745740.540752]  [<ffffffff80477a3c>] ?
compat_sys_socketcall+0x18c/0x1e0\n
kernel: [745740.540752]  [<ffffffff8022e544>] ? ia32_sysret+0x0/0xa\n
kernel: [745740.540752] \n



- --
Peter Taphouse

Bytemark Hosting
http://www.bytemark.co.uk/
tel. +44 (0) 845 004 3 004
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJx7jQIAZ7OKeBB58RAp3UAJ9wxFXforkHMVlbCBKuFt4PRGe2nACfeT1G
TPORp8o0trbY/qojMapNSjM=
=9gSo
-----END PGP SIGNATURE-----

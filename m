Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZJAJoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZJAJoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZJAJop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:44:45 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:45320 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbZJAJoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:44:44 -0400
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: NULL pointer dereference / tty subsystem? / 2.6.31.1/ still persists, in stable .1 release too
Content-Disposition: inline
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
Date: Thu, 1 Oct 2009 12:44:01 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910011244.01851.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.31.1
x86 , 32-bit
gcc 4.4.1

Workload - busy pppoe server, but probably it is not related.
CPU Core 2 Quad

Here is panic message, but it is mixed with syslog (seems), syslog message 
starting from "kernel:"
Seems triggered by busybox login process?


[64130.463884] BUG: unable to handle kernel
NULL pointer dereference
at 00000003
[64130.463942] IP:
[<c025080c>] add_echo_byte+0x94/0x9b
[64130.463988] *pdpt = 0000000029004001
*pde = 0000000000000000
Sep 29 08:58:10 194.146.155.70
[64130.464044] Oops: 0002 [#1]
SMP
Sep 29 08:58:10 194.146.155.70
[64130.464084] last sysfs file: /sys/devices/virtual/vc/vcsa3/dev
[64130.464127] Modules linked in:
netconsole
configfs
act_skbedit
sch_ingress
sch_prio
cls_flow
cls_u32
em_meta
cls_basic
xt_dscp
xt_DSCP
ipt_REJECT
ts_bm
xt_string
xt_hl
ifb
cls_fw
sch_tbf
sch_htb
act_ipt
act_mirred
xt_MARK
slhc
xt_TCPMSS
xt_mark
xt_tcpudp
iptable_mangle
iptable_nat
nf_nat
nf_conntrack_ipv4
nf_conntrack
rtc_cmos
rtc_core
rtc_lib
nf_defrag_ipv4
iptable_filter
ip_tables
x_tables
8021q
garp
stp
llc
loop
usb_storage
mtdblock
mtd_blkdevs
mtd
e1000e
iTCO_wdt
iTCO_vendor_support
pata_acpi
ata_piix
ata_generic
libata
sr_mod
cdrom
tulip
r8169
sky2
via_velocity
via_rhine
sis900
ne2k_pci
8390
skge
tg3
libphy
8139too
e1000
e100
usbhid
ohci_hcd
uhci_hcd
ehci_hcd
usbcore
nls_base
Sep 29 08:58:10 194.146.155.70
[64130.464757]
[64130.464790] Pid: 22690, comm: login Not tainted (2.6.31.1-build-0047 #8)
[64130.464818] EIP: 0060:[<c025080c>] EFLAGS: 00010206 CPU: 1
[64130.464818] EIP is at add_echo_byte+0x94/0x9b
[64130.464818] EAX: 00000000 EBX: eeca1069 ECX: 00000003 EDX: 00000069
[64130.464818] ESI: 00000069 EDI: 00000069 EBP: f49e2d6c ESP: f49e2d64
[64130.464818]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[64130.464818] Process login (pid: 22690, ti=f49e2000 task=e93b2b80 
task.ti=f49e2000)
[64130.464818] Stack:
[64130.464818]  eeca1069
eeca1000
f49e2d84
c0250d09
eeca13dc
eeca1000
00000000
eeca1000
Sep 29 08:58:10 194.146.155.70
[64130.464818] <0>
f49e2e94
c0252181
eeca1000
26fc795e
c502a9e0
eeca13f8
e93b2b80
f4ab341c
Sep 29 08:58:10 194.146.155.70
[64130.464818] <0>
9e59f746
00002f6d
f4ab341e
f4ab351f
00002f6d
00000042
c01231e1
eeca1120
Sep 29 08:58:10 194.146.155.70
[64130.464818] Call Trace:
[64130.464818]  [<c0250d09>] ? echo_char+0x5b/0x69
[64130.464818]  [<c0252181>] ? n_tty_receive_buf+0x41b/0x10a5
[64130.464818]  [<c01231e1>] ? dequeue_task_fair+0x184/0x18c
[64130.464818]  [<c02fbcc2>] ? schedule+0x75d/0x7c7
[64130.464818]  [<c0170734>] ? filemap_fault+0x69/0x2e5
[64130.464818]  [<c0253dc3>] ? tty_ldisc_try+0x36/0x3c
[64130.464818]  [<c0254958>] ? flush_to_ldisc+0xf1/0x17f
[64130.464818]  [<c0254a44>] ? tty_flush_to_ldisc+0xd/0xf
[64130.464818]  [<c0251930>] ? n_tty_read+0x2ac/0x5ad
[64130.464818]  [<c01293e5>] ? default_wake_function+0x0/0xd
[64130.464818]  [<c0251684>] ? n_tty_read+0x0/0x5ad
[64130.464818]  [<c024e212>] ? tty_read+0x62/0x99
[64130.464818]  [<c024e1b0>] ? tty_read+0x0/0x99
[64130.464818]  [<c0190e4a>] ? vfs_read+0x87/0x110
[64130.464818]  [<c0190f6c>] ? sys_read+0x3b/0x60
[64130.464818]  [<c0102975>] ? syscall_call+0x7/0xb
[64130.464818] Code:
00
ff
0f
00
00
80
8a
4c
01
00
00
40
eb
15
89
c1
40
03
8a
8c
03
00
00
89
82
90
03
00
00
81
e1
ff
0f
00
00
8b
82
88
03
00
00
89
f2
Sep 29 08:58:10 194.146.155.70
14
08
5b
5e
5d
c3
55
89
c1
83
b8
b4
00
00
00
00
89
e5
74
26
Sep 29 08:58:10 194.146.155.70
[64130.464818] EIP: [<c025080c>]
add_echo_byte+0x94/0x9b
SS:ESP 0068:f49e2d64
[64130.464818] CR2: 0000000000000003
kernel: [64130.463884] BUG: unable to handle kernel NULL pointer dereference 
at 00000003
kernel: [64130.463942] IP: [<c025080c>] add_echo_byte+0x94/0x9b
kernel: [64130.463988] *pdpt = 0000000029004001 *pde = 0000000000000000
kernel: [64130.464044] Oops: 0002 [#1] SMP
kernel: [64130.464084] last sysfs file: /sys/devices/virtual/vc/vcsa3/dev
kernel: [64130.464127] Modules linked in: netconsole configfs act_skbedit 
sch_ingress sch_prio cls_flow cls_u32 em_meta cls_basic xt_dscp xt_DSCP 
ipt_REJECT ts_bm xt_strin
g xt_hl ifb cls_fw sch_tbf sch_htb act_ipt act_mirred xt_MARK pp
kernel: [64130.464757]
kernel: [64130.464790] Pid: 22690, comm: login Not tainted 
(2.6.31.1-build-0047 #8)
kernel: [64130.464818] EIP: 0060:[<c025080c>] EFLAGS: 00010206 CPU: 1
kernel: [64130.464818] EIP is at add_echo_byte+0x94/0x9b
kernel: [64130.464818] EAX: 00000000 EBX: eeca1069 ECX: 00000003 EDX: 00000069
[64130.467376] ---[ end trace 2aeb2797ef9a99d4 ]---
kernel: [64130.464818] ESI: 00000069 EDI: 00000069 EBP: f49e2d6c ESP: f49e2d64
kernel: [64130.464818]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
kernel: [64130.464818] Process login (pid: 22690, ti=f49e2000 task=e93b2b80 
task.ti=f49e2000)
kernel: [64130.464818] Stack:
kernel: [64130.464818]  eeca1069 eeca1000 f49e2d84 c0250d09 eeca13dc eeca1000 
00000000 eeca1000
kernel: [64130.464818] <0> f49e2e94 c0252181 eeca1000 26fc795e c502a9e0 
eeca13f8 e93b2b80 f4ab341c
kernel: [64130.464818] <0> 9e59f746 00002f6d f4ab341e f4ab351f 00002f6d 
00000042 c01231e1 eeca1120
kernel: [64130.464818] Call Trace:
kernel: [64130.464818]  [<c0250d09>] ? echo_char+0x5b/0x69
kernel: [64130.464818]  [<c0252181>] ? n_tty_receive_buf+0x41b/0x10a5
kernel: [64130.464818]  [<c01231e1>] ? dequeue_task_fair+0x184/0x18c
[64130.467477] Kernel panic - not syncing: Fatal exception
kernel: [64130.464818]  [<c02fbcc2>] ? schedule+0x75d/0x7c7
kernel: [64130.464818]  [<c0170734>] ? filemap_fault+0x69/0x2e5
kernel: [64130.464818]  [<c0253dc3>] ? tty_ldisc_try+0x36/0x3c
kernel: [64130.464818]  [<c0254958>] ? flush_to_ldisc+0xf1/0x17f
kernel: [64130.464818]  [<c0254a44>] ? tty_flush_to_ldisc+0xd/0xf
kernel: [64130.464818]  [<c0251930>] ? n_tty_read+0x2ac/0x5ad
kernel: [64130.464818]  [<c01293e5>] ? default_wake_function+0x0/0xd
kernel: [64130.464818]  [<c0251684>] ? n_tty_read+0x0/0x5ad
kernel: [64130.464818]  [<c024e212>] ? tty_read+0x62/0x99
kernel: [64130.464818]  [<c024e1b0>] ? tty_read+0x0/0x99
kernel: [64130.464818]  [<c0190e4a>] ? vfs_read+0x87/0x110
[64130.467554] Pid: 22690, comm: login Tainted: G      D    
2.6.31.1-build-0047 #8
kernel: [64130.464818]  [<c0190f6c>] ? sys_read+0x3b/0x60
kernel: [64130.464818]  [<c0102975>] ? syscall_call+0x7/0xb
kernel: [64130.464818] Code: 00 ff 0f 00 00 80 8a 4c 01 00 00 40 eb 15 89 c1 
40 03 8a 8c 03 00 00 89 82 90 03 00 00 81 e1 ff 0f 00 00 8b 82 88 03 00 00 89 
f2 <88> 14 08 5b
 5e 5d c3 55 89 c1 83 b8 b4 00 00 00 00 89 e5 74 26
kernel: [64130.464818] EIP: [<c025080c>] add_echo_byte+0x94/0x9b SS:ESP 
0068:f49e2d64
kernel: [64130.464818] CR2: 0000000000000003
kernel: [64130.467376] ---[ end trace 2aeb2797ef9a99d4 ]---
kernel: [64130.467477] Kernel panic - not syncing: Fatal exception
kernel: [64130.467554] Pid: 22690, comm: login Tainted: G      D    
2.6.31.1-build-0047 #8
kernel: [64130.467671] Call Trace:
[64130.467671] Call Trace:
[64130.467772]  [<c02fb2f0>] ? printk+0xf/0x17
[64130.467889]  [<c02fb241>] panic+0x39/0xd9
[64130.467945]  [<c01059b7>] oops_end+0x8b/0x9a
[64130.468003]  [<c0118f49>] no_context+0x13d/0x147
[64130.468076]  [<c0119066>] __bad_area_nosemaphore+0x113/0x11b
kernel: [64130.467772]  [<c02fb2f0>] ? printk+0xf/0x17
kernel: [64130.467889]  [<c02fb241>] panic+0x39/0xd9
kernel: [64130.467945]  [<c01059b7>] oops_end+0x8b/0x9a
kernel: [64130.468003]  [<c0118f49>] no_context+0x13d/0x147
kernel: [64130.468076]  [<c0119066>] __bad_area_nosemaphore+0x113/0x11b
kernel: [64130.468144]  [<c024d417>] ? extract_buf+0x78/0xc8
[64130.468144]  [<c024d417>] ? extract_buf+0x78/0xc8
[64130.468281]  [<c01190ae>] bad_area+0x30/0x39
[64130.468340]  [<c0119334>] do_page_fault+0x16b/0x26f
[64130.468419]  [<c01191c9>] ? do_page_fault+0x0/0x26f
[64130.468507]  [<c02fd346>] error_code+0x66/0x6c
[64130.468569]  [<c01191c9>] ? do_page_fault+0x0/0x26f
[64130.468631]  [<c025080c>] ? add_echo_byte+0x94/0x9b
[64130.468687]  [<c0250d09>] echo_char+0x5b/0x69
[64130.468760]  [<c0252181>] n_tty_receive_buf+0x41b/0x10a5
[64130.468825]  [<c01231e1>] ? dequeue_task_fair+0x184/0x18c
[64130.468890]  [<c02fbcc2>] ? schedule+0x75d/0x7c7
[64130.468948]  [<c0170734>] ? filemap_fault+0x69/0x2e5
[64130.469013]  [<c0253dc3>] ? tty_ldisc_try+0x36/0x3c
[64130.469074]  [<c0254958>] flush_to_ldisc+0xf1/0x17f
[64130.469141]  [<c0254a44>] tty_flush_to_ldisc+0xd/0xf
kernel: [64130.468281]  [<c01190ae>] bad_area+0x30/0x39
kernel: [64130.468340]  [<c0119334>] do_page_fault+0x16b/0x26f
kernel: [64130.468419]  [<c01191c9>] ? do_page_fault+0x0/0x26f
kernel: [64130.468507]  [<c02fd346>] error_code+0x66/0x6c
kernel: [64130.468569]  [<c01191c9>] ? do_page_fault+0x0/0x26f
kernel: [64130.468631]  [<c025080c>] ? add_echo_byte+0x94/0x9b
kernel: [64130.468687]  [<c0250d09>] echo_char+0x5b/0x69
kernel: [64130.468760]  [<c0252181>] n_tty_receive_buf+0x41b/0x10a5
kernel: [64130.468825]  [<c01231e1>] ? dequeue_task_fair+0x184/0x18c
kernel: [64130.468890]  [<c02fbcc2>] ? schedule+0x75d/0x7c7
kernel: [64130.468948]  [<c0170734>] ? filemap_fault+0x69/0x2e5
[64130.469212]  [<c0251930>] n_tty_read+0x2ac/0x5ad
kernel: [64130.469013]  [<c0253dc3>] ? tty_ldisc_try+0x36/0x3c
kernel: [64130.469074]  [<c0254958>] flush_to_ldisc+0xf1/0x17f
kernel: [64130.469141]  [<c0254a44>] tty_flush_to_ldisc+0xd/0xf
kernel: [64130.469212]  [<c0251930>] n_tty_read+0x2ac/0x5ad
[64130.469295]  [<c01293e5>] ? default_wake_function+0x0/0xd
[64130.469365]  [<c0251684>] ? n_tty_read+0x0/0x5ad
[64130.469420]  [<c024e212>] tty_read+0x62/0x99
[64130.469483]  [<c024e1b0>] ? tty_read+0x0/0x99
[64130.469562]  [<c0190e4a>] vfs_read+0x87/0x110
[64130.469620]  [<c0190f6c>] sys_read+0x3b/0x60
[64130.469678]  [<c0102975>] syscall_call+0x7/0xb
[64130.469741] Rebooting in 5 seconds..

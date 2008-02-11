Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbYBKDTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbYBKDTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 22:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYBKDTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 22:19:41 -0500
Received: from qult.net ([82.238.217.46]:42936 "EHLO slartibartfast.qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYBKDTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 22:19:39 -0500
Date: Mon, 11 Feb 2008 04:19:35 +0100
From: Ignacy Gawedzki <lkml@qult.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Oops with hostap_pci (?)
Message-ID: <20080211031935.GA12563@zenon.in.qult.net>
Mail-Followup-To: Ignacy Gawedzki <lkml@qult.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

A few days back I started having strange lockups on a gateway machine so I
started looking at things.  Then I compiled the 2.6.24.1 kernel and started
having oopses not long after upping the wlan0 (hostap_pci) interface.

So I enabled netconsole and got a few logs.  Now the sad point is that I'm
getting an oops even with my older kernel which used to be fine (2.6.23.9).  I
also checked with 2.6.24 and the effects are the same: I boot, I up the wlan0
interface and a few seconds or minutes later, boom!  Sometimes only rmmod'ing
hostap_pci triggers the oops.  I'm suspecting some hardware problem and have
already checked the ram with memtest86+ and tested with only one memory module
out of two plugged: same thing.

If anybody could take a look at these and shed some light on that issue...

Thanks a lot,

Ignacy

-- 
Save the whales. Feed the hungry. Free the mallocs. 

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="oops1.txt"

With kernel 2.6.24.1

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
printing eip: f08f50c2 *pde = 00000000 
Oops: 0000 [#1] 
Modules linked in: lirc_serial(F) lirc_dev cls_fw sch_prio sch_htb iptable_nat xt_limit xt_state ipt_REJECT xt_tcpudp ipt_LOG xt_DSCP xt_dscp xt_mark nf_conntrack_ipv4 xt_CONNMARK xt_MARK iptable_mangle iptable_filter ip_tables x_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack ipv6 evdev hostap_pci i2c_viapro hostap via686a ieee80211_crypt ide_cd

Pid: 0, comm: swapper Tainted: GF       (2.6.24.1 #5)
EIP: 0060:[<f08f50c2>] EFLAGS: 00010297 CPU: 0
EIP is at hostap_80211_rx+0x41d/0xecf [hostap]
EAX: eec28460 EBX: 00000000 ECX: eec28444 EDX: 00000000
ESI: efbb8434 EDI: 00000000 EBP: efbb843e ESP: c0419e74
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c0418000 task=c03e4300 task.ti=c0418000)
Stack: 00000000 00000080 0000004c 00000001 c0419f2c c0419f30 ef3ab760 00000018 
       00000100 eec28444 00001148 00000040 0000c9c0 00000001 ef8d3370 00002a40 
       04b1cd93 000a1e00 00001148 013a1148 685b0900 ef8d3000 1f714b23 685b0900 
Call Trace:
 [<f090ffca>] hostap_rx_tasklet+0x11f/0x145 [hostap_pci]
 [<c011e399>] run_timer_softirq+0x11/0x12f
 [<c011bbbc>] tasklet_action+0x32/0x52
 [<c011bb24>] __do_softirq+0x35/0x75
 [<c011bb86>] do_softirq+0x22/0x26
 [<c011bdb3>] irq_exit+0x29/0x58
 [<c0105bc0>] do_IRQ+0x58/0x6b
 [<c010455b>] common_interrupt+0x23/0x28
 [<c013007b>] mod_sysfs_init+0x17/0x6d
 [<c011007b>] arch_setup_additional_pages+0x121/0x13a
 [<c023f4a0>] acpi_processor_idle+0x244/0x3c4
 [<c01024fc>] cpu_idle+0x43/0x5d
 [<c041a9ac>] start_kernel+0x237/0x23c
 [<c041a303>] unknown_bootoption+0x0/0x195
 =======================
Code: 0a 8b 4c 24 24 8b 59 1c eb 21 83 bb d8 00 00 00 04 75 16 8d 83 dc 00 00 00 b9 06 00 00 00 89 ea e8 0b d1 91 cf 85 c0 74 18 89 fb <8b> 3b 0f 18 07 90 8b 44 24 24 83 c0 1c 39 c3 75 ce e9 44 0a 00 
EIP: [<f08f50c2>] hostap_80211_rx+0x41d/0xecf [hostap] SS:ESP 0068:c0419e74
Kernel panic - not syncing: Fatal exception in interrupt
wlan0ap: SW TICK stuck? bits=0x0 EvStat=8001 IntEn=e018

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="oops2.txt"

With kernel 2.6.24.1

BUG: unable to handle kernel paging request at virtual address abdb24ce
printing eip: f08ea0c2 *pde = 00000000 
Oops: 0000 [#1] 
Modules linked in: cls_fw sch_prio sch_htb iptable_nat xt_limit xt_state ipt_REJECT xt_tcpudp ipt_LOG xt_DSCP xt_dscp xt_mark nf_conntrack_ipv4 xt_CONNMARK xt_MARK iptable_mangle iptable_filter ip_tables x_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack ipv6 evdev hostap_pci i2c_viapro via686a hostap ieee80211_crypt ide_cd

Pid: 0, comm: swapper Not tainted (2.6.24.1 #5)
EIP: 0060:[<f08ea0c2>] EFLAGS: 00010202 CPU: 0
EIP is at hostap_80211_rx+0x41d/0xecf [hostap]
EAX: efa68460 EBX: abdb24ce ECX: efa68444 EDX: 00000000
ESI: ef1e1034 EDI: abdb24ce EBP: ef1e103e ESP: c0419e74
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c0418000 task=c03e4300 task.ti=c0418000)
Stack: 00000000 00000080 c045358c 00000001 c0453570 c0419f30 eec598e0 00000018 
       00000100 efa68444 00001148 00000040 00001f90 00000001 eec29370 00005a40 
       0080ce43 000a1e00 00001148 013a1148 685b0900 eec29000 1f714b23 685b0900 
Call Trace:
 [<f0904fca>] hostap_rx_tasklet+0x11f/0x145 [hostap_pci]
 [<c011bbbc>] tasklet_action+0x32/0x52
 [<c011bb24>] __do_softirq+0x35/0x75
 [<c011bb86>] do_softirq+0x22/0x26
 [<c011bdb3>] irq_exit+0x29/0x58
 [<c0105bc0>] do_IRQ+0x58/0x6b
 [<c010455b>] common_interrupt+0x23/0x28
 [<c013007b>] mod_sysfs_init+0x17/0x6d
 [<c011007b>] arch_setup_additional_pages+0x121/0x13a
 [<c023f4a0>] acpi_processor_idle+0x244/0x3c4
 [<c01024fc>] cpu_idle+0x43/0x5d
 [<c041a9ac>] start_kernel+0x237/0x23c
 [<c041a303>] unknown_bootoption+0x0/0x195
 =======================
Code: 0a 8b 4c 24 24 8b 59 1c eb 21 83 bb d8 00 00 00 04 75 16 8d 83 dc 00 00 00 b9 06 00 00 00 89 ea e8 0b 81 92 cf 85 c0 74 18 89 fb <8b> 3b 0f 18 07 90 8b 44 24 24 83 c0 1c 39 c3 75 ce e9 44 0a 00 
EIP: [<f08ea0c2>] hostap_80211_rx+0x41d/0xecf [hostap] SS:ESP 0068:c0419e74
Kernel panic - not syncing: Fatal exception in interrupt
wlan0ap: SW TICK stuck? bits=0x0 EvStat=8001 IntEn=e018

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="oops3.txt"

With kernel 2.6.24

BUG: unable to handle kernel paging request at virtual address 630e0021
printing eip: f08f20c2 *pde = 00000000 
Oops: 0000 [#1] 
Modules linked in: cls_fw sch_prio sch_htb iptable_nat xt_limit xt_state ipt_REJECT xt_tcpudp ipt_LOG xt_DSCP xt_dscp xt_mark nf_conntrack_ipv4 xt_CONNMARK xt_MARK iptable_mangle iptable_filter ip_tables x_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack ipv6 evdev hostap_pci hostap ieee80211_crypt i2c_viapro via686a ide_cd

Pid: 0, comm: swapper Not tainted (2.6.24 #1)
EIP: 0060:[<f08f20c2>] EFLAGS: 00010206 CPU: 0
EIP is at hostap_80211_rx+0x41d/0xecf [hostap]
EAX: efb20460 EBX: 630e0021 ECX: efb20444 EDX: 00000000
ESI: eed83234 EDI: 630e0021 EBP: eed8323e ESP: c041be74
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c041a000 task=c03e7300 task.ti=c041a000)
Stack: 00000000 00000080 00000000 00000080 00000282 c041bf30 eed74e20 00000018 
       00000100 efb20444 00001148 00000040 0000dd50 00000001 ef8cc370 00002a40 
       153bcee9 000a1e00 00001148 013a1148 685b0900 ef8cc000 1f714b23 685b0900 
Call Trace:
 [<f090cfca>] hostap_rx_tasklet+0x11f/0x145 [hostap_pci]
 [<c011e621>] process_timeout+0x0/0x5
 [<c011e470>] run_timer_softirq+0xe0/0x12f
 [<c011bbc4>] tasklet_action+0x32/0x52
 [<c011bb2c>] __do_softirq+0x35/0x75
 [<c011bb8e>] do_softirq+0x22/0x26
 [<c011bdbb>] irq_exit+0x29/0x58
 [<c0105bc0>] do_IRQ+0x58/0x6b
 [<c010455b>] common_interrupt+0x23/0x28
 [<c013007b>] mod_sysfs_init+0xf/0x6d
 [<c011007b>] arch_setup_additional_pages+0x121/0x13a
 [<c024178c>] acpi_processor_idle+0x244/0x3c4
 [<c01024fc>] cpu_idle+0x43/0x5d
 [<c041c9ac>] start_kernel+0x237/0x23c
 [<c041c303>] unknown_bootoption+0x0/0x195
 =======================
Code: 0a 8b 4c 24 24 8b 59 1c eb 21 83 bb d8 00 00 00 04 75 16 8d 83 dc 00 00 00 b9 06 00 00 00 89 ea e8 f3 23 92 cf 85 c0 74 18 89 fb <8b> 3b 0f 18 07 90 8b 44 24 24 83 c0 1c 39 c3 75 ce e9 44 0a 00 
EIP: [<f08f20c2>] hostap_80211_rx+0x41d/0xecf [hostap] SS:ESP 0068:c041be74
Kernel panic - not syncing: Fatal exception in interrupt
wlan0ap: SW TICK stuck? bits=0x0 EvStat=8001 IntEn=e018

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="oops4.txt"

With kernel 2.6.23.9

BUG: unable to handle kernel paging request at virtual address 0a000000
 printing eip:
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: cls_fw sch_prio sch_htb iptable_nat xt_limit xt_state ipt_REJECT xt_tcpudp ipt_LOG xt_DSCP xt_dscp xt_mark nf_conntrack_ipv4 xt_CONNMARK xt_MARK iptable_mangle iptable_filter ip_tables x_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack nfnetlink ipv6 hostap_pci i2c_viapro hostap ieee80211_crypt via686a evdev ide_cd
CPU:    0
EIP:    0060:[<f08f71a6>]    Not tainted VLI
EFLAGS: 00010216   (2.6.23.9 #4)
EIP is at hostap_80211_rx+0x451/0xf87 [hostap]
eax: dfcdc4a0   ebx: 0a000000   ecx: efb0743e   edx: 00000000
esi: efb07434   edi: 0a000000   ebp: 00001148   esp: c0409e7c
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=c0408000 task=c03d7280 task.ti=c0408000)
Stack: c04414c0 922b85ff 00000004 ee7edae0 c0409eb8 c0113bbf 00000000 c044148c 
       00000000 c0409f2c dfde34a0 00000018 00000100 dfcdc484 00001148 00000040 
       00006710 dfcdc000 efd993b0 0000001c dfcdc000 dfcdc3b0 00000000 efb0743e 
Call Trace:
 [<c0113bbf>] enqueue_entity+0x1d2/0x1f3
 [<f08eafd0>] hostap_rx_tasklet+0x11f/0x145 [hostap_pci]
 [<c011b8c4>] tasklet_action+0x32/0x52
 [<c011b82c>] __do_softirq+0x35/0x75
 [<c011b88e>] do_softirq+0x22/0x26
 [<c011babb>] irq_exit+0x29/0x58
 [<c0105e54>] do_IRQ+0x58/0x6c
 [<c0128a76>] getnstimeofday+0x2b/0xad
 [<c0104567>] common_interrupt+0x23/0x28
 [<c023c8e1>] acpi_safe_halt+0x14/0x20
 [<c023ca8f>] acpi_processor_idle+0x136/0x39b
 [<c0102344>] cpu_idle+0x43/0x5d
 [<c040a9c0>] start_kernel+0x237/0x23c
 [<c040a317>] unknown_bootoption+0x0/0x195
 =======================
Code: 44 24 34 8b 58 1c eb 23 83 bb d8 00 00 00 04 75 18 8b 54 24 5c 8d 83 dc 00 00 00 b9 06 00 00 00 e8 1b 99 91 cf 85 c0 74 18 89 fb <8b> 3b 0f 18 07 90 8b 44 24 34 83 c0 1c 39 c3 75 cc e9 c9 0a 00 
EIP: [<f08f71a6>] hostap_80211_rx+0x451/0xf87 [hostap] SS:ESP 0068:c0409e7c
Kernel panic - not syncing: Fatal exception in interrupt
wlan0ap: SW TICK stuck? bits=0x0 EvStat=8001 IntEn=e018

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="oops5.txt"

With kernel 2.6.23.9

BUG: unable to handle kernel paging request at virtual address 666565d1
 printing eip:
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: cls_fw sch_prio sch_htb iptable_nat xt_limit xt_state ipt_REJECT xt_tcpudp ipt_LOG xt_DSCP xt_dscp xt_mark nf_conntrack_ipv4 xt_CONNMARK xt_MARK iptable_mangle iptable_filter ip_tables x_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack nfnetlink ipv6 hostap_pci i2c_viapro via686a hostap ieee80211_crypt evdev ide_cd
CPU:    0
EIP:    0060:[<e08fa967>]    Not tainted VLI
EFLAGS: 00010202   (2.6.23.9 #4)
EIP is at hostap_remove_interface+0xe/0x7d [hostap]
eax: 00000001   ebx: 6665642d   ecx: 00000001   edx: 00000000
esi: 00000000   edi: dfd31400   ebp: def61280   esp: d5ffdef4
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process rmmod (pid: 5170, ti=d5ffc000 task=d641dab0 task.ti=d5ffc000)
Stack: 6f697270 defa2484 e090aaa3 e08d4000 defa2000 dfd31400 e090bdcc dfd31400 
       e0914190 c03eab20 d5ffc000 c0218b48 dfd31448 c02639f7 dfd31448 e0914190 
       c0263dcf e0914190 00000000 c02635e9 e09143e0 e0914160 bfa9f3c0 c0218bdd 
Call Trace:
 [<e090aaa3>] prism2_free_local_data+0x33/0x1f5 [hostap_pci]
 [<e090bdcc>] prism2_pci_remove+0x3f/0x82 [hostap_pci]
 [<c0218b48>] pci_device_remove+0x16/0x35
 [<c02639f7>] __device_release_driver+0x6e/0x8b
 [<c0263dcf>] driver_detach+0x59/0x96
 [<c02635e9>] bus_remove_driver+0x57/0x75
 [<c0218bdd>] pci_unregister_driver+0xc/0x45
 [<c01309be>] sys_delete_module+0x154/0x17a
 [<c013f4f6>] remove_vma+0x31/0x36
 [<c0103b56>] sysenter_past_esp+0x5f/0x85
 [<c0320000>] svc_process+0x19a/0x696
 =======================
Code: eb 13 31 c0 eb 0f 89 d0 83 c8 01 66 89 44 24 26 e9 2a fe ff ff 83 c4 28 5b 5e 5f 5d c3 56 89 d6 53 89 c3 85 db 89 c8 74 6e 85 c0 <8b> 8b a4 01 00 00 74 17 8b 11 8b 41 04 89 42 04 89 10 c7 41 04 
EIP: [<e08fa967>] hostap_remove_interface+0xe/0x7d [hostap] SS:ESP 0068:d5ffdef4

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="oops6.txt"

With kernel 2.6.23.9

BUG: unable to handle kernel paging request at virtual address 0a000000
 printing eip:
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: cls_fw sch_prio sch_htb iptable_nat xt_limit xt_state ipt_REJECT xt_tcpudp ipt_LOG xt_DSCP xt_dscp xt_mark nf_conntrack_ipv4 xt_CONNMARK xt_MARK iptable_mangle iptable_filter ip_tables x_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack nfnetlink ipv6 hostap_pci hostap ieee80211_crypt i2c_viapro via686a evdev ide_cd
CPU:    0
EIP:    0060:[<e08f71a6>]    Not tainted VLI
EFLAGS: 00010216   (2.6.23.9 #4)
EIP is at hostap_80211_rx+0x451/0xf87 [hostap]
eax: df8f64a0   ebx: 0a000000   ecx: df33ec3e   edx: 00000000
esi: df33ec34   edi: 0a000000   ebp: 00001148   esp: c0409e80
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=c0408000 task=c03d7280 task.ti=c0408000)
Stack: c04414c0 622a9321 00000004 de33e060 c0409ebc c0113bbf 00000000 c044148c 
       00000000 c0409f30 c1757160 00000018 00000100 df8f6484 00001148 00000040 
       0000d040 df8f6000 df737bb0 0000001c df8f6000 df8f63b0 00000000 df33ec3e 
Call Trace:
 [<c0113bbf>] enqueue_entity+0x1d2/0x1f3
 [<e08eafd0>] hostap_rx_tasklet+0x11f/0x145 [hostap_pci]
 [<c011df6d>] run_timer_softirq+0x11/0x12f
 [<c011b8c4>] tasklet_action+0x32/0x52
 [<c011b82c>] __do_softirq+0x35/0x75
 [<c011b88e>] do_softirq+0x22/0x26
 [<c011babb>] irq_exit+0x29/0x58
 [<c0105e54>] do_IRQ+0x58/0x6c
 [<c012a93d>] tick_notify+0x161/0x220
 [<c0104567>] common_interrupt+0x23/0x28
 [<c0110000>] apply_relocate+0x77/0x95
 [<c023cb88>] acpi_processor_idle+0x22f/0x39b
 [<c0102344>] cpu_idle+0x43/0x5d
 [<c040a9c0>] start_kernel+0x237/0x23c
 [<c040a317>] unknown_bootoption+0x0/0x195
 =======================
Code: 44 24 34 8b 58 1c eb 23 83 bb d8 00 00 00 04 75 18 8b 54 24 5c 8d 83 dc 00 00 00 b9 06 00 00 00 e8 1b 99 91 df 85 c0 74 18 89 fb <8b> 3b 0f 18 07 90 8b 44 24 34 83 c0 1c 39 c3 75 cc e9 c9 0a 00 
EIP: [<e08f71a6>] hostap_80211_rx+0x451/0xf87 [hostap] SS:ESP 0068:c0409e80
Kernel panic - not syncing: Fatal exception in interrupt
wlan0ap: SW TICK stuck? bits=0x0 EvStat=8001 IntEn=e018

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="oops7.txt"

With kernel 2.6.23.9

BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000
0
 printing eip:
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: cls_fw sch_prio sch_htb iptable_nat xt_limit xt_state ipt_REJECT xt_tcpudp ipt_LOG xt_DSCP xt_dscp xt_mark nf_conntrack_ipv4 xt_CONNMARK xt_MARK iptable_mangle iptable_filter ip_tables x_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack nfnetlink ipv6 i2c_viapro hostap_pci hostap via686a ieee80211_crypt evdev ide_cd
CPU:    0
EIP:    0060:[<d08fa1a6>]    Not tainted VLI
EFLAGS: 00010297   (2.6.23.9 #4)
EIP is at hostap_80211_rx+0x451/0xf87 [hostap]
eax: cecfe4a0   ebx: 00000000   ecx: cfa4263e   edx: 00000000
esi: cfa42634   edi: 00000000   ebp: 00001148   esp: c0409e80
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=c0408000 task=c03d7280 task.ti=c0408000)
Stack: 00000000 00000080 00000004 ce289ae0 c0409ebc c0113bbf c044148c c044148c 
       c0441440 c0409f30 cfd51980 00000018 00000100 cecfe484 00001148 00000040 
       000049f0 cecfe000 cfa4dbb0 0000001c cecfe000 cecfe3b0 00000000 cfa4263e 
Call Trace:
 [<c0113bbf>] enqueue_entity+0x1d2/0x1f3
 [<c01278cf>] ktime_get_ts+0x11/0x3a
 [<d08edfd0>] hostap_rx_tasklet+0x11f/0x145 [hostap_pci]
 [<c011b8c4>] tasklet_action+0x32/0x52
 [<c011b82c>] __do_softirq+0x35/0x75
 [<c011b88e>] do_softirq+0x22/0x26
 [<c011babb>] irq_exit+0x29/0x58
 [<c0105e54>] do_IRQ+0x58/0x6c
 [<c012a93d>] tick_notify+0x161/0x220
 [<c0104567>] common_interrupt+0x23/0x28
 [<c0110000>] apply_relocate+0x77/0x95
 [<c023cb88>] acpi_processor_idle+0x22f/0x39b
 [<c0102344>] cpu_idle+0x43/0x5d
 [<c040a9c0>] start_kernel+0x237/0x23c
 [<c040a317>] unknown_bootoption+0x0/0x195
 =======================
Code: 44 24 34 8b 58 1c eb 23 83 bb d8 00 00 00 04 75 18 8b 54 24 5c 8d 83 dc 00 00 00 b9 06 00 00 00 e8 1b 69 91 ef 85 c0 74 18 89 fb <8b> 3b 0f 18 07 90 8b 44 24 34 83 c0 1c 39 c3 75 cc e9 c9 0a 00 
EIP: [<d08fa1a6>] hostap_80211_rx+0x451/0xf87 [hostap] SS:ESP 0068:c0409e80
Kernel panic - not syncing: Fatal exception in interrupt
wlan0ap: SW TICK stuck? bits=0x0 EvStat=8001 IntEn=e018

--VS++wcV0S1rZb1Fb--

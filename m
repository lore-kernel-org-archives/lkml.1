Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZDMJHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZDMJHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 05:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZDMJGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 05:06:49 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:45664 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076AbZDMJGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 05:06:47 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: BUG: unable to handle kernel paging request (mac80211 related??)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 13 Apr 2009 11:04:52 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090413090452.D78D32C4133@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.229.14
X-Scan-Result: No virus found in message 1LtI7e-0000N6-8Q.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1LtI7e-0000N6-8Q 5777cb33eaed07c6f047745f19efd75d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following BUG is the result of
rmmod rt2500pci && modprobe rt2500pci && iwconfig wlan0 txpower auto

The only odd thing that preceeded it was that I (10 minutes earlier), tried to
change the wlan rate algo to minstrel from pid using the 
 /sys/module/mac80211/parameters/ieee80211_default_rc_algo file.

Mac80211 was not a module at the time, and the file went from showing 'pid' to 
nothing, so I'm a bit unsure as to what exacly happened. Is 
/sys/module/*/parameters/* expected to work on non-modules?


rt2500pci 0000:00:0a.0: found PCI INT A -> IRQ 11
phy21 -> rt2500pci_validate_eeprom: EEPROM recovery - NIC: 0xfff0
phy21 -> rt2x00_set_chip: Info - Chipset detected - rt: 0201, rf: 0003, rev: 00000004.
wmaster0 (rt2500pci): not using net_device_ops yet
phy21: Selected rate control algorithm 'pid'
wlan0 (rt2500pci): not using net_device_ops yet
phy21 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
phy21 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
ADDRCONF(NETDEV_UP): wlan0: link is not ready
phy21 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
phy21 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
wlan0: authenticate with AP 00:18:39:c0:5f:50
phy21 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
phy21 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
wlan0: authenticate with AP 00:18:39:c0:5f:50
wlan0: authenticate with AP 00:18:39:c0:5f:50
wlan0: authenticate with AP 00:18:39:c0:5f:50
wlan0: authentication with AP 00:18:39:c0:5f:50 timed out
rt2500pci 0000:00:0a.0: found PCI INT A -> IRQ 11
phy22 -> rt2500pci_validate_eeprom: EEPROM recovery - NIC: 0xfff0
phy22 -> rt2x00_set_chip: Info - Chipset detected - rt: 0201, rf: 0003, rev: 00000004.
wmaster0 (rt2500pci): not using net_device_ops yet
phy22: Selected rate control algorithm 'pid'
wlan0 (rt2500pci): not using net_device_ops yet
phy22 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
phy22 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
ADDRCONF(NETDEV_UP): wlan0: link is not ready
BUG: unable to handle kernel paging request at 8b291c6a
IP: [<cc84d5ad>] 0xcc84d5ad
*pde = 00000000 
Oops: 0002 [#1] 
last sysfs file: /sys/class/net/wlan0/flags
Modules linked in: rt2500pci rtc cdc_wdm rt2x00pci i2c_piix4 intel_agp pcspkr rt2x00lib eeprom_93cx6 uhci_hcd i2c_core agpgar
t evdev [last unloaded: rt2500pci]

Pid: 27810, comm: iwconfig Not tainted (2.6.29.1 #11) HP Vectra
EIP: 0060:[<cc84d5ad>] EFLAGS: 00010246 CPU: 0
EIP is at 0xcc84d5ad
EAX: c5948d20 EBX: c5948d20 ECX: dc84e2e0 EDX: c5948dac
ESI: c5948dac EDI: c5948dfc EBP: 00000000 ESP: cd5cde00
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process iwconfig (pid: 27810, ti=cd5cc000 task=c58c88a0 task.ti=cd5cc000)
Stack:
 dc86f77e c5948d20 c5948160 00000000 dc86eed9 d49e50b4 00000001 c03a07a8
 00008b26 c0353429 c5948160 cd5cdf08 c03544e1 cd5cdf08 ffffffa1 c034d5cc
 00000000 cd5cdef8 c59c2800 c13197a0 c013748e c0161e94 db4d08fc c015f2b7
Call Trace:
 [<dc86f77e>] rt2x00lib_config_antenna+0x74/0xaa [rt2x00lib]
 [<dc86eed9>] rt2x00mac_config+0x4f/0x6d [rt2x00lib]
 [<c0353429>] ieee80211_hw_config+0x7b/0x82
 [<c03544e1>] ieee80211_ioctl_siwtxpower+0x77/0x83
 [<c034d5cc>] ioctl_standard_call+0x49/0x286
 [<c013748e>] file_read_actor+0x79/0xcf
 [<c0161e94>] mnt_want_write+0x8/0x47
 [<c015f2b7>] touch_atime+0xe/0xce
 [<c034d2ad>] wext_handle_ioctl+0x97/0x17e
 [<c035446a>] ieee80211_ioctl_siwtxpower+0x0/0x83
 [<c02bc83f>] dev_ioctl+0x532/0x565
 [<c0135d64>] find_lock_page+0x10/0x42
 [<c0137727>] filemap_fault+0x70/0x2f5
 [<c02b25b4>] sock_ioctl+0x0/0x1d1
 [<c015a8b6>] vfs_ioctl+0x16/0x48
 [<c015ade3>] do_vfs_ioctl+0x40e/0x47f
 [<c0143fdf>] handle_mm_fault+0x1f6/0x462
 [<c02b1372>] sock_map_fd+0x46/0x50
 [<c02b1ce0>] sys_socket+0x3f/0x52
 [<c015ae80>] sys_ioctl+0x2c/0x42
 [<c0102945>] sysenter_do_call+0x12/0x25
 [<c0360000>] __ieee80211_rx_handle_packet+0x24e/0x646
Code: d7 5c 7d 72 35 51 00 00 28 68 5a 4e 68 3c 4e 68 13 4e 75 4d d8 5c 7d 72 36 51 00 00 28 68 86 4e 6a f8 07 00 00 4e 68 88
 4e 75 4d <d9> 5c 7d 72 37 51 00 00 28 68 3c 4e 68 11 4e 68 99 4e 75 4d da 
EIP: [<cc84d5ad>] 0xcc84d5ad SS:ESP 0068:cd5cde00
---[ end trace 469062b162cecfcc ]---





Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZEXMXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZEXMXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 08:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZEXMXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 08:23:40 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:38300 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbZEXMXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 08:23:39 -0400
Message-ID: <4A193C51.7090607@wpkg.org>
Date: Sun, 24 May 2009 14:23:45 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: 2.6.29.1 BUG: unable to handle kernel NULL pointer dereference at
 (null) -> Oops
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This system is running as a kvm-85 guest.

When this happened, IO and CPU load were bigger than usually.

The system is still running and I have some sysstat (sar) statistics for it, 
if anyone has some ideas about it.



BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c01b1ffb>] page_referenced+0xab/0x140
*pdpt = 00000000005ed001 *pde = 0000000000000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/net/eth1/ifindex
Modules linked in: e1000 ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 binfmt_misc loop dm_multipath scsi_dh dm_mod joydev usbhid hid ppdev af_packet virtio_balloon pcspkr evdev sg parport_pc rtc_cmos parport thermal button i2c_piix4 i2c_core uhci_hcd processor usbcore sd_mod iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi scsi_mod ext3 jbd virtio_net virtio_pci virtio_ring virtio crc_t10dif crc32c libcrc32c

Pid: 179, comm: kswapd0 Not tainted (2.6.29.1-server-4mnb #1)
EIP: 0060:[<c01b1ffb>] EFLAGS: 00010202 CPU: 0
EIP is at page_referenced+0xab/0x140
EAX: ed045570 EBX: ffffffc8 ECX: 00000000 EDX: 00000000
ESI: ed045571 EDI: c23d8680 EBP: f5879d4c ESP: f5879d30
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kswapd0 (pid: 179, ti=f5878000 task=f5b10c60 task.ti=f5878000)
Stack:
 00000000 ed045570 f5879d4c 00000001 c23d8680 c23d8698 f5879f70 f5879e10
 c019f08d 003c09dc f5879db0 f5879eb4 f5879dfc f5879dd4 00000000 f5879f70
 00879e10 00000006 00000017 c0514b40 00000001 00000000 00000001 00000001
Call Trace:
 [<c019f08d>] ? shrink_page_list+0x17d/0x730
 [<c019f878>] ? shrink_list+0x238/0x5e0
 [<c01d336c>] ? d_free+0x2c/0x50
 [<c01d3693>] ? __shrink_dcache_sb+0x2a3/0x2d0
 [<c019fe37>] ? shrink_zone+0x217/0x330
 [<c01a069d>] ? kswapd+0x5cd/0x620
 [<c019dfb0>] ? isolate_pages_global+0x0/0x200
 [<c01544b0>] ? autoremove_wake_function+0x0/0x50
 [<c01a00d0>] ? kswapd+0x0/0x620
 [<c015413c>] ? kthread+0x3c/0x70
 [<c0154100>] ? kthread+0x0/0x70
 [<c010b613>] ? kernel_thread_helper+0x7/0x10
Code: 00 00 00 8d 46 ff 89 45 e8 e8 62 a5 21 00 8b 45 e8 85 c0 0f 84 97 00 00 00 8b 47 08 83 c0 01 89 45 f0 8b 45 e8 8b 50 04 8d 5a c8 <8b> 43 38 0f 18 00 90 83 c6 03 89 75 ec 31 f6 39 55 ec 75 1b eb
EIP: [<c01b1ffb>] page_referenced+0xab/0x140 SS:ESP 0068:f5879d30
---[ end trace 03bc6e65c375750f ]---



-- 
Tomasz Chmielewski
http://wpkg.org

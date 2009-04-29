Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbZD2Axm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbZD2Axm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 20:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZD2Axa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 20:53:30 -0400
Received: from host2.marvell.com ([65.219.4.2]:35857 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753491AbZD2Ax3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 20:53:29 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Date: Tue, 28 Apr 2009 18:02:43 -0700
Subject: BUG: sleeping function called from invalid context at
 mm/slub.c:1595 --- "hcitool cc" or "l2ping"
Thread-Topic: BUG: sleeping function called from invalid context at
 mm/slub.c:1595 --- "hcitool cc" or "l2ping"
Thread-Index: AcnIZOezWZs/+VLSTtO89y6j/tLHDA==
Message-ID: <477F20668A386D41ADCC57781B1F704301E3F5C7F5@SC-VEXCH1.marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Apr 2009 00:53:28.0515 (UTC) FILETIME=[E8D24930:01C9C864]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting this error whenever I use "hcitool cc" or "l2ping xx:xx:xx:xx:xx:xx"  command.

Kernel: version 2.6.30-rc3 from bluetooth-testing tree
HCI Tool: version 3.20
Laptop: Lenovo X61s


Did anyone see this already?

Thanks,

Bing

===========================================
# hcitool cc 00:1c:c1:e3:ce:cf
BUG: sleeping function called from invalid context at mm/slub.c:1595
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
Pid: 0, comm: swapper Not tainted 2.6.30-rc3 #2
Call Trace:
 [<c0511f9c>] ? kvasprintf+0x28/0x44
 [<c048ea14>] ? __kmalloc+0xa3/0x168
 [<c0511f9c>] ? kvasprintf+0x28/0x44
 [<c050bf60>] ? kobject_set_name_vargs+0x1e/0x4c
 [<c0582dca>] ? dev_set_name+0x1a/0x1c
 [<f89b9b20>] ? hci_conn_add_sysfs+0x48/0x94 [bluetooth]
 [<f89b70a1>] ? hci_event_packet+0x1e9/0x1b7c [bluetooth]
 [<c049e912>] ? pollwake+0x33/0x39
 [<c041ecee>] ? __wake_up_common+0x2e/0x58
 [<c041ff78>] ? __wake_up_sync_key+0x33/0x49
 [<c05c00f3>] ? sock_def_readable+0x34/0x5e
 [<c05bf48e>] ? sock_queue_rcv_skb+0xaa/0xb1
 [<f89b8d48>] ? hci_send_to_sock+0xd1/0x117 [bluetooth]
 [<f89b3f76>] ? hci_rx_task+0x6b/0x1d9 [bluetooth]
 [<f7d2d3fa>] ? rh_timer_func+0x0/0x5 [usbcore]
 [<c04328c2>] ? run_timer_softirq+0x120/0x189
 [<c063ca45>] ? _spin_lock_irq+0x12/0x15
 [<c043291c>] ? run_timer_softirq+0x17a/0x189
 [<c042f5ee>] ? tasklet_action+0x5b/0xa7
 [<c042f3a5>] ? __do_softirq+0x98/0x13e
 [<c042f30d>] ? __do_softirq+0x0/0x13e
 <IRQ>  [<c042f2e0>] ? irq_exit+0x26/0x53
 [<c040431e>] ? do_IRQ+0x65/0x76
 [<c0403589>] ? common_interrupt+0x29/0x30
 [<c0555efe>] ? acpi_idle_enter_simple+0x130/0x166
 [<c0555c13>] ? acpi_idle_enter_bm+0xcf/0x28a
 [<c05b0682>] ? cpuidle_idle_call+0x5c/0x92
 [<c040217e>] ? cpu_idle+0x46/0x5f
 [<c07c57c2>] ? start_kernel+0x2c7/0x2ca
------------[ cut here ]------------
WARNING: at kernel/workqueue.c:371 flush_cpu_workqueue+0x23/0x70()
Hardware name: 766634U
Modules linked in: cpufreq_ondemand acpi_cpufreq loop dm_multipath snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm crc_itu_t pcspkr snd_timer thinkpad_acpi snd ac battery btusb button iTCO_wdt iTCO_vendor_support soundcore bluetooth i2c_i801 rfkill i2c_core e1000e snd_page_alloc hwmon ata_piix dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ahci libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
Pid: 1100, comm: bluetooth Not tainted 2.6.30-rc3 #2
Call Trace:
 [<c042ae6d>] ? warn_slowpath+0x60/0x9f
 [<c042ae94>] ? warn_slowpath+0x87/0x9f
 [<c041ecee>] ? __wake_up_common+0x2e/0x58
 [<c0420819>] ? update_curr+0xbc/0xf5
 [<c0420800>] ? update_curr+0xa3/0xf5
 [<c04279e6>] ? dequeue_task_fair+0xd8/0xe5
 [<c0401d44>] ? __switch_to+0xde/0x164
 [<c0424ffc>] ? finish_task_switch+0x40/0xc4
 [<c04382ff>] ? flush_cpu_workqueue+0x23/0x70
 [<c04387ed>] ? flush_workqueue+0x3c/0x59
 [<f89b9674>] ? add_conn+0x10/0x2e [bluetooth]
 [<c0438af9>] ? worker_thread+0x12b/0x1b4
 [<f89b9664>] ? add_conn+0x0/0x2e [bluetooth]
 [<c043b008>] ? autoremove_wake_function+0x0/0x2d
 [<c04389ce>] ? worker_thread+0x0/0x1b4
 [<c043af45>] ? kthread+0x42/0x69
 [<c043af03>] ? kthread+0x0/0x69
 [<c0403977>] ? kernel_thread_helper+0x7/0x10
---[ end trace 4622b3ef7b8b6111 ]---

# hciconfig -a
hci0:	Type: USB
	BD Address: 00:1C:26:E6:2F:41 ACL MTU: 1017:8 SCO MTU: 64:8
	UP RUNNING 
	RX bytes:348 acl:0 sco:0 events:11 errors:0
	TX bytes:38 acl:0 sco:0 commands:11 errors:0
	Features: 0xff 0xff 0x8f 0xfe 0x9b 0xf9 0x00 0x80
	Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3 
	Link policy: 
	Link mode: SLAVE ACCEPT 
	Name: 'IBM Callisto'
	Class: 0x000000
	Service Classes: Unspecified
	Device Class: Miscellaneous, 
	HCI Ver: 2.0 (0x3) HCI Rev: 0x212b LMP Ver: 2.0 (0x3) LMP Subver: 0x41d3
	Manufacturer: Broadcom Corporation (15)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbXBEKPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbXBEKPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 05:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXBEKPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 05:15:22 -0500
Received: from odin2.bull.net ([129.184.85.11]:63411 "EHLO odin2.bull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbXBEKPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 05:15:20 -0500
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 05:15:18 EST
From: "Serge Noiraud" <serge.noiraud@bull.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: FC6 + 2.6.20-rc7.1.rt3.0109 : BUG: using smp_processor_id() in preemptible
Date: Mon, 5 Feb 2007 12:05:17 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702051205.18238.Serge.Noiraud@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	On my laptop, I get the following messages after removing an USB device :
If you need some more info, I can send them.

I use a NEC M340 laptop. I have only one CPU.

Feb 5 10:25:04 ibiza kernel: usb 4-3: new high speed USB device using ehci_hcd and address 3
Feb 5 10:25:04 ibiza kernel: usb 4-3: configuration #1 chosen from 1 choice
Feb 5 10:25:04 ibiza kernel: Initializing USB Mass Storage driver...
Feb 5 10:25:04 ibiza kernel: scsi0 : SCSI emulation for USB Mass Storage devices
Feb 5 10:25:04 ibiza kernel: usbcore: registered new interface driver usb-storage
Feb 5 10:25:04 ibiza kernel: USB Mass Storage support registered.
Feb 5 10:25:09 ibiza kernel: scsi 0:0:0:0: Direct-Access LEXAR JUMPDRIVE ELITE 1000 PQ: 0 ANSI: 0 CCS
Feb 5 10:25:09 ibiza kernel: SCSI device sda: 502880 512-byte hdwr sectors (257 MB)
Feb 5 10:25:09 ibiza kernel: sda: Write Protect is off
Feb 5 10:25:09 ibiza kernel: sda: assuming drive cache: write through
Feb 5 10:25:09 ibiza kernel: SCSI device sda: 502880 512-byte hdwr sectors (257 MB)
Feb 5 10:25:09 ibiza kernel: sda: Write Protect is off
Feb 5 10:25:09 ibiza kernel: sda: assuming drive cache: write through
Feb 5 10:25:09 ibiza kernel: sda: sda1
Feb 5 10:25:09 ibiza kernel: sd 0:0:0:0: Attached scsi removable disk sda
Feb 5 10:25:09 ibiza kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Feb 5 10:25:15 ibiza hald: mounted /dev/sda1 on behalf of uid 1172
Feb 5 10:28:19 ibiza kernel: usb 4-3: USB disconnect, address 3
Feb 5 10:28:19 ibiza kernel: BUG: using smp_processor_id() in preemptible [00000000] code: khubd/161
Feb 5 10:28:19 ibiza kernel: caller is drain_array+0x15/0xec
Feb 5 10:28:19 ibiza kernel: [<c010503c>] dump_trace+0x63/0x1e8
Feb 5 10:28:19 ibiza kernel: [<c01051dd>] show_trace_log_lvl+0x1c/0x39
Feb 5 10:28:19 ibiza kernel: [<c01055d4>] show_trace+0x12/0x14
Feb 5 10:28:19 ibiza kernel: [<c01055ea>] dump_stack+0x14/0x16
Feb 5 10:28:19 ibiza kernel: [<c01f8b21>] debug_smp_processor_id+0xa5/0xb4
Feb 5 10:28:19 ibiza kernel: [<c017b318>] drain_array+0x15/0xec
Feb 5 10:28:19 ibiza kernel: [<c017b698>] __cache_shrink+0x41/0x7e
Feb 5 10:28:19 ibiza kernel: [<c017b7fb>] kmem_cache_destroy+0x58/0xca
Feb 5 10:28:19 ibiza kernel: [<f8901664>] scsi_destroy_command_freelist+0x51/0x5f [scsi_mod]
Feb 5 10:28:19 ibiza kernel: [<f890251d>] scsi_host_dev_release+0x74/0xa7 [scsi_mod]
Feb 5 10:28:19 ibiza kernel: [<c0263d7f>] device_release+0x2b/0x6d
Feb 5 10:28:19 ibiza kernel: [<c01f4480>] kobject_cleanup+0x44/0x64
Feb 5 10:28:19 ibiza kernel: [<c01f44ab>] kobject_release+0xb/0x10
Feb 5 10:28:19 ibiza kernel: [<c01f4a06>] kref_put+0x63/0x71
Feb 5 10:28:19 ibiza kernel: [<c01f3dbf>] kobject_put+0x14/0x16
Feb 5 10:28:19 ibiza kernel: [<c0263ecf>] put_device+0x11/0x13
Feb 5 10:28:19 ibiza kernel: [<f8901fb4>] scsi_host_put+0xd/0xf [scsi_mod]
Feb 5 10:28:19 ibiza kernel: [<f8d6cc54>] release_everything+0xa9/0xad [usb_storage]
Feb 5 10:28:19 ibiza kernel: [<f8d6cd04>] storage_disconnect+0x18/0x1b [usb_storage]
Feb 5 10:28:19 ibiza kernel: [<c0298745>] usb_unbind_interface+0x30/0x63
Feb 5 10:28:19 ibiza kernel: [<c0265e00>] __device_release_driver+0x74/0x89
Feb 5 10:28:19 ibiza kernel: [<c0266070>] device_release_driver+0x1b/0x26
Feb 5 10:28:19 ibiza kernel: [<c0265817>] bus_remove_device+0x7a/0x89
Feb 5 10:28:19 ibiza kernel: [<c02646ed>] device_del+0x142/0x19f
Feb 5 10:28:19 ibiza kernel: [<c0296faa>] usb_disable_device+0x5f/0xbc
Feb 5 10:28:19 ibiza kernel: [<c02937f7>] usb_disconnect+0x7d/0xec
Feb 5 10:28:19 ibiza kernel: [<c0294200>] hub_thread+0x2e2/0x96e
Feb 5 10:28:19 ibiza kernel: [<c013bc70>] kthread+0xb2/0xd7
Feb 5 10:28:19 ibiza kernel: [<c0104c9b>] kernel_thread_helper+0x7/0x10
Feb 5 10:28:19 ibiza kernel: =======================
Feb 5 10:28:19 ibiza kernel: ---------------------------
Feb 5 10:28:19 ibiza kernel: | preempt count: 00000001 ]
Feb 5 10:28:19 ibiza kernel: | 1-level deep critical section nesting:
Feb 5 10:28:19 ibiza kernel: ----------------------------------------
Feb 5 10:28:19 ibiza kernel: .. [<c03363bb>] .... __spin_lock+0x10/0x21
Feb 5 10:28:19 ibiza kernel: .....[<c015f106>] .. ( <= handle_level_irq+0xca/0xf8)
Feb 5 10:28:19 ibiza kernel: 
Feb 5 10:28:19 ibiza kernel: BUG: khubd:161 task might have lost a preemption check!
Feb 5 10:28:19 ibiza kernel: [<c010503c>] dump_trace+0x63/0x1e8
Feb 5 10:28:19 ibiza kernel: [<c01051dd>] show_trace_log_lvl+0x1c/0x39
Feb 5 10:28:19 ibiza kernel: [<c01055d4>] show_trace+0x12/0x14
Feb 5 10:28:19 ibiza kernel: [<c01055ea>] dump_stack+0x14/0x16
Feb 5 10:28:19 ibiza kernel: [<c0122a4e>] preempt_enable_no_resched+0x5a/0x5c
Feb 5 10:28:19 ibiza kernel: [<c01f8b26>] debug_smp_processor_id+0xaa/0xb4
Feb 5 10:28:19 ibiza kernel: [<c017b318>] drain_array+0x15/0xec
Feb 5 10:28:19 ibiza kernel: [<c017b698>] __cache_shrink+0x41/0x7e
Feb 5 10:28:19 ibiza kernel: [<c017b7fb>] kmem_cache_destroy+0x58/0xca
Feb 5 10:28:19 ibiza kernel: [<f8901664>] scsi_destroy_command_freelist+0x51/0x5f [scsi_mod]
Feb 5 10:28:19 ibiza kernel: [<f890251d>] scsi_host_dev_release+0x74/0xa7 [scsi_mod]
Feb 5 10:28:19 ibiza kernel: [<c0263d7f>] device_release+0x2b/0x6d
Feb 5 10:28:19 ibiza kernel: [<c01f4480>] kobject_cleanup+0x44/0x64
Feb 5 10:28:19 ibiza kernel: [<c01f44ab>] kobject_release+0xb/0x10
Feb 5 10:28:19 ibiza kernel: [<c01f4a06>] kref_put+0x63/0x71
Feb 5 10:28:19 ibiza kernel: [<c01f3dbf>] kobject_put+0x14/0x16
Feb 5 10:28:19 ibiza kernel: [<c0263ecf>] put_device+0x11/0x13
Feb 5 10:28:19 ibiza kernel: [<f8901fb4>] scsi_host_put+0xd/0xf [scsi_mod]
Feb 5 10:28:19 ibiza kernel: [<f8d6cc54>] release_everything+0xa9/0xad [usb_storage]
Feb 5 10:28:19 ibiza kernel: [<f8d6cd04>] storage_disconnect+0x18/0x1b [usb_storage]
Feb 5 10:28:19 ibiza kernel: [<c0298745>] usb_unbind_interface+0x30/0x63
Feb 5 10:28:19 ibiza kernel: [<c0265e00>] __device_release_driver+0x74/0x89
Feb 5 10:28:19 ibiza kernel: [<c0266070>] device_release_driver+0x1b/0x26
Feb 5 10:28:19 ibiza kernel: [<c0265817>] bus_remove_device+0x7a/0x89
Feb 5 10:28:19 ibiza kernel: [<c02646ed>] device_del+0x142/0x19f
Feb 5 10:28:19 ibiza kernel: [<c0296faa>] usb_disable_device+0x5f/0xbc
Feb 5 10:28:19 ibiza kernel: [<c02937f7>] usb_disconnect+0x7d/0xec
Feb 5 10:28:19 ibiza kernel: [<c0294200>] hub_thread+0x2e2/0x96e
Feb 5 10:28:19 ibiza kernel: [<c013bc70>] kthread+0xb2/0xd7
Feb 5 10:28:19 ibiza kernel: [<c0104c9b>] kernel_thread_helper+0x7/0x10
Feb 5 10:28:19 ibiza kernel: =======================
Feb 5 10:28:19 ibiza kernel: ---------------------------
Feb 5 10:28:19 ibiza kernel: | preempt count: 00000000 ]
Feb 5 10:28:19 ibiza kernel: | 0-level deep critical section nesting:
Feb 5 10:28:19 ibiza kernel: ----------------------------------------
Feb 5 10:28:19 ibiza kernel: 

-- 
Serge Noiraud

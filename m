Return-Path: <linux-kernel-owner+w=401wt.eu-S933692AbYBMX17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbYBMX17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbYBMX1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:27:44 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4847 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860AbYBMX1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:27:42 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: gregkh@suse.de
Subject: Re: problem with starting 2.5.25-rc1 and latest git
Date: Thu, 14 Feb 2008 00:27:34 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <200802132316.03155.m.kozlowski@tuxland.pl>
In-Reply-To: <200802132316.03155.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802140027.35102.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of course there is a typo in the subject :)

2.5.25-rc1 -> 2.6.25-rc1

> Hello,
> 
> 	I tried 2.6.25-rc1 and latest git on my laptop (x86 32bit) and have a problem.
> Linux boots but with huge delay due to some issue with loading usb modules.
> Udev complains:
> 
> 'Could not lock modprobe uhci_hcd'
> 'Could not lock modprobe yenta_socket'
> 'Unknown symbol usb_*'
> 'Gave up waiting for init of module usbcore'
> 
> at the same time I can see these messages in syslog (look at timing - grep by usb):
> 
> Feb 13 21:34:22 laptop kernel: usbcore: registered new interface driver usbfs
> Feb 13 21:34:22 laptop kernel: usbcore: registered new interface driver hub
> Feb 13 21:34:22 laptop kernel: usbcore: registered new device driver usb
> Feb 13 21:34:22 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:34:22 laptop kernel: ehci_hcd: Unknown symbol usb_hcd_pci_suspend
> Feb 13 21:34:22 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:34:22 laptop kernel: ehci_hcd: Unknown symbol usb_free_urb
> Feb 13 21:34:31 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:34:31 laptop kernel: ehci_hcd: Unknown symbol usb_hub_tt_clear_buffer
> Feb 13 21:35:01 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:35:01 laptop kernel: ehci_hcd: Unknown symbol usb_hcd_resume_root_hub
> Feb 13 21:35:32 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:35:32 laptop kernel: ehci_hcd: Unknown symbol usb_hcd_pci_probe
> Feb 13 21:36:02 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:36:02 laptop kernel: ehci_hcd: Unknown symbol usb_hcd_unlink_urb_from_ep
> Feb 13 21:36:32 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:36:32 laptop kernel: ehci_hcd: Unknown symbol usb_hcd_check_unlink_urb
> Feb 13 21:37:02 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:37:02 laptop kernel: ehci_hcd: Unknown symbol usb_calc_bus_time
> Feb 13 21:37:32 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:38:02 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:38:02 laptop kernel: ehci_hcd: Unknown symbol usb_hcd_pci_shutdown
> Feb 13 21:38:32 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:38:32 laptop kernel: ehci_hcd: Unknown symbol usb_hcd_link_urb_to_ep
> Feb 13 21:39:02 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:39:02 laptop kernel: ehci_hcd: Unknown symbol usb_hcd_pci_resume
> Feb 13 21:39:32 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:39:32 laptop kernel: ehci_hcd: Unknown symbol usb_get_urb
> Feb 13 21:40:02 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:40:02 laptop kernel: ehci_hcd: Unknown symbol usb_hcd_giveback_urb
> Feb 13 21:40:32 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:40:32 laptop kernel: ehci_hcd: Unknown symbol usb_hcd_poll_rh_status
> Feb 13 21:41:02 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:41:02 laptop kernel: ehci_hcd: Unknown symbol usb_hcd_pci_remove
> Feb 13 21:41:32 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.
> Feb 13 21:41:32 laptop kernel: ehci_hcd: Unknown symbol usb_root_hub_lost_power
> 
> Sysrq says:
> 
> Feb 13 21:35:06 laptop kernel: Showing all locks held in the system:
> Feb 13 21:35:06 laptop kernel: 1 lock held by modprobe/1130:
> Feb 13 21:35:06 laptop kernel:  #0:  (module_mutex){--..}, at: [<c0139c69>] sys_init_module+0x3d/0x1749
> Feb 13 21:35:06 laptop kernel: 1 lock held by modprobe/1131:
> Feb 13 21:35:06 laptop kernel:  #0:  (module_mutex){--..}, at: [<c0139d54>] sys_init_module+0x128/0x1749
> Feb 13 21:35:06 laptop kernel: 2 locks held by modprobe/1143:
> Feb 13 21:35:06 laptop kernel:  #0:  (&p->lock){--..}, at: [<c0177551>] seq_read+0x26/0x2b5
> Feb 13 21:35:06 laptop kernel:  #1:  (module_mutex){--..}, at: [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:06 laptop kernel: 2 locks held by modprobe/1144:
> Feb 13 21:35:06 laptop kernel:  #0:  (&p->lock){--..}, at: [<c0177551>] seq_read+0x26/0x2b5
> Feb 13 21:35:06 laptop kernel:  #1:  (module_mutex){--..}, at: [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:06 laptop kernel: 2 locks held by modprobe/1352:
> Feb 13 21:35:06 laptop kernel:  #0:  (&p->lock){--..}, at: [<c0177551>] seq_read+0x26/0x2b5
> Feb 13 21:35:06 laptop kernel:  #1:  (module_mutex){--..}, at: [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:06 laptop kernel: 2 locks held by modprobe/1354:
> Feb 13 21:35:06 laptop kernel:  #0:  (&p->lock){--..}, at: [<c0177551>] seq_read+0x26/0x2b5
> Feb 13 21:35:06 laptop kernel:  #1:  (module_mutex){--..}, at: [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:06 laptop kernel: 2 locks held by modprobe/1547:
> Feb 13 21:35:06 laptop kernel:  #0:  (&p->lock){--..}, at: [<c0177551>] seq_read+0x26/0x2b5
> Feb 13 21:35:06 laptop kernel:  #1:  (module_mutex){--..}, at: [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:06 laptop kernel: 2 locks held by modprobe/1555:
> Feb 13 21:35:06 laptop kernel:  #0:  (&p->lock){--..}, at: [<c0177551>] seq_read+0x26/0x2b5
> Feb 13 21:35:06 laptop kernel:  #1:  (module_mutex){--..}, at: [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:06 laptop kernel: 2 locks held by modprobe/3916:
> Feb 13 21:35:06 laptop kernel:  #0:  (&p->lock){--..}, at: [<c0177551>] seq_read+0x26/0x2b5
> Feb 13 21:35:06 laptop kernel:  #1:  (module_mutex){--..}, at: [<c0138fd1>] m_start+0xf/0x1f
> 
> and
> 
> Feb 13 21:35:12 laptop kernel: SysRq : Show Blocked State
> Feb 13 21:35:12 laptop kernel:   task                PC stack   pid father
> Feb 13 21:35:12 laptop kernel: modprobe      D c032771c     0  1131    693
> Feb 13 21:35:12 laptop kernel:        dce00500 00000082 dcc18158 c032771c c04180a4 c04180a0 00000246 c04180a4
> Feb 13 21:35:12 laptop kernel:        dcc18000 c03276cb 00000000 00000002 c0139d54 00000000 c0139d54 c04180c0
> Feb 13 21:35:12 laptop kernel:        dcee3ef0 dcd6bef0 dcc18000 c04180a0 ddb72ea4 00000000 deee7580 00000001
> Feb 13 21:35:12 laptop kernel: Call Trace:
> Feb 13 21:35:12 laptop kernel:  [<c032771c>] mutex_lock_nested+0x132/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c03276cb>] mutex_lock_nested+0xe1/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c0139d54>] sys_init_module+0x128/0x1749
> Feb 13 21:35:12 laptop last message repeated 2 times
> Feb 13 21:35:12 laptop kernel:  [<c024be4c>] bus_register+0x0/0x1f7
> Feb 13 21:35:12 laptop kernel:  [<c0102d11>] sysenter_past_esp+0x9a/0xa5
> Feb 13 21:35:12 laptop kernel:  [<c0102cd6>] sysenter_past_esp+0x5f/0xa5
> Feb 13 21:35:12 laptop kernel:  =======================
> Feb 13 21:35:12 laptop kernel: modprobe      D c032771c     0  1143    671
> Feb 13 21:35:12 laptop kernel:        ddbb6780 00000082 dcd6a158 c032771c c04180a4 c04180a0 00000246 c04180a4
> Feb 13 21:35:12 laptop kernel:        dcd6a000 c03276cb 00000000 00000002 c0138fd1 00000000 c0138fd1 c04180c0
> Feb 13 21:35:12 laptop kernel:        ddb72ea4 dcc3eef0 dcd6a000 c04180a0 dcd6bef0 dcd6bf40 dccb3a50 c017752b
> Feb 13 21:35:12 laptop kernel: Call Trace:
> Feb 13 21:35:12 laptop kernel:  [<c032771c>] mutex_lock_nested+0x132/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c03276cb>] mutex_lock_nested+0xe1/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0177606>] seq_read+0xdb/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c018f255>] proc_reg_read+0x58/0x79
> Feb 13 21:35:12 laptop kernel:  [<c01603c9>] vfs_read+0x89/0x11a
> Feb 13 21:35:12 laptop kernel:  [<c018f1fd>] proc_reg_read+0x0/0x79
> Feb 13 21:35:12 laptop kernel:  [<c016075b>] sys_read+0x41/0x6a
> Feb 13 21:35:12 laptop kernel:  [<c0102cd6>] sysenter_past_esp+0x5f/0xa5
> Feb 13 21:35:12 laptop kernel:  =======================
> Feb 13 21:35:12 laptop kernel: modprobe      D c032771c     0  1144    805
> Feb 13 21:35:12 laptop kernel:        ddbb6500 00000082 dcc0b158 c032771c c04180a4 c04180a0 00000246 c04180a4
> Feb 13 21:35:12 laptop kernel:        dcc0b000 c03276cb 00000000 00000002 c0138fd1 00000000 c0138fd1 c04180c0
> Feb 13 21:35:12 laptop kernel:        dcd6bef0 c04180c0 dcc0b000 c04180a0 dcc3eef0 dcc3ef40 dccb3bb0 c017752b
> Feb 13 21:35:12 laptop kernel: Call Trace:
> Feb 13 21:35:12 laptop kernel:  [<c032771c>] mutex_lock_nested+0x132/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c03276cb>] mutex_lock_nested+0xe1/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0177606>] seq_read+0xdb/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c018f255>] proc_reg_read+0x58/0x79
> Feb 13 21:35:12 laptop kernel:  [<c01603c9>] vfs_read+0x89/0x11a
> Feb 13 21:35:12 laptop kernel:  [<c018f1fd>] proc_reg_read+0x0/0x79
> Feb 13 21:35:12 laptop kernel:  [<c016075b>] sys_read+0x41/0x6a
> Feb 13 21:35:12 laptop kernel:  [<c0102cd6>] sysenter_past_esp+0x5f/0xa5
> Feb 13 21:35:12 laptop kernel:  =======================
> Feb 13 21:35:12 laptop kernel: modprobe      D c032771c     0  1352   1200
> Feb 13 21:35:12 laptop kernel:        dcdfa000 00000082 dcdae158 c032771c c04180a4 c04180a0 00000246 c04180a4
> Feb 13 21:35:12 laptop kernel:        dcdae000 c03276cb 00000000 00000002 c0138fd1 00000000 c0138fd1 c04180c0
> Feb 13 21:35:12 laptop kernel:        dd9bcef0 ddb72ea4 dcdae000 c04180a0 dcee3ef0 dcee3f40 dccb34d0 c017752b
> Feb 13 21:35:12 laptop kernel: Call Trace:
> Feb 13 21:35:12 laptop kernel:  [<c032771c>] mutex_lock_nested+0x132/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c03276cb>] mutex_lock_nested+0xe1/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0177606>] seq_read+0xdb/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c018f255>] proc_reg_read+0x58/0x79
> Feb 13 21:35:12 laptop kernel:  [<c01603c9>] vfs_read+0x89/0x11a
> Feb 13 21:35:12 laptop kernel:  [<c018f1fd>] proc_reg_read+0x0/0x79
> Feb 13 21:35:12 laptop kernel:  [<c016075b>] sys_read+0x41/0x6a
> Feb 13 21:35:12 laptop kernel:  [<c0102cd6>] sysenter_past_esp+0x5f/0xa5
> Feb 13 21:35:12 laptop kernel:  =======================
> Feb 13 21:35:12 laptop kernel: modprobe      D c032771c     0  1354   1210
> Feb 13 21:35:12 laptop kernel:        dcdfa280 00000082 ddb8e158 c032771c c04180a4 c04180a0 00000246 c04180a4
> Feb 13 21:35:12 laptop kernel:        ddb8e000 c03276cb 00000000 00000002 c0138fd1 00000000 c0138fd1 c04180c0
> Feb 13 21:35:12 laptop kernel:        dceccef0 dcee3ef0 ddb8e000 c04180a0 dd9bcef0 dd9bcf40 dccb30b0 c017752b
> Feb 13 21:35:12 laptop kernel: Call Trace:
> Feb 13 21:35:12 laptop kernel:  [<c032771c>] mutex_lock_nested+0x132/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c03276cb>] mutex_lock_nested+0xe1/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0177606>] seq_read+0xdb/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c018f255>] proc_reg_read+0x58/0x79
> Feb 13 21:35:12 laptop kernel:  [<c01603c9>] vfs_read+0x89/0x11a
> Feb 13 21:35:12 laptop kernel:  [<c018f1fd>] proc_reg_read+0x0/0x79
> Feb 13 21:35:12 laptop kernel:  [<c016075b>] sys_read+0x41/0x6a
> Feb 13 21:35:12 laptop kernel:  [<c0102cd6>] sysenter_past_esp+0x5f/0xa5
> Feb 13 21:35:12 laptop kernel:  =======================
> Feb 13 21:35:12 laptop kernel: modprobe      D c032771c     0  1547    710
> Feb 13 21:35:12 laptop kernel:        dcc72780 00000082 ddb95158 c032771c c04180a4 c04180a0 00000246 c04180a4
> Feb 13 21:35:12 laptop kernel:        ddb95000 c03276cb 00000000 00000002 c0138fd1 00000000 c0138fd1 c04180c0
> Feb 13 21:35:12 laptop kernel:        ddbfaef0 dd9bcef0 ddb95000 c04180a0 dceccef0 dceccf40 ddb549a0 c017752b
> Feb 13 21:35:12 laptop kernel: Call Trace:
> Feb 13 21:35:12 laptop kernel:  [<c032771c>] mutex_lock_nested+0x132/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c03276cb>] mutex_lock_nested+0xe1/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0177606>] seq_read+0xdb/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c018f255>] proc_reg_read+0x58/0x79
> Feb 13 21:35:12 laptop kernel:  [<c01603c9>] vfs_read+0x89/0x11a
> Feb 13 21:35:12 laptop kernel:  [<c018f1fd>] proc_reg_read+0x0/0x79
> Feb 13 21:35:12 laptop kernel:  [<c016075b>] sys_read+0x41/0x6a
> Feb 13 21:35:12 laptop kernel:  [<c0102cd6>] sysenter_past_esp+0x5f/0xa5
> Feb 13 21:35:12 laptop kernel:  =======================
> Feb 13 21:35:12 laptop kernel: modprobe      D c032771c     0  1555    666
> Feb 13 21:35:12 laptop kernel:        dcd22280 00000082 dcd46158 c032771c c04180a4 c04180a0 00000246 c04180a4
> Feb 13 21:35:12 laptop kernel:        dcd46000 c03276cb 00000000 00000002 c0138fd1 00000000 c0138fd1 c04180c0
> Feb 13 21:35:12 laptop kernel:        dce5aef0 dceccef0 dcd46000 c04180a0 ddbfaef0 ddbfaf40 ddb548f0 c017752b
> Feb 13 21:35:12 laptop kernel: Call Trace:
> Feb 13 21:35:12 laptop kernel:  [<c032771c>] mutex_lock_nested+0x132/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c03276cb>] mutex_lock_nested+0xe1/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0177606>] seq_read+0xdb/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c018f255>] proc_reg_read+0x58/0x79
> Feb 13 21:35:12 laptop kernel:  [<c01603c9>] vfs_read+0x89/0x11a
> Feb 13 21:35:12 laptop kernel:  [<c018f1fd>] proc_reg_read+0x0/0x79
> Feb 13 21:35:12 laptop kernel:  [<c016075b>] sys_read+0x41/0x6a
> Feb 13 21:35:12 laptop kernel:  [<c0102cd6>] sysenter_past_esp+0x5f/0xa5
> Feb 13 21:35:12 laptop kernel:  =======================
> Feb 13 21:35:12 laptop kernel: modprobe      D c032771c     0  3916   3914
> Feb 13 21:35:12 laptop kernel:        ddb82780 00000082 dce52158 c032771c c04180a4 c04180a0 00000246 c04180a4
> Feb 13 21:35:12 laptop kernel:        dce52000 c03276cb 00000000 00000002 c0138fd1 00000000 c0138fd1 c04180c0
> Feb 13 21:35:12 laptop kernel:        c04180c0 ddbfaef0 dce52000 c04180a0 dce5aef0 dce5af40 dcc42a50 c017752b
> Feb 13 21:35:12 laptop kernel: Call Trace:
> Feb 13 21:35:12 laptop kernel:  [<c032771c>] mutex_lock_nested+0x132/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c03276cb>] mutex_lock_nested+0xe1/0x27b
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c0138fd1>] m_start+0xf/0x1f
> Feb 13 21:35:12 laptop kernel:  [<c0177606>] seq_read+0xdb/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c017752b>] seq_read+0x0/0x2b5
> Feb 13 21:35:12 laptop kernel:  [<c018f255>] proc_reg_read+0x58/0x79
> Feb 13 21:35:12 laptop kernel:  [<c01603c9>] vfs_read+0x89/0x11a
> Feb 13 21:35:12 laptop kernel:  [<c018f1fd>] proc_reg_read+0x0/0x79
> Feb 13 21:35:12 laptop kernel:  [<c016075b>] sys_read+0x41/0x6a
> Feb 13 21:35:12 laptop kernel:  [<c0102cd6>] sysenter_past_esp+0x5f/0xa5
> Feb 13 21:35:12 laptop kernel:  =======================
> 
> How can I solve this?
> 
> Regards,
> 
> 	Mariusz
> 



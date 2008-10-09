Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbYJINXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbYJINXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 09:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758484AbYJINXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 09:23:43 -0400
Received: from flock1.newmail.ru ([82.204.219.207]:49022 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758382AbYJINXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:23:39 -0400
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading firmware with PCMCIA adapter
Date: Thu, 9 Oct 2008 17:22:55 +0400
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pcmcia@lists.infradead.org
MIME-Version: 1.0
Message-Id: <200810091722.56812.arvidjaar@newmail.ru>
Content-Type: multipart/signed;
  boundary="nextPart11230623.Bc99ur72Cu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart11230623.Bc99ur72Cu
Content-Type: multipart/mixed;
  boundary="Boundary-01=_wWg7IjLEg7M+iWO"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_wWg7IjLEg7M+iWO
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2.6.27-rc9 + patches to enable WPA from wireless-testing (picked manually):

+ orinoco-add-essid-specific-sca
+ orinoco-update-scan-translatio
+ orinoco-specify-all-three-para
+ orinoco-move-export_symbol-dec
+ orinoco-add-function-to-execut
+ orinoco-move-firmware-download
+ orinoco-make-firmware-download
+ orinoco-extend-hermes_dld-rout
+ orinoco-invoke-firmware-downlo
+ orinoco-fix-transmit-for-agere
+ orinoco-address-checkpatch-typ
+ orinoco-use-extended-agere-sca
+ orinoco-don-t-use-boolean-para
+ orinoco-split-wevent-work-thre
+ orinoco-use-a-macro-to-define-
+ orinoco-add-we-18-ioctls-for-w
+ orinoco-send-association-event
+ orinoco-process-bulk-of-receiv
+ orinoco-add-mic-on-tx-and-chec
+ orinoco-fix-compile-warnings

Firmware taken from orinoco-devel list and placed in /lib/firmware:

4bc30fed682d83ce0bbeb32af6d218a3  /lib/firmware/agere_sta_fw.bin

After loading orinoco and "inserting" adapter I get either BUG with
endless loop (attached) or kernel panic on NULL pointer dereference
(was not able capture). Adapter works fine with wlags49 driver.

{pts/1}% pccardctl ident
Socket 0:
  product info: "TOSHIBA", "Wireless LAN Card", "Version 01.01", ""
  manfid: 0x0156, 0x0002
  function: 6 (network)
Socket 1:
  no product info available
Socket 2:
  no product info available

Any idea? Anything else in wireless-testing that is missing in vanilla?

--Boundary-01=_wWg7IjLEg7M+iWO
Content-Type: text/x-log;
  charset="us-ascii";
  name="orinoco.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="orinoco.log"

[  132.296173] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, P=
avel Roskin <proski@gnu.org>, et al)
[  132.381377] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
, Pavel Roskin <proski@gnu.org>, et al)
[  139.896755] pccard: PCMCIA card inserted into slot 0
[  139.897996] pcmcia: registering new device pcmcia0.0
[  139.906022] pcmcia: request for exclusive IRQ could not be fulfilled.
[  139.907013] pcmcia: the driver needs updating to supported shared IRQ li=
nes.
[  139.988539] eth1: Hardware identity 0005:0002:0001:0002
[  139.989337] eth1: Station identity  001f:0001:0006:000e
[  139.990097] eth1: Firmware determined as Lucent/Agere 6.14
[  139.990845] eth1: Attempting to download firmware agere_sta_fw.bin
[  139.991690] hermes_dld: AUX enable returned 0
[  139.993322] hermes_dld: AUX disable returned 0
[  139.993933] hermes_dld: Actual PDA length 998, Max allowed 1000
[  139.994719] eth1: Read PDA returned 0
[  139.995238] firmware: requesting agere_sta_fw.bin
[  139.996267] BUG: scheduling while atomic: pccardctl/3692/0xc04b1500
[  139.997056] low stack detected by irq handler
[  139.997235] Pid: 3692, comm: pccardctl Not tainted 2.6.27-rc9-1avb #14
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c0104a6c>] print_stack_overflow+0x1c/0x20
[  139.997235]  [<c0104b4e>] do_IRQ+0xde/0x130
[  139.997235]  [<c01034dc>] common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] printk+0x1d/0x23
[  139.997235]  [<c011747e>] __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] _request_firmware+0x142/0x390 [firmware_class]
[  139.997235]  [<dfd6d9d7>] request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] sys_write+0x42/0x70
[  139.997235]  [<c010327d>] sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c011469b>] ? try_to_wake_up+0x8b/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0113190>] ? __wake_up+0x40/0x50
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013da00>] ? trace_hardirqs_on_caller+0xa0/0x140
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c012c476>] ? __queue_work+0x36/0x50
[  139.997235]  [<dfd7fc50>] ? orinoco_send_wevents+0x0/0x340 [orinoco]
[  139.997235]  [<c012c67d>] ? queue_delayed_work+0x2d/0x40
[  139.997235]  [<c012c6a6>] ? schedule_delayed_work+0x16/0x20
[  139.997235]  [<c029b0bf>] ? linkwatch_schedule_work+0x3f/0xb0
[  139.997235]  [<c029b1ab>] ? linkwatch_fire_event+0x7b/0xd0
[  139.997235]  [<dfd91610>] ? orinoco_cs_config+0x3f0/0x400 [orinoco_cs]
[  139.997235]  [<dfd91690>] ? orinoco_cs_probe+0x70/0x80 [orinoco_cs]
[  139.997235]  [<dfdb4ab2>] ? pcmcia_device_probe+0xa2/0x150 [pcmcia]
[  139.997235]  [<c0264400>] ? driver_sysfs_add+0x40/0x90
[  139.997235]  [<c026455c>] ? driver_probe_device+0x8c/0x1b0
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c02ee1ad>] ? klist_next+0x6d/0xc0
[  139.997235]  [<c026471d>] ? __device_attach+0xd/0x10
[  139.997235]  [<c0263ad3>] ? bus_for_each_drv+0x63/0x90
[  139.997235]  [<c02647d6>] ? device_attach+0x76/0x80
[  139.997235]  [<c0264710>] ? __device_attach+0x0/0x10
[  139.997235]  [<c02638cf>] ? bus_attach_device+0x4f/0x70
[  139.997235]  [<c02624f7>] ? device_add+0x497/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfdb57fd>] ? pcmcia_device_add+0x1dd/0x250 [pcmcia]
[  139.997235]  [<dfdb590a>] ? pcmcia_card_add+0x9a/0xc0 [pcmcia]
[  139.997235]  [<c01f6242>] ? kobject_get+0x12/0x20
[  139.997235]  [<dfdb5a56>] ? ds_event+0x76/0xa0 [pcmcia]
[  139.997235]  [<dfcc6387>] ? send_event+0x47/0x70 [pcmcia_core]
[  139.997235]  [<dfcc67d1>] ? socket_insert+0xe1/0xf0 [pcmcia_core]
[  139.997235]  [<dfcc6837>] ? pcmcia_insert_card+0x57/0x70 [pcmcia_core]
[  139.997235]  [<dfcc9bb2>] ? pccard_store_insert+0x22/0x30 [pcmcia_core]
[  139.997235]  [<dfcc9b90>] ? pccard_store_insert+0x0/0x30 [pcmcia_core]
[  139.997235]  [<c0260efd>] ? dev_attr_store+0x2d/0x40
[  139.997235]  [<c01d1121>] ? sysfs_write_file+0xa1/0x100
[  139.997235]  [<c018d824>] ? vfs_write+0xa4/0x140
[  139.997235]  [<c01d1080>] ? sysfs_write_file+0x0/0x100
[  139.997235]  [<c018d992>] ? sys_write+0x42/0x70
[  139.997235]  [<c010327d>] ? sysenter_do_call+0x12/0x31
[  139.997235]  [<c026b1a8>] ? e100_exec_cb+0xe8/0x110
[  139.997235]  [<c0269b10>] ? e100_xmit_prepare+0x0/0xb0
[  139.997235]  [<c026b5e5>] ? e100_xmit_frame+0x35/0x130
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c029e8f7>] ? netpoll_send_skb+0x187/0x1c0
[  139.997235]  [<c029eb21>] ? netpoll_send_udp+0x1f1/0x210
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c01201f3>] ? irq_enter+0x43/0x80
[  139.997235]  [<c0104abc>] ? do_IRQ+0x4c/0x130
[  139.997235]  [<c01034dc>] ? common_interrupt+0x28/0x30
[  139.997235]  [<c011be3b>] ? vprintk+0x14b/0x3b0
[  139.997235]  [<c013d888>] ? mark_held_locks+0x48/0x90
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c013da5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[  139.997235]  [<c02f3eb2>] ? printk+0x1d/0x23
[  139.997235]  [<c011747e>] ? __schedule_bug+0x3e/0x90
[  139.997235]  [<c02f443f>] ? schedule+0x45f/0x4f0
[  139.997235]  [<c01175c3>] ? __cond_resched+0x33/0x50
[  139.997235]  [<c02f4585>] ? _cond_resched+0x35/0x50
[  139.997235]  [<c02f5047>] ? mutex_lock_nested+0x27/0x280
[  139.997235]  [<c01d1f27>] ? sysfs_new_dirent+0x77/0x110
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01d1e41>] ? sysfs_addrm_start+0x31/0xa0
[  139.997235]  [<c01d2405>] ? create_dir+0x45/0x90
[  139.997235]  [<c01d2480>] ? sysfs_create_dir+0x30/0x50
[  139.997235]  [<c02f6bb2>] ? _spin_unlock+0x22/0x30
[  139.997235]  [<c01f639c>] ? kobject_add_internal+0xbc/0x1b0
[  139.997235]  [<c01f6561>] ? kobject_add_varg+0x31/0x50
[  139.997235]  [<c01f65dc>] ? kobject_add+0x2c/0x60
[  139.997235]  [<c01f6083>] ? kobject_create+0x23/0x30
[  139.997235]  [<c0261200>] ? get_device_parent+0x120/0x1a0
[  139.997235]  [<c02620e7>] ? device_add+0x87/0x580
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c02625f7>] ? device_register+0x17/0x20
[  139.997235]  [<dfd6d6e2>] ? _request_firmware+0x142/0x390 [firmware_clas=
s]
[  139.997235]  [<dfd6d9d7>] ? request_firmware+0x17/0x1c [firmware_class]
[  139.997235]  [<dfd808eb>] ? orinoco_dl_firmware+0xfb/0x250 [orinoco]
[  139.997235]  [<dfd80c6e>] ? orinoco_download+0x2e/0x140 [orinoco]
[  139.997235]  [<dfd8153d>] ? orinoco_init+0x1cd/0x8d0 [orinoco]
[  139.997235]  [<c013daab>] ? trace_hardirqs_on+0xb/0x10
[  139.997235]  [<c020a142>] ? __spin_lock_init+0x32/0x60
[  139.997235]  [<c028e8d6>] ? __netdev_init_queue_locks_one+0x66/0x90
[  139.997235]  [<c02914a0>] ? register_netdevice+0x100/0x530
[  139.997235]  [<c029190f>] ? register_netdev+0x3f/0x60
[  139.997235]  [<dfd915a0>] ? orinoco_cs_config+0x380/0x400 [orinoco_cs]
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c0106d67>] ? native_sched_clock+0x77/0xb0
[  139.997235]  [<c013ba55>] ? lock_release_holdtime+0x35/0x200
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ? trace_hardirqs_off+0xb/0x10
[  139.997235]  [<c02f6b77>] ? _spin_unlock_irqrestore+0x57/0x70
[  139.997235]  [<c0133689>] ? hrtimer_start+0x89/0x140
[  139.997235]  [<c013ba1b>] ?=20
--Boundary-01=_wWg7IjLEg7M+iWO--

--nextPart11230623.Bc99ur72Cu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjuBbAACgkQR6LMutpd94yLTACfRAbxPX5z7W49hwoV9W1+K6e3
pYYAoI4mcQtcKyDF5QpHMWJIEc6JkBvB
=ms3h
-----END PGP SIGNATURE-----

--nextPart11230623.Bc99ur72Cu--

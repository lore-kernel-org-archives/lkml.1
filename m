Return-Path: <linux-kernel-owner+w=401wt.eu-S1750703AbXBMOuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750703AbXBMOuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbXBMOuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:50:10 -0500
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:41200 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbXBMOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:50:08 -0500
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 09:50:08 EST
Subject: 2.6.19: EFAIL on MPATH failback
From: "Charles C. Bennett, Jr." <ccb@acm.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 13 Feb 2007 09:35:35 -0500
Message-Id: <1171377335.20432.14.camel@cbox.memecycle.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: 428d7bd11d3f91d4416dc04816f3191c4a7efb63484444e88a927eedcc671cb4705d78c7f81acc54350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 24.41.31.94
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All -

  I have two systems running 2.6.19 from fedora-updates.

  System 1: vanilla x86 SMP server box with 2x Emulex LP-101
  System 2: vanilla x86 SMP server box with 2x QLogic 2310F

Both boxes are multipath to Hitachi USP TagmaStore.  All LUNs including
LUN0 (/, /boot, swap, /var via dm-linear/kpartx) are multipathed.

Userspace multipath-tools is 0.4.7, latest from fedora-updates.

With no IO load, multipath failover and failback work flawlessly after
fibre pull/reinsert.

Under IO load, failback fails on both nodes.

With QLogic:
Feb 12 12:48:12 arc-node-112 kernel: qla2xxx 0000:06:01.0: LOOP DOWN
detected (4
).
Feb 12 12:48:47 arc-node-112 kernel:  rport-1:0-0: blocked FC remote
port time o
ut: removing target and saving binding
Feb 12 12:48:47 arc-node-112 kernel: Synchronizing SCSI cache for disk
sde: 
Feb 12 12:48:47 arc-node-112 kernel: FAILED
Feb 12 12:48:47 arc-node-112 kernel:   status = 0, message = 00, host =
1, drive
r = 00
Feb 12 12:48:47 arc-node-112 kernel:   <5>Synchronizing SCSI cache for
disk sdf:
 
Feb 12 12:48:47 arc-node-112 kernel: FAILED
Feb 12 12:48:47 arc-node-112 kernel:   status = 0, message = 00, host =
1, drive
r = 00
Feb 12 12:48:47 arc-node-112 kernel:   <5>Synchronizing SCSI cache for
disk sdg:
 
Feb 12 12:48:47 arc-node-112 kernel: FAILED
Feb 12 12:48:47 arc-node-112 kernel:   status = 0, message = 00, host =
1, drive
r = 00
Feb 12 12:48:47 arc-node-112 kernel:   <5>Synchronizing SCSI cache for
disk sdh:
 
Feb 12 12:48:47 arc-node-112 kernel: FAILED
Feb 12 12:48:47 arc-node-112 kernel:   status = 0, message = 00, host =
1, drive
r = 00
Feb 12 12:49:15 arc-node-112 kernel:   <6>qla2xxx 0000:06:01.0: LIP
reset occure
d (f7f7).
Feb 12 12:49:16 arc-node-112 kernel: qla2xxx 0000:06:01.0: LOOP UP
detected (2 G
bps).
Feb 12 12:49:18 arc-node-112 kernel: scsi 1:0:0:0: Direct-Access
HITACHI  OP
EN-V           5004 PQ: 0 ANSI: 3
Feb 12 12:49:18 arc-node-112 kernel: SCSI device sdi: 211077120 512-byte
hdwr se
ctors (108071 MB)
Feb 12 12:49:18 arc-node-112 kernel: sdi: Write Protect is off
Feb 12 12:49:18 arc-node-112 kernel: SCSI device sdi: drive cache: write
back
Feb 12 12:49:18 arc-node-112 kernel: SCSI device sdi: 211077120 512-byte
hdwr se
ctors (108071 MB)
Feb 12 12:49:18 arc-node-112 kernel: sdi: Write Protect is off
Feb 12 12:49:18 arc-node-112 kernel: SCSI device sdi: drive cache: write
back
Feb 12 12:49:18 arc-node-112 kernel:  sdi: sdi1 sdi2 sdi3 sdi4 < sdi5
sdi6 sdi7 
sdi8 >
Feb 12 12:49:18 arc-node-112 kernel: sd 1:0:0:0: Attached scsi disk sdi
Feb 12 12:49:18 arc-node-112 kernel: sd 1:0:0:0: Attached scsi generic
sg4 type 
0
Feb 12 12:49:18 arc-node-112 kernel: scsi 1:0:0:0: Direct-Access
HITACHI  OP
EN-V           5004 PQ: 0 ANSI: 3
Feb 12 12:49:18 arc-node-112 kernel: kobject_add failed for 1:0:0:0 with
-EEXIST
, don't try to register things with the same name in the same directory.
Feb 12 12:49:18 arc-node-112 kernel:  [<c0405018>] dump_trace+0x69/0x1b6
Feb 12 12:49:18 arc-node-112 kernel:  [<c040517d>] show_trace_log_lvl
+0x18/0x2c
Feb 12 12:49:18 arc-node-112 kernel:  [<c0405778>] show_trace+0xf/0x11
Feb 12 12:49:18 arc-node-112 kernel:  [<c0405875>] dump_stack+0x15/0x17
Feb 12 12:49:18 arc-node-112 kernel:  [<c04eef7a>] kobject_add
+0x16d/0x196
Feb 12 12:49:19 arc-node-112 kernel:  [<c055cdd3>] device_add+0x9f/0x46f
Feb 12 12:49:19 arc-node-112 kernel:  [<f8863168>] scsi_sysfs_add_sdev
+0x2a/0x1d
f [scsi_mod]
Feb 12 12:49:19 arc-node-112 kernel:  [<f8861847>]
scsi_probe_and_add_lun+0x82e/
0x93e [scsi_mod]
Feb 12 12:49:19 arc-node-112 kernel:  [<f8862259>] __scsi_scan_target
+0x447/0x60
a [scsi_mod]
Feb 12 12:49:19 arc-node-112 kernel:  [<f88626c0>] scsi_scan_target
+0x69/0x7b [s
csi_mod]
Feb 12 12:49:19 arc-node-112 kernel:  [<f88b5a13>] fc_scsi_scan_rport
+0x53/0x71 
[scsi_transport_fc]
Feb 12 12:49:19 arc-node-112 kernel:  [<c04368c7>] run_workqueue
+0x97/0xdd
Feb 12 12:49:19 arc-node-112 kernel:  [<c0437284>] worker_thread
+0xd9/0x10d
Feb 12 12:49:19 arc-node-112 kernel:  [<c0439810>] kthread+0xc0/0xec
Feb 12 12:49:19 arc-node-112 kernel:  [<c0404c03>] kernel_thread_helper
+0x7/0x10
Feb 12 12:49:19 arc-node-112 kernel:  =======================
Feb 12 12:49:19 arc-node-112 kernel: error 1
Feb 12 12:49:19 arc-node-112 kernel: scsi 1:0:0:0: Unexpected response
from lun 
0 while scanning, scan aborted

Similar on Emulex:
Feb 12 12:52:03 arc-node-109 kernel: lpfc 0000:06:01.0: 1:1305 Link Down
Event x2 received Data: x2 x20 x110
Feb 12 12:52:03 arc-node-109 kernel: lpfc 0000:06:01.0: 1:1305 Link Down
Event x4 received Data: x4 x4 x100
Feb 12 12:52:29 arc-node-109 mgetty[3772]: failed dev=ttyS0, pid=3772,
login time out
Feb 12 12:52:33 arc-node-109 kernel:  rport-1:0-2: blocked FC remote
port time out: removing target and saving binding
Feb 12 12:52:33 arc-node-109 kernel: lpfc 0000:06:01.0: 1:0203 Devloss
timeout on WWPN 50:6:e:80:4:2b:e5:44 NPort x102ae Data: x8 x7 x4
Feb 12 12:52:33 arc-node-109 kernel: Synchronizing SCSI cache for disk
sde: 
Feb 12 12:52:33 arc-node-109 kernel: FAILED
Feb 12 12:52:33 arc-node-109 kernel:   status = 0, message = 00, host =
1, driver = 00
Feb 12 12:52:33 arc-node-109 kernel:   <5>Synchronizing SCSI cache for
disk sdf: 
Feb 12 12:52:33 arc-node-109 kernel: FAILED
Feb 12 12:52:33 arc-node-109 kernel:   status = 0, message = 00, host =
1, driver = 00
Feb 12 12:52:33 arc-node-109 kernel:   <5>Synchronizing SCSI cache for
disk sdg: 
Feb 12 12:52:33 arc-node-109 kernel: FAILED
Feb 12 12:52:33 arc-node-109 kernel:   status = 0, message = 00, host =
1, driver = 00
Feb 12 12:52:33 arc-node-109 kernel:   <5>Synchronizing SCSI cache for
disk sdh: 
Feb 12 12:52:33 arc-node-109 kernel: FAILED
Feb 12 12:52:33 arc-node-109 kernel:   status = 0, message = 00, host =
1, driver = 00
Feb 12 12:53:00 arc-node-109 kernel:   <3>lpfc 0000:06:01.0: 1:1303 Link
Up Event x5 received Data: x5 x0 x8 x2
Feb 12 12:53:02 arc-node-109 kernel: scsi 1:0:0:0: Direct-Access
HITACHI  OPEN-V           5004 PQ: 0 ANSI: 3
Feb 12 12:53:03 arc-node-109 kernel: SCSI device sdi: 211077120 512-byte
hdwr sectors (108071 MB)
Feb 12 12:53:03 arc-node-109 kernel: sdi: Write Protect is off
Feb 12 12:53:03 arc-node-109 kernel: SCSI device sdi: drive cache: write
back
Feb 12 12:53:03 arc-node-109 kernel: SCSI device sdi: 211077120 512-byte
hdwr sectors (108071 MB)
Feb 12 12:53:03 arc-node-109 kernel: sdi: Write Protect is off
Feb 12 12:53:03 arc-node-109 kernel: SCSI device sdi: drive cache: write
back
Feb 12 12:53:03 arc-node-109 kernel:  sdi: sdi1 sdi2 sdi3 sdi4 < sdi5
sdi6 sdi7 sdi8 >
Feb 12 12:53:03 arc-node-109 kernel: sd 1:0:0:0: Attached scsi disk sdi
Feb 12 12:53:03 arc-node-109 kernel: sd 1:0:0:0: Attached scsi generic
sg4 type 0
Feb 12 12:53:03 arc-node-109 kernel: scsi 1:0:0:0: Direct-Access
HITACHI  OPEN-V           5004 PQ: 0 ANSI: 3
Feb 12 12:53:03 arc-node-109 kernel: kobject_add failed for 1:0:0:0 with
-EEXIST, don't try to register things with the same name in the same
directory.
Feb 12 12:53:03 arc-node-109 kernel:  [<c0405018>] dump_trace+0x69/0x1b6
Feb 12 12:53:03 arc-node-109 kernel:  [<c040517d>] show_trace_log_lvl
+0x18/0x2c
Feb 12 12:53:03 arc-node-109 kernel:  [<c0405778>] show_trace+0xf/0x11
Feb 12 12:53:03 arc-node-109 kernel:  [<c0405875>] dump_stack+0x15/0x17
Feb 12 12:53:03 arc-node-109 kernel:  [<c04eef7a>] kobject_add
+0x16d/0x196
Feb 12 12:53:03 arc-node-109 kernel:  [<c055cdd3>] device_add+0x9f/0x46f
Feb 12 12:53:03 arc-node-109 kernel:  [<f8863168>] scsi_sysfs_add_sdev
+0x2a/0x1df [scsi_mod]
Feb 12 12:53:03 arc-node-109 kernel:  [<f8861847>]
scsi_probe_and_add_lun+0x82e/0x93e [scsi_mod]
Feb 12 12:53:03 arc-node-109 kernel:  [<f8862259>] __scsi_scan_target
+0x447/0x60a [scsi_mod]
Feb 12 12:53:04 arc-node-109 kernel:  [<f88626c0>] scsi_scan_target
+0x69/0x7b [scsi_mod]
Feb 12 12:53:04 arc-node-109 kernel:  [<f88b5a13>] fc_scsi_scan_rport
+0x53/0x71 [scsi_transport_fc]
Feb 12 12:53:04 arc-node-109 kernel:  [<c04368c7>] run_workqueue
+0x97/0xdd
Feb 12 12:53:04 arc-node-109 kernel:  [<c0437284>] worker_thread
+0xd9/0x10d
Feb 12 12:53:04 arc-node-109 kernel:  [<c0439810>] kthread+0xc0/0xec
Feb 12 12:53:04 arc-node-109 kernel:  [<c0404c03>] kernel_thread_helper
+0x7/0x10
Feb 12 12:53:04 arc-node-109 kernel:  =======================
Feb 12 12:53:04 arc-node-109 kernel: error 1
Feb 12 12:53:04 arc-node-109 kernel: scsi 1:0:0:0: Unexpected response
from lun 0 while scanning, scan aborted


Have I configured something poorly?  Are there known fixes out there?


Thanks in Advance,
ccb


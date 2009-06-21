Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZFURey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZFURey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 13:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZFURer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 13:34:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52622 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZFUReq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 13:34:46 -0400
Date: Sun, 21 Jun 2009 13:34:48 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: backtraces when mounting ext2 with sync option.
Message-ID: <20090621173448.GB26093@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see this when I mount an ext2 usb stick with the -o sync option.

	Dave

------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:292 __writeback_single_inode+0x125/0x287()
Hardware name:  
Modules linked in: serio_raw pcspkr i2c_viapro 3c59x mii i2c_core usb_storage firewire_ohci via_velocity firewire_core crc_ccitt crc_itu_t ata_generic pata_acpi pata_via ext2 [last unloaded: scsi_wait_scan]
Pid: 938, comm: rc.sysinit Not tainted 2.6.30-6.fc12.i686.PAE #1
Call Trace:
 [<c04434a2>] warn_slowpath_common+0x75/0x9d
 [<c050399f>] ? __writeback_single_inode+0x125/0x287
 [<c04434eb>] warn_slowpath_null+0x21/0x35
 [<c050399f>] __writeback_single_inode+0x125/0x287
 [<c0503b27>] ? sync_inode+0x26/0x54
 [<c0503b31>] sync_inode+0x30/0x54
 [<dc8676a5>] ext2_sync_inode+0x35/0x4d [ext2]
 [<dc86c2db>] ext2_xattr_set2+0x3c1/0x4f4 [ext2]
 [<dc86c9cf>] ext2_xattr_set+0x5c1/0x615 [ext2]
 [<dc86dbe0>] ext2_init_security+0x58/0x88 [ext2]
 [<dc866fdb>] ext2_new_inode+0x808/0x94a [ext2]
 [<c059f262>] ? may_create+0xd3/0xee
 [<dc8696ac>] ext2_create+0x22/0xb0 [ext2]
 [<c04f1fc4>] vfs_create+0x84/0xaf
 [<c04f2c1c>] do_filp_open+0x250/0x68d
 [<c04fcd02>] ? alloc_fd+0x38/0xed
 [<c04fcd02>] ? alloc_fd+0x38/0xed
 [<c07f5789>] ? _spin_unlock+0x30/0x45
 [<c04fcd99>] ? alloc_fd+0xcf/0xed
 [<c04e5dfd>] do_sys_open+0x58/0xe0
 [<c04e5f02>] sys_open+0x31/0x4a
 [<c0409feb>] sysenter_do_call+0x12/0x38
---[ end trace 6db0eec1553c1cd8 ]---
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:317 __writeback_single_inode+0x1d3/0x287()
Hardware name:  
Modules linked in: serio_raw pcspkr i2c_viapro 3c59x mii i2c_core usb_storage firewire_ohci via_velocity firewire_core crc_ccitt crc_itu_t ata_generic pata_acpi pata_via ext2 [last unloaded: scsi_wait_scan]
Pid: 938, comm: rc.sysinit Tainted: G        W  2.6.30-6.fc12.i686.PAE #1
Call Trace:
 [<c04434a2>] warn_slowpath_common+0x75/0x9d
 [<c0503a4d>] ? __writeback_single_inode+0x1d3/0x287
 [<c04434eb>] warn_slowpath_null+0x21/0x35
 [<c0503a4d>] __writeback_single_inode+0x1d3/0x287
 [<c0503b31>] sync_inode+0x30/0x54
 [<dc8676a5>] ext2_sync_inode+0x35/0x4d [ext2]
 [<dc86c2db>] ext2_xattr_set2+0x3c1/0x4f4 [ext2]
 [<dc86c9cf>] ext2_xattr_set+0x5c1/0x615 [ext2]
 [<dc86dbe0>] ext2_init_security+0x58/0x88 [ext2]
 [<dc866fdb>] ext2_new_inode+0x808/0x94a [ext2]
 [<c059f262>] ? may_create+0xd3/0xee
 [<dc8696ac>] ext2_create+0x22/0xb0 [ext2]
 [<c04f1fc4>] vfs_create+0x84/0xaf
 [<c04f2c1c>] do_filp_open+0x250/0x68d
 [<c04fcd02>] ? alloc_fd+0x38/0xed
 [<c04fcd02>] ? alloc_fd+0x38/0xed
 [<c07f5789>] ? _spin_unlock+0x30/0x45
 [<c04fcd99>] ? alloc_fd+0xcf/0xed
 [<c04e5dfd>] do_sys_open+0x58/0xe0
 [<c04e5f02>] sys_open+0x31/0x4a
 [<c0409feb>] sysenter_do_call+0x12/0x38
---[ end trace 6db0eec1553c1cd9 ]---
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:292 __writeback_single_inode+0x125/0x287()
Hardware name:  
Modules linked in: serio_raw pcspkr i2c_viapro 3c59x mii i2c_core usb_storage firewire_ohci via_velocity firewire_core crc_ccitt crc_itu_t ata_generic pata_acpi pata_via ext2 [last unloaded: scsi_wait_scan]
Pid: 36, comm: plymouthd Tainted: G        W  2.6.30-6.fc12.i686.PAE #1
Call Trace:
 [<c04434a2>] warn_slowpath_common+0x75/0x9d
 [<c050399f>] ? __writeback_single_inode+0x125/0x287
 [<c04434eb>] warn_slowpath_null+0x21/0x35
 [<c050399f>] __writeback_single_inode+0x125/0x287
 [<c0503b27>] ? sync_inode+0x26/0x54
 [<c0503b31>] sync_inode+0x30/0x54
 [<dc8676a5>] ext2_sync_inode+0x35/0x4d [ext2]
 [<dc86c2db>] ext2_xattr_set2+0x3c1/0x4f4 [ext2]
 [<dc86c9cf>] ext2_xattr_set+0x5c1/0x615 [ext2]
 [<dc86dbe0>] ext2_init_security+0x58/0x88 [ext2]
 [<dc866fdb>] ext2_new_inode+0x808/0x94a [ext2]
 [<c059f262>] ? may_create+0xd3/0xee
 [<dc8696ac>] ext2_create+0x22/0xb0 [ext2]
 [<c04f1fc4>] vfs_create+0x84/0xaf
 [<c04f2c1c>] do_filp_open+0x250/0x68d
 [<c04fcd02>] ? alloc_fd+0x38/0xed
 [<c04fcd02>] ? alloc_fd+0x38/0xed
 [<c07f5789>] ? _spin_unlock+0x30/0x45
 [<c04fcd99>] ? alloc_fd+0xcf/0xed
 [<c04e5dfd>] do_sys_open+0x58/0xe0
 [<c04e5f02>] sys_open+0x31/0x4a
 [<c0409feb>] sysenter_do_call+0x12/0x38
---[ end trace 6db0eec1553c1cda ]---
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:317 __writeback_single_inode+0x1d3/0x287()
Hardware name:  
Modules linked in: serio_raw pcspkr i2c_viapro 3c59x mii i2c_core usb_storage firewire_ohci via_velocity firewire_core crc_ccitt crc_itu_t ata_generic pata_acpi pata_via ext2 [last unloaded: scsi_wait_scan]
Pid: 36, comm: plymouthd Tainted: G        W  2.6.30-6.fc12.i686.PAE #1
Call Trace:
 [<c04434a2>] warn_slowpath_common+0x75/0x9d
 [<c0503a4d>] ? __writeback_single_inode+0x1d3/0x287
 [<c04434eb>] warn_slowpath_null+0x21/0x35
 [<c0503a4d>] __writeback_single_inode+0x1d3/0x287
 [<c0503b31>] sync_inode+0x30/0x54
 [<dc8676a5>] ext2_sync_inode+0x35/0x4d [ext2]
 [<dc86c2db>] ext2_xattr_set2+0x3c1/0x4f4 [ext2]
 [<dc86c9cf>] ext2_xattr_set+0x5c1/0x615 [ext2]
 [<dc86dbe0>] ext2_init_security+0x58/0x88 [ext2]
 [<dc866fdb>] ext2_new_inode+0x808/0x94a [ext2]
 [<c059f262>] ? may_create+0xd3/0xee
 [<dc8696ac>] ext2_create+0x22/0xb0 [ext2]
 [<c04f1fc4>] vfs_create+0x84/0xaf
 [<c04f2c1c>] do_filp_open+0x250/0x68d
 [<c04fcd02>] ? alloc_fd+0x38/0xed
 [<c04fcd02>] ? alloc_fd+0x38/0xed
 [<c07f5789>] ? _spin_unlock+0x30/0x45
 [<c04fcd99>] ? alloc_fd+0xcf/0xed
 [<c04e5dfd>] do_sys_open+0x58/0xe0
 [<c04e5f02>] sys_open+0x31/0x4a
 [<c0409feb>] sysenter_do_call+0x12/0x38
---[ end trace 6db0eec1553c1cdb ]---


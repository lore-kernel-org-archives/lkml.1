Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZDWCaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZDWCaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 22:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZDWCaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 22:30:05 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34200 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZDWCaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 22:30:03 -0400
Message-ID: <49EFD2A4.6080801@novell.com>
Date: Wed, 22 Apr 2009 22:29:56 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Crash in v2.6.30-rc3 (regression from 30-rc2)
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig663BF1F3AE4CE86A7B3A46CF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig663BF1F3AE4CE86A7B3A46CF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi All,

 FYI: I am seeing this when moving from 30-rc2 to 30-rc3 on a 4-way
x86_64 box.

I have since reverted back to rc2, but can easily spin up the new kernel
again to decode more info or try a fix, if desired.

One data point I do have is that the box seemed to have booted when I
forgot to add console=3DttyS0 to the kernel args.  I suspect the serial
console is just changing timing, but its 100% reproducible in this setup.=


BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff803863f8>] rb_erase+0x132/0x28c
PGD 13a11e067 PUD 13dd1d067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.1/host6/target6:0:0/6:0:0:0/type
CPU 0
Modules linked in: i5000_edac shpchp rtc_core soundcore thermal sr_mod
parport_pc processor button libphy natsemi cdrom i2c_core edac_core
parport snd_page_alloc pcspkr serio_raw pci_hotplug rtc_lib kvm_intel sg
joydev kvm usbhid hid linear ehci_hcd uhci_hcd sd_mod crc_t10dif usbcore
dm_snapshot edd fan thermal_sys hwmon dm_mod ext3 mbcache jbd
ide_pci_generic piix ide_core ata_generic ata_piix ahci libata scsi_mod
Pid: 1561, comm: vgchange Not tainted 2.6.30-rc3-vbus #30 Precision
WorkStation 490  =20
RIP: 0010:[<ffffffff803863f8>]  [<ffffffff803863f8>] rb_erase+0x132/0x28c=

RSP: 0018:ffff88013ddb9868  EFLAGS: 00010046
RAX: ffff88013b9f3c01 RBX: ffff88013b9f3c00 RCX: 0000000000000000
RDX: ffff88013b9f3c00 RSI: ffff88013b8e3e30 RDI: 0000000000000000
RBP: ffff88013ddb9878 R08: ffff88013b9f3c00 R09: 0000000000000000
R10: 0000000000000000 R11: ffff88013b0536c0 R12: ffff88013b8e3e30
R13: ffff88013b8e3e00 R14: ffff880139dd7aa8 R15: ffff88013b9f3c70
FS:  00007f39d092d780(0000) GS:ffff880028022000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000013ddbc000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process vgchange (pid: 1561, threadinfo ffff88013ddb8000, task
ffff88013c8c8400)
Stack:
 ffff88013b9f3c70 ffff88013b9f3ca0 ffff88013ddb98b8 ffffffff8037f348
 ffff88013b8e3e00 ffff88013b9f3c70 ffff880139dd7aa8 ffff88013b8e3e00
 ffff88013ac79200 ffff88013bf8e448 ffff88013ddb98e8 ffffffff8037f407
Call Trace:
 [<ffffffff8037f348>] cfq_remove_request+0x1a3/0x211
 [<ffffffff8037f407>] cfq_dispatch_insert+0x51/0x75
 [<ffffffff8037f851>] cfq_dispatch_requests+0x32c/0x433
 [<ffffffff80370531>] elv_next_request+0x18f/0x1a3
 [<ffffffff803836c5>] ? kobject_get+0x1a/0x22
 [<ffffffffa00063a6>] scsi_request_fn+0x89/0x53a [scsi_mod]
 [<ffffffff80372a01>] blk_start_queueing+0x1f/0x28
 [<ffffffff8037fc3a>] cfq_insert_request+0x24c/0x3a6
 [<ffffffff803706e2>] elv_insert+0x19d/0x25b
 [<ffffffff8037083b>] __elv_add_request+0x9b/0xa4
 [<ffffffff8037357d>] __make_request+0x3c3/0x44b
 [<ffffffff80371be2>] generic_make_request+0x358/0x3a9
 [<ffffffff80300eb5>] ? bio_alloc_bioset+0xb9/0x13d
 [<ffffffff80371cfe>] submit_bio+0xcb/0xd4
 [<ffffffff80225517>] ? default_spin_lock_flags+0x9/0xe
 [<ffffffff8030378b>] dio_bio_submit+0x66/0x7f
 [<ffffffff80304331>] __blockdev_direct_IO+0x87a/0xaa2
 [<ffffffff802ae1e3>] ? do_writepages+0x2d/0x3d
 [<ffffffff80302650>] blkdev_direct_IO+0x4e/0x50
 [<ffffffff803018c0>] ? blkdev_get_blocks+0x0/0x95
 [<ffffffff802a82df>] generic_file_aio_read+0x10d/0x5b8
 [<ffffffff80302ed8>] ? blkdev_open+0x0/0xac
 [<ffffffff802dca46>] do_sync_read+0xec/0x132
 [<ffffffff802db47f>] ? nameidata_to_filp+0x46/0x58
 [<ffffffff802579b8>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff80301bb6>] ? block_ioctl+0x3d/0x41
 [<ffffffff802e9c82>] ? vfs_ioctl+0x2f/0x7d
 [<ffffffff802ea111>] ? do_vfs_ioctl+0x441/0x47d
 [<ffffffff8034f08c>] ? security_file_permission+0x16/0x18
 [<ffffffff802dd615>] vfs_read+0xb0/0x159
 [<ffffffff802dd78c>] sys_read+0x4c/0x74
 [<ffffffff8020bd32>] system_call_fastpath+0x16/0x1b
Code: 89 4a 08 eb 04 49 89 0c 24 41 ff c9 4c 89 c3 0f 85 6b 01 00 00 e9
49 01 00 00 48 8b 7b 10 48 39 cf 0f 85 9a 00 00 00 48 8b 7b 08 <48> 8b
07 a8 01 75 1a 48 83 c8 01 4c 89 e6 48 89 07 48 83 23 fe
RIP  [<ffffffff803863f8>] rb_erase+0x132/0x28c
 RSP <ffff88013ddb9868>
CR2: 0000000000000000



--------------enig663BF1F3AE4CE86A7B3A46CF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknv0qQACgkQlOSOBdgZUxnCYwCfclnoz3O0RcS2Q85DfbCvYsCd
IsUAn1uNArfWzHDfxMU8NetJjsVvhbwM
=b+sY
-----END PGP SIGNATURE-----

--------------enig663BF1F3AE4CE86A7B3A46CF--

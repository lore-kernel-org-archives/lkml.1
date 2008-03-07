Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbYCGFXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbYCGFXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 00:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYCGFXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 00:23:17 -0500
Received: from orac.ofobscurity.com ([208.65.234.197]:58444 "EHLO
	orac.ofobscurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYCGFXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 00:23:15 -0500
X-Greylist: delayed 3236 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2008 00:23:14 EST
To: linux-kernel@vger.kernel.org
Subject: assfail during unmount xfs 2.6.24.3 [from 2.6.24.y git]
From: Chris Knadle <Chris.Knadle@coredump.us>
Reply-To: Chris.Knadle@coredump.us
Organization: CoreDump.us
Date: Thu, 6 Mar 2008 23:29:07 -0500
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1950208.3H5xZLpVi0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803062329.10486.Chris.Knadle@coredump.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1950208.3H5xZLpVi0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

During the final unmount before reboot there was an assertion failure from =
XFS=20
leading to the debug output below; I've included what was available on the=
=20
screendump, which I handwrote + transcribed.  [I also have screenshots from=
 a=20
2.1 MP camera -- they're slightly ugly but usable.]  CONFIG_KEXEC was not=20
compiled in, so I was uanble to get a crashdump via SysRq.  I'm sending thi=
s=20
along in case someone working on the XFS fs can find + fix a bug.  I'm not=
=20
sending the kernel config in this first post just as not to spam everybody=
=20
with it if it's not needed -- if desired just ask and I'll send it.
Source used: 2.6.24.y from git -- 2.6.24.3.

This is on my Desktop box, x86 system -- single P4 CPU @ 2.6 GHz, IDE disk=
=20
attached to an onboard HighPoint HPT370 controller, and running Debian Sid.

When replying please CC me, as I am not currently subscribed to the list.

Cheers.
=2D- Chris

=2D-=20

Chris Knadle
Chris.Knadle@coredump.us

=2D------------------

Cleaning up ifdown....
Deactivating swap...done.
Unmounting local filesystems...done.
Assertion failed: atomic_read(&mp->m_active_trans) =3D=3D 0, file:=20
fs/xfs/xfs_vfsops.c, line: 708
=2D-----------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:82!
infalid opcode: 0000 [#1]
Modules lined in: nvidia(P) xt_multiport iptable_filter ip_tables x_tables=
=20
ppdev lp ac battery ipv6 ext2 mbcache joydev sidewinder kqemu loop=20
snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul=20
snd_emu10k1 firmware_class snd_ac97_codec ac97_bus snd_util_mem snd_hwdep=20
parport_pc parport snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss psmouse=
=20
rtc snd_deq_dummy pcspkr serio_raw evdev snd_seq_oss snd_seq_midi snd_rawmi=
di=20
snd_seq_midi_event snd_seq snd_timer snd_seq_device emu10k1_gp gameport snd=
=20
soundcore button i2c_i801 i2c_core intel_agp iTCO_wdt agpart shpchp=20
pci_hotplug usbhid hid xfs ide_cd cdrom ata_piix ata_generic libata scsi_mo=
d=20
ide_disk floppy uhci_hcd usbcore hpt366 e1000 piix generic ide_core thermal=
=20
processor fan

Pid: 25313, comm: mount Tainted: P   (2.6.24.3-686-initrd-crk1 #1)
EIP: 0060:[>f8a67a3f>] EFLAGS: 00010292 CPU: 0
EIP is at assfail+0x1b/0x1f [xfs]
EAX: 00000061 EBX: f7faa400 ECX: ffffffff EDX: c034bda0
ESI: dfc97000 EDI: f7faa400 EBP: db175e14 ESP: db175dcc
 DS: 007b ES: 007b FS: 0000 GS: 033 SS: 0068
Process mount (pid: 25313, ti=3Ddb174000 task=3Df7c32560 task.ti=3Ddb174000)
Stack: f8a6cc60 f8a6c6b0 f8a6a135 000002c4 f8a57e38 f7faa400 f8a57ee7 00000=
000
       dfc97000 f7faa400 db175e14 f8a66ebc 00000001 f8a7fd20 f7fbd400 00000=
000
       00000001 c0162bd2 00000001 f7fbd43c ffffffff f7fbd400 c0174c1b 00000=
000
Call Trace:
 [<f8a57e38>] xfs_attr_quiesce+0x46/0x61 [xfs]
 [<f8a57ee7>] xfs_mntupdate+0x84/0xbb [xfs]
 [<f8a66ebc>] xfs_fs_remount+0x3d/0x57 [xfs]
 [<c0162bd2>] do_remount_sb+0xb5/0x101 [xfs]
 [<c0174c1b>] do_mount+0x5a9/0x65b
 [<c0148ec9>] __alloc_pages+0x5f/0x360
 [<c014430c>] find_lock_page+0x15/0x67
 [<c0150dd8>] handle_mm_fault+0x25a/0x52d
 [<c0148ec9>] __alloc_pages+0x5f/0x360
 [<c0173707>] copy_mount_options+0x28/0x113
 [<c0168b45>] getname+0x87/0xaf
 [<c0174d3f>] sys_mount+0x72/0xa4
 [<c0103cf2>] sysenter_past_esp+0x5f/0x85
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: d7 6b c7 83 c3 08 81 fb c8 02 a8 f8 75 ee 5b c3 83 ec 10 89 4c 24 0c =
89
 54 24 08 89 44 24 04 c7 04 24 60 cc a6 f8 e8 0d ed 6a c7 <0f> 0b eb fe 56 =
53
 83 ec 0c 89 c6 83 e6 07 9c 5b fa 89 0c 24 89
EIP: [<f8a67a3f>] assfail+0x1b/0x1f [xfs] SS:ESP 0068:db175dcc
=2D--[ end trace 65bd78ca1bf60304 ]---
WARNING: at kernel/exit.c:917 do_exit()
Pid: 25313, comm: mount Tainted: P         D 2.6.24.3-686-initrd-crk1 #1
 [<c0118ceb>] do_exit+0x669/0x7a4
 [<c0116767>] printk+0x1b/0x1f
 [<c010477a>] do_trap+0x0/0xbd
 [<c0104a56>] do_invalid_op+0x0/0x8a
 [<f8a67a3f>] assfail+0x1b/0x1f [xfs]
 [<f8a57e38>] xfs_attr_quiesce+0x46/0x61 [xfs]
 [<f8a57ee7>] xfs_mntupdate+0x84/0xbb [xfs]
 [<f8a66ebc>] xfs_fs_remount+0x3d/0x57 [xfs]
 [<c0162bd2>] do_remount_sb+0xb5/0x101
 [<c0174c1b>] do_mount+0x5a9/0x65b
 [<c0148ec9>] __alloc_pages+0x5f/0x360
 [<c014430c>] find_lock_page+0x15/0x67
 [<c0150dd8>] handle_mm_fault+0x25a/0x52d
 [<c0148ec9>] __alloc_pages+0x5f/0x360
 [<c0173707>] copy_mount_options+0x28/0x113
 [<c0168b45>] getname+0x87/0xaf
 [<c0174d3f>] sys_mount+0x72/0xa4
 [<c0103cf2>] sysenter_past_esp+0x5f/0x85
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
/etc/rc6.d/S60umountroot: line17: 25313 Segmentation fault mount=20
$MOUNT_FORCE_OPT -n -o remount,ro -t dummytype dummydev / 2>/dev/null

--nextPart1950208.3H5xZLpVi0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH0MSWXp5GJUAG6zwRAuQ8AJ9w8Vh1+S7DvQZjjehFQ5zGYdk39QCfaFG7
wEHsFMvUEfqczA3tgyJSqt8=
=BvEb
-----END PGP SIGNATURE-----

--nextPart1950208.3H5xZLpVi0--

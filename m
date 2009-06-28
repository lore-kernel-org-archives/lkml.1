Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbZF1C2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbZF1C2q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 22:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZF1C2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 22:28:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50293 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbZF1C2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 22:28:36 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, 534690@bugs.debian.org
In-Reply-To: <20090626115001.GA3651@cavendish.icomputing.pl>
References: <20090626115001.GA3651@cavendish.icomputing.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EtdEF98h/VkcDyKMDTZN"
Date: Sun, 28 Jun 2009 03:28:33 +0100
Message-Id: <1246156113.7980.230.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: linux-image-2.6.30-1-686: unable to unmount a loop device
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EtdEF98h/VkcDyKMDTZN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-26 at 13:50 +0200, Jakub Wilk wrote:
> Package: linux-image-2.6.30-1-686
> Version: 2.6.30-1
> Severity: normal
>=20
> # lsmod | grep -c loop
> 0
>=20
> # modprobe loop max_part=3D8
>=20
> # dd if=3D/dev/zero of=3D/tmp/fs bs=3D1M count=3D1
> 1+0 records in
> 1+0 records out
> 1048576 bytes (1.0 MB) copied, 0.00407344 s, 257 MB/s
>=20
> # mke2fs -F -q /tmp/fs
>=20
> # mkdir /tmp/mnt/
>=20
> # mount -o loop /tmp/fs /tmp/mnt/
>=20
> # umount /tmp/mnt/
> [  284.509864] BUG: unable to handle kernel NULL pointer dereference at 0=
0000060
> [  284.509902] IP: [<c01f6f27>] blkdev_ioctl+0x25/0x842
> [  284.509929] *pde =3D 00000000
> [  284.509944] Oops: 0000 [#1] SMP
> [  284.509963] last sysfs file: /sys/devices/virtual/block/loop0/removabl=
e
> [  284.509980] Modules linked in: loop ext2 tun kvm_amd kvm binfmt_misc n=
f_conntrack_ipv6 ip6table_filter ip6_tables nvidiafb fb_ddc vgastate xt_MAR=
K iptable_mangle iptable_nat nf_nat ipt_REJECT xt_tcpudp nf_conntrack_ipv4 =
nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables fuse=
 snd_hda_codec_realtek tvaudio tda7432 tuner_simple tuner_types tuner arc4 =
ecb snd_hda_intel snd_hda_codec bttv ir_common snd_hwdep i2c_algo_bit v4l2_=
common videodev v4l1_compat snd_pcm videobuf_dma_sg snd_seq snd_timer snd_s=
eq_device rt61pci crc_itu_t rt2x00pci snd videobuf_core btcx_risc rt2x00lib=
 soundcore snd_page_alloc led_class input_polldev mac80211 tveeprom cfg8021=
1 eeprom_93cx6 i2c_nforce2 i2c_core evdev processor button k8temp serio_raw=
 psmouse ext3 jbd mbcache ide_gd_mod ide_cd_mod cdrom ata_generic libata sc=
si_mod ide_pci_generic amd74xx forcedeth ide_core ohci_hcd ehci_hcd usbcore=
 floppy thermal fan thermal_sys [last unloaded: loop]
> [  284.510570]
> [  284.510581] Pid: 3328, comm: umount Not tainted (2.6.30-1-686 #1) M61S=
ME-S2
> [  284.510600] EIP: 0060:[<c01f6f27>] EFLAGS: 00010287 CPU: 1
> [  284.510617] EIP is at blkdev_ioctl+0x25/0x842

This matches the source line:
	struct gendisk *disk =3D bdev->bd_disk;

> [  284.510630] EAX: 00000000 EBX: 0000125f ECX: 0000125f EDX: 00000000

and bdev =3D=3D NULL.

> [  284.510645] ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: c3fefe08
> [  284.510662]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  284.510677] Process umount (pid: 3328, ti=3Dc3fee000 task=3Dc3d2e750 t=
ask.ti=3Dc3fee000)
> [  284.510694] Stack:
> [  284.510704]  c011dda9 c04ca6ec c3d2e750 c3cacc80 00000000 c3cacc80 c3c=
acc80 c04951c0
> [  284.510756]  c031ce8e c38630c0 00000b00 c04951c0 00000000 00000212 000=
00000 c3d2e904
> [  284.510814]  00000001 00000246 3e1b71e2 00000042 c040c840 0000000c c01=
7160e 0000000c
> [  284.510876] Call Trace:
> [  284.510886]  [<c011dda9>] ? pick_next_task_fair+0x80/0x87
> [  284.510909]  [<c031ce8e>] ? __schedule+0x719/0x746
> [  284.510931]  [<c017160e>] ? release_pages+0x11c/0x124
> [  284.510953]  [<c011cc82>] ? update_curr+0x58/0x178
> [  284.510973]  [<c031cec0>] ? schedule+0x5/0x13
> [  284.510991]  [<c031cfeb>] ? schedule_timeout+0x14/0xbd
> [  284.511011]  [<c011cf9e>] ? check_preempt_wakeup+0x139/0x173
> [  284.511031]  [<c031c6c7>] ? wait_for_common+0xc1/0x112
> [  284.511051]  [<c0121ee3>] ? default_wake_function+0x0/0x8
> [  284.511075]  [<c01a9eac>] ? ioctl_by_bdev+0x20/0x2f
> [  284.511096]  [<f8463f90>] ? loop_clr_fd+0x186/0x1a2 [loop]
> [  284.511119]  [<f8463fdb>] ? lo_release+0x2f/0x53 [loop]
[...]

Since this change, lo_release() calls loop_clr_fd() with bdev =3D NULL:

commit bb21488482bd36eae6b30b014d93619063773fd4
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Mar 2 09:29:48 2008 -0500

    [PATCH] switch loop
   =20
    ioctl doesn't need BKL here
   =20
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Most actions in loop_clr_fd() that use bdev were made conditional on
bdev !=3D NULL, with the exception of:

	if (max_part > 0)
		ioctl_by_bdev(bdev, BLKRRPART, 0);

So I think that this if() needs to test bdev as well.

Ben.

--=20
Ben Hutchings
It is impossible to make anything foolproof because fools are so ingenious.

--=-EtdEF98h/VkcDyKMDTZN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBKRtVG79ZNCRIGYgcRAmVVAKDU9zTd4oONxPXPzWcz3XWntRI/BQCgucrh
8m4Z4yOzm+pOAwOnsJXfFGE=
=nY+P
-----END PGP SIGNATURE-----

--=-EtdEF98h/VkcDyKMDTZN--

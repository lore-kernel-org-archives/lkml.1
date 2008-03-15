Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbYCOMsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbYCOMsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 08:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYCOMr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 08:47:59 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46833 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbYCOMr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 08:47:57 -0400
X-Sasl-enc: K6ec/iA2Lu29mLS8hRCvXvTFNMYyKR+jRcUrQjHOBki0 1205585276
Message-ID: <47DBC578.7050101@imap.cc>
Date: Sat, 15 Mar 2008 13:47:52 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>	 <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>	 <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net>	 <1205525184.12763.32.camel@nimitz.home.sr71.net>	 <47DAE55C.3080506@tremplin-utc.net>	 <1205530551.8167.20.camel@nimitz.home.sr71.net>	 <47DB013D.3060102@tremplin-utc.net> <1205537395.8167.31.camel@nimitz.home.sr71.net>
In-Reply-To: <1205537395.8167.31.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE8F0AF5D46A46DD5023E7677"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE8F0AF5D46A46DD5023E7677
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 15.03.2008 00:29 schrieb Dave Hansen:
> Anyway, I'm sick of too much bitching and too little coding.  Andrew,
> here's a patch for -mm that will at least shut up the spinlock warnings=
=2E

Sorry to say, it doesn't. That is, it does shut up the warning I
reported, but there's a new one appearing now instead, three lines
later. Here's the dmesg diff:

@@ -216,29 +216,30 @@
 CPU0: Thermal monitoring enabled
 Compat vDSO mapped to ffffe000.
 Checking 'hlt' instruction... OK.
-BUG: spinlock bad magic on CPU#0, swapper/0
- lock: c2c19380, .magic: 00000000, .owner: swapper/0, .owner_cpu: 0
-Pid: 0, comm: swapper Not tainted 2.6.25-rc5-mm1-testing #2
- [<c01f728c>] spin_bug+0x7c/0x87
- [<c01f72b0>] _raw_spin_unlock+0x19/0x71
- [<c0301922>] _spin_unlock+0x1d/0x3c
- [<c01981aa>] mnt_want_write+0x62/0x88
- [<c018c382>] sys_mkdirat+0x86/0xd6
- [<c04260ab>] ? clean_path+0x16/0x4a
- [<c017fd6f>] ? kfree+0xd8/0xec
- [<c018c3e2>] sys_mkdir+0x10/0x12
- [<c0426353>] do_name+0x112/0x1b3
- [<c042558b>] write_buffer+0x1d/0x2c
- [<c04255fe>] flush_window+0x64/0xb3
- [<c04272f5>] unpack_to_rootfs+0x62c/0x8b9
- [<c04275a2>] populate_rootfs+0x20/0x109
- [<c0429ed2>] ? alternative_instructions+0x153/0x158
- [<c04248f5>] start_kernel+0x343/0x355
- [<c0424019>] i386_start_kernel+0x8/0xa
- =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 Unpacking initramfs... done
-Freeing initrd memory: 8767k freed
+Freeing initrd memory: 8834k freed
 ACPI: Core revision 20070126
+INFO: trying to register non-static key.
+the code is fine but needs lockdep annotation.
+turning off the locking correctness validator.
+Pid: 0, comm: swapper Not tainted 2.6.25-rc5-mm1-testing #3
+ [<c014321e>] __lock_acquire+0x144/0xb6e
+ [<c010b1a2>] ? native_sched_clock+0xe0/0xff
+ [<c017fc57>] ? kmem_cache_alloc+0x89/0xc9
+ [<c0142ce0>] ? trace_hardirqs_on+0xe8/0x11d
+ [<c014404f>] lock_acquire+0x6a/0x90
+ [<c013b460>] ? down_trylock+0xc/0x27
+ [<c03016cb>] _spin_lock_irqsave+0x42/0x72
+ [<c013b460>] ? down_trylock+0xc/0x27
+ [<c013b460>] down_trylock+0xc/0x27
+ [<c021fa65>] acpi_os_wait_semaphore+0x67/0x13d
+ [<c023a39e>] acpi_ut_acquire_mutex+0x65/0xcf
+ [<c0230261>] acpi_ns_root_initialize+0x1a/0x289
+ [<c043ad54>] acpi_initialize_subsystem+0x47/0x6a
+ [<c043afd4>] acpi_early_init+0x57/0xf8
+ [<c04248ff>] start_kernel+0x34d/0x35a
+ [<c0424019>] i386_start_kernel+0x8/0xa
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 ACPI: Checking initramfs for custom DSDT
 Parsing all Control Methods:
 Table [DSDT](id 0001) - 637 Objects with 63 Devices 160 Methods 41 Regio=
ns

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigE8F0AF5D46A46DD5023E7677
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH28V4MdB4Whm86/kRAlCbAJ9QE44/noLVNiNUWSjymXy9DoNmSwCdG3KT
RFx0vd3TCbfC/N1W2yL31Yc=
=7yHe
-----END PGP SIGNATURE-----

--------------enigE8F0AF5D46A46DD5023E7677--

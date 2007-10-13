Return-Path: <linux-kernel-owner+w=401wt.eu-S1763287AbXJMWMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763287AbXJMWMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 18:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbXJMWMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 18:12:03 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50668 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757739AbXJMWMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 18:12:00 -0400
X-Sasl-enc: ZLiD3pBHy7dAVRSWT2/e273VZfeHS/AiNz5lbTq4JUHL 1192313518
Message-ID: <471142A8.40307@imap.cc>
Date: Sun, 14 Oct 2007 00:11:52 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: [2.6.23-mm1] CONFIG_LOCALVERSION handling broken
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE6547DD8B50355DF330DEF2B"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE6547DD8B50355DF330DEF2B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Something seems to be amiss with CONFIG_LOCALVERSION handling.

I am routinely building with
CONFIG_LOCALVERSION=3D"-testing"
CONFIG_LOCALVERSION_AUTO=3Dy
My usual sequence of "make ; sudo make modules_install install"
has worked fine for all of 2.6.23{-rc?{,-mm?},}. For 2.6.23-mm1
it fails with:

ts@xenon:~/kernel/linux-2.6.23-mm1-work> sudo make modules_install instal=
l
root's password:
  INSTALL arch/i386/crypto/aes-i586.ko
[...]
  INSTALL sound/usb/usx2y/snd-usb-usx2y.ko
if [ -r System.map -a -x /sbin/depmod ]; then /sbin/depmod -ae -F System.=
map  2.6.23-mm1; fi
sh /home/ts/kernel/linux-2.6.23-mm1-work/arch/i386/boot/install.sh 2.6.23=
-mm1 arch/i386/boot/bzImage System.map "/boot"
Root device:    /dev/system/root (mounted on / as ext3)
Module list:    processor thermal ahci pata_marvell aic7xxx fan jbd ext3 =
dm_mod edd dm-mod dm-snapshot (xennet xenblk dm-mod dm-snapshot)

Kernel image:   /boot/vmlinuz-2.6.23-mm1
Initrd image:   /boot/initrd-2.6.23-mm1
No modules found for kernel 2.6.23-mm1-testing
ts@xenon:~/kernel/linux-2.6.23-mm1-work>

That is, both "make modules_install" and "make install" omit
the "-testing" suffix, "make modules_install" installing the
modules into /lib/modules/2.6.23-mm1 instead of
/lib/modules/2.6.23-mm1-testing, and "make install" passing
"2.6.23-mm1" without the "-testing" suffix to the install.sh
script, but mkinitrd suddenly rediscovers the real kernel
version string and consequently looks for modules in
/lib/modules/2.6.23-mm1-testing, so initrd creation fails.

Ideas?

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigE6547DD8B50355DF330DEF2B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHEUKyMdB4Whm86/kRAkRgAJ9xd6O1Cr52kSa8JJ6iUDB7V1sB1ACggvK/
W2PsApfTU4k7gDbAm7S9WnA=
=+F/v
-----END PGP SIGNATURE-----

--------------enigE6547DD8B50355DF330DEF2B--

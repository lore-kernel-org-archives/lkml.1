Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZBQJKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZBQJKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZBQJKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:10:07 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:1782 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbZBQJKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:10:03 -0500
Message-ID: <499A7EE2.50108@imap.cc>
Date: Tue, 17 Feb 2009 10:09:54 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.28.[45] boot failure: request_module: runaway loop modprobe binfmt-464c
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig994980F4828A0CA5AD8DB7CB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig994980F4828A0CA5AD8DB7CB
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

My workhorse machine (Pentium D 940, Intel DG965QF board,
mirrored SATA disks), which runs fine with kernel:
ts@xenon:~> uname -a
Linux xenon 2.6.28.3-testing #1 SMP PREEMPT Mon Feb 2 23:32:07 CET 2009 i=
686 i686 i386 GNU/Linux
fails to come up with an identically configured 2.6.28.4 or 2.6.28.5
kernel. The boot process hangs at about the time the root
file system is mounted, the last messages being (scribbled
down manually on a piece of paper, please make allowances):

/dev/RAID/root: recovering journal ... clean
fsck successful. Mounting root device r/w
Mounting root /dev/RAID/root
kjournald starting. Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
request_module: runaway loop modprobe binfmt-464c
request_module: runaway loop modprobe binfmt-464c
request_module: runaway loop modprobe binfmt-464c
request_module: runaway loop modprobe binfmt-464c
request_module: runaway loop modprobe binfmt-464c

After a pause of about 15 seconds, there is another set of
messages:

CPA self-test:
 4k 3070 large 219 gb 0 x 3289[c0000000-f77fd000] miss 0
 4k 194558 large 32 gb 0 x 194590[c0000000-f77fd000] miss 0
 4k 194558 large 32 gb 0 x 194590[c0000000-f77fd000] miss 0
ok.

Then, silence. The keyboard remains operative inasmuch as I can
use the SysRq functions to sync and reboot, but otherwise the
system does not go any further. Going back to kernel 2.6.28.3
the system comes up fine again.

The most conspicuous symtpom is of course the five consecutive
"runaway loop" messages I never saw before. But before that,
the order in which the PCI and USB devices are detected also
appears surprisingly changed for a stable release.

I am prepared to bisect this if somebody reminds me how to do
that for stable releases. The tree
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
doesn't seem to have them.

Thanks
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig994980F4828A0CA5AD8DB7CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJmn7oQ3+did9BuFsRAsIpAKCLZYYO7nCPZ5GAXMZ+QqD9cfGUFACfeky+
Neuxze9cYoe0NGPvkRRSFZA=
=dMTS
-----END PGP SIGNATURE-----

--------------enig994980F4828A0CA5AD8DB7CB--

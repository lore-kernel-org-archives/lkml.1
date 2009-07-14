Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZGNQyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZGNQyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZGNQye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:54:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbZGNQye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:54:34 -0400
Date: Tue, 14 Jul 2009 18:55:08 +0200
From: Kurt Garloff <garloff@suse.de>
To: Erik Jacobson <erikj@sgi.com>,
       Linux kernel list <linux-kernel@vger.kernel.org>
Cc: Norbert Eicker <N.Eicker@fz-juelich.de>,
       Greg Kroah-Hartman <GregKH@suse.de>,
       Alexey Starikovskiy <AStarikovskiy@suse.cz>,
       Len Brown <LenB@kernel.org>
Subject: [PATCH 0/3] Resend: Discard reserved PXM bits for SRAT v1
Message-ID: <20090714165508.GD31657@tpkurt2.suse.de>
Mail-Followup-To: Kurt Garloff <garloff@suse.de>,
	Erik Jacobson <erikj@sgi.com>,
	Linux kernel list <linux-kernel@vger.kernel.org>,
	Norbert Eicker <N.Eicker@fz-juelich.de>,
	Greg Kroah-Hartman <GregKH@suse.de>,
	Alexey Starikovskiy <AStarikovskiy@suse.cz>,
	Len Brown <LenB@kernel.org>
References: <20090518093352.GC15531@tpkurt2.garloff.de> <20090622140522.GA5378@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0IvGJv3f9h+YhkrH"
Content-Disposition: inline
In-Reply-To: <20090622140522.GA5378@sgi.com>
X-Operating-System: Linux 2.6.27.23-0.1-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
Organization: SUSE Linux Products GmbH (a Novell company), Nuernberg, GF:
	Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0IvGJv3f9h+YhkrH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Erik,

On Mon, Jun 22, 2009 at 09:05:22AM -0500, Erik Jacobson wrote:
> I just wanted to post in to the thread that this patch set solved both
> the node numbering (where there was a node0 and a node2) and the issue
> where all CPUs were showing up one the first node.
>=20
> I applied the three patches against 2.6.30-git14.
>=20
> We look forward to seeing the changes integrated.

So do I.
The patches are obviously already in SUSE kernels, I'd like to see them
in mainline too.

> On this 2-socket Intel 5500 based system (Nehalem), the /sys stuff looks
> good:
>=20
> $ ls /sys/devices/system/node/node?
> /sys/devices/system/node/node0:
> cpu0  cpu2  cpulist  distance  numastat
> cpu1  cpu3  cpumap   meminfo   scan_unevictable_pages
>=20
> /sys/devices/system/node/node1:
> cpu4  cpu6  cpulist  distance  numastat
> cpu5  cpu7  cpumap   meminfo   scan_unevictable_pages
>=20
>=20
> Where as, before, it looked like this (non-ordered, all CPUs showing up
> in node 0).
>=20
> # ls -ld /sys/devices/system/node/node*
> drwxr-xr-x 2 root root 0 2009-06-18 09:30 /sys/devices/system/node/node0
> drwxr-xr-x 2 root root 0 2009-06-18 09:30 /sys/devices/system/node/node2
>=20
> [root@cct201 ~]# ls /sys/devices/system/node/node0
> cpu0  cpu2  cpu4  cpu6  cpulist  distance  numastat
> cpu1  cpu3  cpu5  cpu7  cpumap   meminfo   scan_unevictable_pages
>=20
>=20
> System details:
> - SGI Altix XE 270
> - Supermicro X8DTN v 1.1 mainboard
> - 2 sockets of Xeon X5570
=20
OK, you really observe the same here as did FZJ.
Thanks for reporting!

So let me resend the patches, rediffed against current 2.6.31rc git
in followup mails.

Len, Linus, please adopt.

Best,
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--0IvGJv3f9h+YhkrH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFKXLhsxmLh6hyYd04RAnZrAKDSz89T9ZtzcP0JiAoWZxpTkMaoGgCfRBri
Pyy+VVok1ud4S3Uh5a7ulCI=
=C1d/
-----END PGP SIGNATURE-----

--0IvGJv3f9h+YhkrH--

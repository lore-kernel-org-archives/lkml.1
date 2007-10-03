Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbXJCAm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbXJCAm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXJCAmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:42:21 -0400
Received: from proxy2.bredband.net ([195.54.101.72]:51476 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbXJCAmV (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:42:21 -0400
Subject: [BUG] sky2 errors in 2.6.23-rc9-git1
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Linux-kernel@vger.kernel.org
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U9HHakXUqiXzTKoSLdB0"
Date: Wed, 03 Oct 2007 02:42:09 +0200
Message-Id: <1191372129.26233.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U9HHakXUqiXzTKoSLdB0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,=20

Sorry about this but the latest sky2 seems damned odd.
I have been running with jumbo frames at home for quite some time but
with this kernel that doesn't work, i instead get loads of:
sky2 eth0: rx length error: status 0x5e60500 length 1510
sky2 eth0: rx length error: status 0x5e60500 length 1510
sky2 eth0: rx length error: status 0x5ea0500 length 1514
sky2 eth0: rx length error: status 0x5ea0500 length 1514

Where length can be just about anything from 800 -> MTU

That is not enough though, i also, for some reason, got several hangs:
sky2 eth0: hung mac 0:68 fifo 143 (133:76)
sky2 eth0: receiver hang detected
sky2 eth0: disabling interface
sky2 eth0: enabling interface
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control rx
sky2 eth0: hung mac 0:125 fifo 195 (93:88)
sky2 eth0: receiver hang detected
sky2 eth0: disabling interface
sky2 eth0: enabling interface
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control rx
sky2 eth0: hung mac 0:124 fifo 98 (10:108)
sky2 eth0: receiver hang detected
sky2 eth0: disabling interface
sky2 eth0: enabling interface
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control rx
sky2 eth0: hung mac 0:41 fifo 30 (187:17)
sky2 eth0: receiver hang detected
sky2 eth0: disabling interface
sky2 eth0: enabling interface
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control rx
...

All during about 2 minutes.

Could this be related to [sky2: sky2 FE+ receive status workaround]:
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dblob=
diff;f=3Ddrivers/net/sky2.c;h=3Da3de0b6127ebb537b87a1849e207909fcc333ee4;hp=
=3D0792031a5cf959a1543f32f4e0f2ab4ccb7b0ec2;hb=3D3b12e0141f7a97c3b84731b5f9=
35ed738bb6f960;hpb=3Dff0ce6845bc18292e80ea40d11c3d3a539a3fc5e

The chips being used are:
sky2 0000:02:00.0: v1.18 addr 0xdbffc000 irq 17 Yukon-EC (0xb6) rev 2
sky2 0000:02:00.0: v1.18 addr 0xfddfc000 irq 17 Yukon-EC (0xb6) rev 1

The receiver hang only happes on the REV 2 chip, which also reports:
sky2 0000:02:00.0: No interrupt generated using MSI, switching to INTx mode=
.

Ifconfig reports:
	REV 2 chip:
          RX packets:30492 errors:0 dropped:646 overruns:0 frame:646
          TX packets:29229 errors:0 dropped:0 overruns:0 carrier:0

	REV 1 chip:
          RX packets:19795 errors:0 dropped:131 overruns:0 frame:131
          TX packets:18588 errors:0 dropped:0 overruns:0 carrier:0

Let me know when jumbo frames work again, just mail me patches =3D)
(to tired to look in to it closer atm)

--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-U9HHakXUqiXzTKoSLdB0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQBHAuVe7F3Euyc51N8RApvuAJ92CWcQNNgmrDB3CuHkQXKEWIKFqQCgq3B/
+SNym4X3b5UeEHHS+NMkFx0=
=aUPc
-----END PGP SIGNATURE-----

--=-U9HHakXUqiXzTKoSLdB0--


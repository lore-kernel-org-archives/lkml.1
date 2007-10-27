Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbXJ0IMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbXJ0IMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 04:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXJ0IMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 04:12:13 -0400
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:46530 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbXJ0IMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 04:12:10 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc1-gec3b67c1 broken reg. libata-sata_nv in non NCQ mode
Date: Sat, 27 Oct 2007 10:11:49 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1546748.JL1cdgJCjB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710271011.53372.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1546748.JL1cdgJCjB
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I cannot boot above kernel when I *disable* swncq support which got added i=
n=20
sata_nv. Problem seems that some component thinks driver is in ncq mode whi=
le=20
it is not, as I see a queue depth of 31 instead of 0 on boot., ie I see=20
something like this:

ata1.00: 625142448 sectors, multi 1: LBA48 NCQ (depth 31/32)

though I disabled ncq.And then boot "hangs" at

sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t=20
DPO or FUA
 sda

while detecting partitions I guess. (Note, the boot messages are from ncq=20
enabled kernel, but look alike, at least regarding queue depth...) The kern=
el=20
doesn't really hang but tries detecting something while spitting out some=20
errors. I simply wasn't patient enough.

Anyway, I tried 2.6.23 with swncq patch on top, and here I don't have any=20
problems with swncq or w/o it. (NCQ depth also gets correctly reported). I=
=20
diffed the 2.6.23 patched driver with git one and they are nearly identical=
=20
excpet some ID changes, whcih don't affect me, es I have a MCP51 chipset. S=
o=20
something in libata changed and got broken or sata_nv wasn't adopted for th=
at=20
change.

HTH,
=2D-=20
(=C2=B0=3D                 =3D=C2=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1546748.JL1cdgJCjB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHIvLJxU2n/+9+t5gRArzhAKC81v43c/V420XOlrdkwhU6EWRkvwCg+7sg
oWgJ/zebZOUQzkMhD8x0zSo=
=eTGs
-----END PGP SIGNATURE-----

--nextPart1546748.JL1cdgJCjB--

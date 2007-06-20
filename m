Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbXFTBnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbXFTBnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 21:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbXFTBm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 21:42:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:14957 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbXFTBm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 21:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:message-id;
        b=OLSBar7mh5N8TlAj/vk+pW3nxZJx3ZfL6vaKHPZTJ/rcRtEcjmoMorZsn3j8KtDV/co4wXkkI2g/DLctMTmY+nFYUZwqyCJU7p6AsxICO29zZ0u+SIGHLSyUnjAoV7nRSTQgaWu5bcovyW19fbKODV9r/by+guB6QTdb7A+ZIik=
From: TommyDrum <mycooc@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Freezes on sata_uli hd
Date: Wed, 20 Jun 2007 03:42:32 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7787134.rX1yNgQ8li";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706200342.40018.mycooc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7787134.rX1yNgQ8li
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello everyone!

I've got this problem from a while, and maybe this time I've nailed a porti=
on=20
of it; here goes:

I'm running Gentoo Linux, latest stable gentoo-sources (2.6.20-r8). I'm hav=
ing=20
random freezes of the system, including no mouse or keyboard interaction=20
(SysRq not working), all accompanied by a stable-on HD activity led; HD see=
ms=20
not to work though, and X activity remains frozen; the only alternative is =
to=20
hard reset.
Changed memory timing in bios, swapped memory, changed SMART, changed sata=
=20
cables and ports; no avail.

/var/log/messages shows no unusual activity, so there's not an oops or othe=
r=20
significant message before freezing.

This last time the system froze only for the libata part, leaving me keyboa=
rd=20
mouse X and other HD activity stable; dmesg showed the following:

ata1: SATA max UDMA/133 cmd 0xFFFFC20000020100 ctl 0x0 bmdma 0x0 irq 35
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/133, 488397168 sectors: LBA48 NCQ (depth 31/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/133
sata_uli 0000:00:12.1: version 1.0
ata2: SATA max UDMA/133 cmd 0xEC00 ctl 0xE082 bmdma 0xD880 irq 19
ata3: SATA max UDMA/133 cmd 0xE000 ctl 0xDC02 bmdma 0xD888 irq 19
scsi1 : sata_uli
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7, max UDMA/133, 586114704 sectors: LBA48 NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 16
ata2.00: configured for UDMA/133
scsi2 : sata_uli

<snip>

ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:40:0b:3a:e9/00:00:00:00:00/e6 tag 0 cdb 0x0 data 32768 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: port is slow to respond, please be patient (Status 0xd0)
ata2: port failed to respond (30 secs, Status 0xd0)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/133
ata2: EH complete
SCSI device sdb: 586114704 512-byte hdwr sectors (300091 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support=
=20
DPO or FUA

I noticed NCQ is not enabled on that device, and trying to echo 31 to=20
queue_depth initially gives permission denied; chmod root to rw, then echo =
31=20
to queue_depth gives input/output error.

I don't know if this is relevant to the total freezes, and haven't been abl=
e=20
to find correspondence between ata devices and /dev/sdx ; if I can give you=
=20
any more info, I'll be glad to.

Meanwhile:
lspci -v to the relevant devices:

00:12.1 IDE interface: ALi Corporation ULi 5289 SATA (rev 10) (prog-if 8f=20
[Master SecP SecO PriP PriO])
        Subsystem: ASRock Incorporation Unknown device 5289
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 19
        I/O ports at ec00 [size=3D8]
        I/O ports at e080 [size=3D4]
        I/O ports at e000 [size=3D8]
        I/O ports at dc00 [size=3D4]
        I/O ports at d880 [size=3D16]

Thanks in advance,
tommy

--nextPart7787134.rX1yNgQ8li
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGeIYIgpUvhTIUBAERAtiCAJ40r/HG57axO7DRbmk8X+BJAfKXIACgk4Fz
lNHkSmoUeDUKs/x8X8Dt/9w=
=/GFF
-----END PGP SIGNATURE-----

--nextPart7787134.rX1yNgQ8li--

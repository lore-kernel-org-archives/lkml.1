Return-Path: <linux-kernel-owner+w=401wt.eu-S964885AbXFFF2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbXFFF2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 01:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933860AbXFFF2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 01:28:35 -0400
Received: from iucha.net ([209.98.146.184]:38207 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933421AbXFFF2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 01:28:34 -0400
Date: Wed, 6 Jun 2007 00:28:33 -0500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: spurious completions during NCQ?
Message-ID: <20070606052833.GM22850@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p1Od3smaOkJqivj4"
Content-Disposition: inline
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--p1Od3smaOkJqivj4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I was working on a I/O heavy workload (parsing 100K spam messages to
extract certain structures) when I got this in the kernel log:

[ 2320.132893] ata1.00: exception Emask 0x2 SAct 0x701fffff SErr 0x0 action=
 0x2 frozen
[ 2320.132899] ata1.00: (spurious completions during NCQ issue=3D0x0 SAct=
=3D0x701fffff FIS=3D005040a1:08000000)
[ 2320.132905] ata1.00: cmd 61/10:00:59:fc:d0/00:00:07:00:00/40 tag 0 cdb 0=
x0 data 8192 out
[ 2320.132906]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132911] ata1.00: cmd 61/10:08:69:fc:d0/00:00:07:00:00/40 tag 1 cdb 0=
x0 data 8192 out
[ 2320.132913]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132918] ata1.00: cmd 61/08:10:19:4c:d1/00:00:07:00:00/40 tag 2 cdb 0=
x0 data 4096 out
[ 2320.132919]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132924] ata1.00: cmd 61/01:18:fb:27:0f/00:00:08:00:00/40 tag 3 cdb 0=
x0 data 512 out
[ 2320.132925]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132930] ata1.00: cmd 61/08:20:11:28:0f/00:00:08:00:00/40 tag 4 cdb 0=
x0 data 4096 out
[ 2320.132932]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132937] ata1.00: cmd 61/08:28:91:92:17/00:00:08:00:00/40 tag 5 cdb 0=
x0 data 4096 out
[ 2320.132938]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132943] ata1.00: cmd 61/08:30:99:b3:17/00:00:08:00:00/40 tag 6 cdb 0=
x0 data 4096 out
[ 2320.132944]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132949] ata1.00: cmd 61/01:38:5b:56:4b/00:00:05:00:00/40 tag 7 cdb 0=
x0 data 512 out
[ 2320.132950]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132956] ata1.00: cmd 61/08:40:71:56:4b/00:00:05:00:00/40 tag 8 cdb 0=
x0 data 4096 out
[ 2320.132957]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132962] ata1.00: cmd 61/08:48:09:cf:5a/00:00:05:00:00/40 tag 9 cdb 0=
x0 data 4096 out
[ 2320.132963]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132968] ata1.00: cmd 61/01:50:3b:af:8b/00:00:05:00:00/40 tag 10 cdb =
0x0 data 512 out
[ 2320.132969]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132974] ata1.00: cmd 61/08:58:51:af:8b/00:00:05:00:00/40 tag 11 cdb =
0x0 data 4096 out
[ 2320.132976]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132981] ata1.00: cmd 61/08:60:d9:f1:8d/00:00:05:00:00/40 tag 12 cdb =
0x0 data 4096 out
[ 2320.132982]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132987] ata1.00: cmd 61/08:68:49:bd:8e/00:00:05:00:00/40 tag 13 cdb =
0x0 data 4096 out
[ 2320.132988]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.132993] ata1.00: cmd 61/08:70:d9:63:d1/00:00:05:00:00/40 tag 14 cdb =
0x0 data 4096 out
[ 2320.132995]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.133000] ata1.00: cmd 61/08:78:91:39:0f/00:00:06:00:00/40 tag 15 cdb =
0x0 data 4096 out
[ 2320.133001]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.133006] ata1.00: cmd 61/08:80:49:30:97/00:00:06:00:00/40 tag 16 cdb =
0x0 data 4096 out
[ 2320.133007]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.133013] ata1.00: cmd 61/08:88:41:c0:d0/00:00:06:00:00/40 tag 17 cdb =
0x0 data 4096 out
[ 2320.133014]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.133019] ata1.00: cmd 61/08:90:b9:8c:d1/00:00:06:00:00/40 tag 18 cdb =
0x0 data 4096 out
[ 2320.133020]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.133025] ata1.00: cmd 61/01:98:1b:cf:ce/00:00:07:00:00/40 tag 19 cdb =
0x0 data 512 out
[ 2320.133027]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.133032] ata1.00: cmd 61/08:a0:31:cf:ce/00:00:07:00:00/40 tag 20 cdb =
0x0 data 4096 out
[ 2320.133033]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.133038] ata1.00: cmd 61/10:e0:41:af:8b/00:00:05:00:00/40 tag 28 cdb =
0x0 data 8192 out
[ 2320.133039]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.133044] ata1.00: cmd 61/01:e8:ba:12:8d/00:00:06:00:00/40 tag 29 cdb =
0x0 data 512 out
[ 2320.133046]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.133051] ata1.00: cmd 61/10:f0:c1:12:8d/00:00:06:00:00/40 tag 30 cdb =
0x0 data 8192 out
[ 2320.133052]          res 50/00:08:31:cf:ce/00:00:07:00:00/40 Emask 0x2 (=
HSM violation)
[ 2320.378387] ata1: soft resetting port
[ 2320.442169] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2320.460012] ata1.00: ata_hpa_resize 1: sectors =3D 156301488, hpa_sector=
s =3D 156301488
[ 2320.461395] ata1.00: ata_hpa_resize 1: sectors =3D 156301488, hpa_sector=
s =3D 156301488
[ 2320.461402] ata1.00: configured for UDMA/100
[ 2320.461460] ata1: EH complete
[ 2320.461868] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
[ 2320.462012] sda: Write Protect is off
[ 2320.462016] sda: Mode Sense: 00 3a 00 00
[ 2320.462203] SCSI device sda: write cache: enabled, read cache: enabled, =
doesn't support DPO or FUA

This is on a Thinkpad T60 with 2 GB RAM, running Ubuntu 7.04 (kernel
2.6.20-16-generic).  No proprietary drivers (ok, maybe the Intel
Wi-Fi - but that should not count).

The laptop came with Windows but I blew that away - did I mess some
thing up regarding HPA and its ilk?

Thanks,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--p1Od3smaOkJqivj4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZkYAND0rFCN2b1sRAiJqAJ0YhcKK3bymB+G/cR0jakr2QT+BXQCfRzj5
SVeJNt51e2MsEd4f+5jZGt0=
=D6q4
-----END PGP SIGNATURE-----

--p1Od3smaOkJqivj4--

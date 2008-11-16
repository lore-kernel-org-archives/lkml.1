Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYKPM7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYKPM7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYKPM7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:59:15 -0500
Received: from mx40.mail.ru ([194.67.23.36]:52970 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbYKPM7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:59:14 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.28-rc3: WARN_ON(ap->nr_active_links) in ata_eh_finish() with pata_ali DMA CD-ROM
Date: Sun, 16 Nov 2008 15:59:07 +0300
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200811042128.10356.arvidjaar@mail.ru> <49194B8F.80104@kernel.org>
In-Reply-To: <49194B8F.80104@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7056711.X2z9AYzGiS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811161559.08981.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7056711.X2z9AYzGiS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 11 November 2008, Tejun Heo wrote:
> Andrey Borzenkov wrote:
> > Every now and then I give pata_ali CD-ROM DMA a test. This time I got
> > someting new - not only usual timeouts but also WARN_ON. There was a
> > whole bunch of subsequent WARN_ON's, but they are likely to be just
> > followup errors.
> >=20
> > Also, in the past ejecting media from drive would abort processing and
> > all commands waiting for completion would return to prompt. Now they
> > seem to hang forever.
>=20
> The next -rc should fix this.  Thanks.
>=20


rc5 is the first release ever that correctly falls back to PIO from DMA
on ATAPI connected to pata_ali. Wow! Thank you!

[ 5882.999971] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 fr=
ozen
[ 5883.000023] ata2.00: cmd a0/01:00:00:00:08/00:00:00:00:00/a0 tag 0 dma 2=
048 in
[ 5883.000027]          cdb 28 00 00 00 00 1a 00 00  01 00 00 00 00 00 00 00
[ 5883.000032]          res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (=
timeout)
[ 5883.000046] ata2.00: status: { DRDY }
[ 5883.000162] ata2: soft resetting link
[ 5883.160062] ata2.00: configured for UDMA/33
[ 5883.160391] ata2: EH complete
[ 5913.999844] ata2.00: limiting speed to UDMA/25:PIO4
[ 5913.999885] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 fr=
ozen
[ 5913.999917] ata2.00: cmd a0/01:00:00:00:08/00:00:00:00:00/a0 tag 0 dma 2=
048 in
[ 5913.999922]          cdb 28 00 00 00 00 1a 00 00  01 00 00 00 00 00 00 00
[ 5913.999927]          res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (=
timeout)
[ 5913.999941] ata2.00: status: { DRDY }
[ 5914.000064] ata2: soft resetting link
[ 5914.160239] ata2.00: configured for UDMA/25
[ 5914.160601] ata2: EH complete
[ 5944.999646] ata2.00: limiting speed to PIO4
[ 5944.999682] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 fr=
ozen
[ 5944.999715] ata2.00: cmd a0/01:00:00:00:08/00:00:00:00:00/a0 tag 0 dma 2=
048 in
[ 5944.999719]          cdb 28 00 00 00 00 1a 00 00  01 00 00 00 00 00 00 00
[ 5944.999724]          res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (=
timeout)
[ 5944.999738] ata2.00: status: { DRDY }
[ 5944.999852] ata2: soft resetting link
[ 5945.154330] ata2.00: configured for PIO4
[ 5945.154693] ata2: EH complete

--nextPart7056711.X2z9AYzGiS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkgGRwACgkQR6LMutpd94zjDACdG5hVrLHbC2S1W3uYhD/qUpmq
yAgAn1zFCNlivbEe61S/ZtA6is7ptMFh
=kdBT
-----END PGP SIGNATURE-----

--nextPart7056711.X2z9AYzGiS--

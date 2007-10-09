Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbXJIL0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbXJIL0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 07:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXJIL0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 07:26:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:43453 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752354AbXJIL0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 07:26:02 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX1+bFGhmx6ObtJ0Ht2oY2FZG+vmfJtcfNW48PlAWBM
	xFVriZS3iwLecx
Date: Tue, 9 Oct 2007 13:25:53 +0200
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange network related data corruption
Message-ID: <20071009132553.439f7d8b@cp771133>
In-Reply-To: <200710081401.32375.vda.linux@googlemail.com>
References: <20071007184741.3b1951c1@highlander.home.lan>
	<200710081401.32375.vda.linux@googlemail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Bxr7O_Ggxy6x7ruvQkrFfHa";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Bxr7O_Ggxy6x7ruvQkrFfHa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Oct 2007 14:01:32 +0100
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> On Sunday 07 October 2007 17:47, Malte Schr=C3=B6der wrote:
> > Hello,
> > I am encountering some strange data corruption when transferring
> > data from one of my PCs that I use as a file-server.
> >=20
> > on the server:
> > FILE=3D<large file>; | cut -d" " -f1 | nc -lp5000 -q0; while nc
> > -lp5000 -q0 < $FILE; do : ; done
>=20
> $ cat z
> FILE=3Dz; | cut -d" " -f1 | nc -lp5000 -q0; while nc -lp5000 -q0 < $FILE;=
 do : ; done

Sorry, there is a copy'n'paste error in my post, correct line would be:
FILE=3Dz ; sha1sum $FILE | cut -d" " -f1 | nc -lp5000 -q0; while nc -lp5000=
 -q0 < $FILE; do : ;done

>=20
> $ sh z
> z: line 1: syntax error near unexpected token `|'
> z: line 1: `FILE=3Dz; | cut -d" " -f1 | nc -lp5000 -q0; while nc -lp5000 =
-q0 < $FILE; do : ; done'
>=20
> > on the client:
> > H=3D<server>; SUM=3D$(nc -q0 $H 5000);sleep 1s; while nc -q0 $H 5000 |
> > sha1sum | (grep -v $SUM || echo -n .); do sleep 1s ;done
> >=20
> > (output looks somewhat like this:
> > ..............6dd5fb1ce29d270acdfbb02d00921bf75d141773  -
> > ...
> > )
> >=20
> > I would expect the sha1sum to be the same in every pass (assuming the
> > source file does not change). But every few passes (with no apparent
> > pattern) there is a different sum returned. I first noticed this when
> > transferring large files (backups) with with SMB and NFS(v3 and v4) but
> > to rule that out I tried netcat in the way noted above.
>=20
> Does it happen over loopback?

I just tried a few times and yes, it also happens on loopback, but
much less frequently. Now I am really confused ...

>=20
> tcpdump / tcpflow may help seeing whether there is some corruption
> (TCP checksumming should have catched that, but worth looking into).
> Basically, you wait for "wrong" checksum to appear, then
> you stop script and look into tcpdump/tcpflow logs.
> --
> vda
>=20

--Sig_/Bxr7O_Ggxy6x7ruvQkrFfHa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHC2VG4q3E2oMjYtURAmqBAKC8V2bW6ko5Yr3C8EHhSgm4s9LrYwCfWTZV
bzKtOhpZPzfS7V9PUXQ/fNk=
=hJ65
-----END PGP SIGNATURE-----

--Sig_/Bxr7O_Ggxy6x7ruvQkrFfHa--

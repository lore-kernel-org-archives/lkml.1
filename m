Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYGMLuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYGMLuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 07:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYGMLuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 07:50:04 -0400
Received: from mail5.tpgi.com.au ([203.12.160.101]:56734 "EHLO
	mail5.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYGMLuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 07:50:03 -0400
X-Greylist: delayed 8346 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jul 2008 07:50:02 EDT
X-TPG-Antivirus: Passed
Date: Sun, 13 Jul 2008 21:49:44 +1000
From: Alex Samad <alex@samad.com.au>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, Edward Hsu <edward_hsu@realtek.com.tw>
Subject: Re: Page swap allocation failure 2.6.25
Message-ID: <20080713114944.GA3841@samad.com.au>
Mail-Followup-To: Francois Romieu <romieu@fr.zoreil.com>,
	linux-kernel@vger.kernel.org,
	Edward Hsu <edward_hsu@realtek.com.tw>
References: <20080713093047.GB661@samad.com.au> <20080713110222.GA16817@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20080713110222.GA16817@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 13, 2008 at 01:02:22PM +0200, Francois Romieu wrote:
> Alex Samad <alex@samad.com.au> :
> [...]
> > For a while now I have been receiving page swap allocation failures
> >=20
> >=20
> > Similar to http://lkml.org/lkml/2008/6/10/3 and
>=20
> Order 0 failure. Your is an order 2 one.
>=20
> > http://lkml.org/lkml/2008/2/19/298
>=20
> Order 3 failure which was fixed with the e1000e driver.


not sure about these, I will take your word for it.

>=20
> > and I have filed a bug with debian (Bug#486300)
> >=20
> >=20
> > It seems like any time I put the system under load, transferring large
> > files across the network  (1G nic, a r8186 and forcedeth and a
> > broadcom).  I keep getting these errors
>=20
> May I assume that you are working with a MTU greater than 1500 bytes on
> each interface ? If so plese add netdev@vger.kernel.org to the Cc: and
> remove linux-kernel@ from the Cc:.

I have 3 boxes, 2 are setup with > 1500 mtu and 1 isn't (the one with
the r8186 driver), I have tested with >1500 mtu and with mtu =3D 1500 with
the same result.

>=20
> [...]
> > Jul 13 13:28:30 nas kernel: [  648.120756]  [<ffffffff881b525f>]
> > :r8168:rtl8168_rx_fill+0x64/0x106
>=20
> It looks more like Realtek's out-of-tree driver than like the in-kernel
> one. Is it a customised kernel ?
The kernel is a stock debian amd64 kernel, not customised by me.

I did build the r8168 from the realtek site.

bit more info on the setup

I have 2 laptops (both HP's), 1(A) running Vista 1(B) running Debian lenny/=
sid
(2.6.25). I have three servers 2 shuttles (forcedeth) (multimedia & hufpuf =
) 1 gigabyte
(realtek) (nas).

The nas box is the one I coped the error from the syslog. it is
primarily a nfs nas.  Hufpuf is the samba box, it used to be the nas
box. it currently mounts a few (large) shares from nas.  Multimedia is a
backup server.

A & B & NAS have 1500 MTU

multimedia and hufpuf can run with 9100 mtu

I have tried
i) coping files from A to hufpuf (smb) which then sends it on to nas via
nfs
ii) copy files from B to nas (nfs)
iii) scp from B to hufpuf and then on to nas via nfs
iv) scp from B to nas
v) scp from hufpuf to nas
vi) scp from hufpuf to multimedia
vii) scp from multimedia to nas
viii) hufpuf nfs to nas
ix) multimedia nfs to nas

all of these have caused these errors.

when I was testing again today, I noticed when I was coping from A to
hufpuf and then onto nas. that smaller files say < 200M would go okay,
anything greater (or if the total of the files was greater) then I would
start to get the errors.
=20

>=20
> [...]
> > Help
>=20
> Don't panic.
not panicing yet but I am a bit concerned. the data seems to be okay
even after these errors


>=20
> --=20
> Ueimor
>=20

--=20
"You see, the Senate wants to take away some of the powers of the administr=
ative branch."

	- George W. Bush
09/19/2002
Washington, DC

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh569QACgkQkZz88chpJ2OeUwCg1nXz1Vit3zJuX1t3lPfxnF7A
HnkAoJMNQX+NeoHji09dlr1udGpTHCEn
=caHr
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--

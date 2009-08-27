Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbZH0TOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbZH0TOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 15:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZH0TOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 15:14:12 -0400
Received: from mx01.freesources.org ([80.237.252.149]:46743 "EHLO
	mail01.freesources.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZH0TOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 15:14:12 -0400
X-Greylist: delayed 2341 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2009 15:14:11 EDT
Date: Thu, 27 Aug 2009 20:35:01 +0200
From: Jonas Meurer <jonas@freesources.org>
To: Randy Dunlap <randy.dunlap@oracle.com>, 541835@bugs.debian.org
Cc: Celejar <celejar@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20090827183500.GC24973@resivo.wgnet.de>
References: <20090825195852.1dfacb6c.celejar@gmail.com>
 <20090827095516.6817be1e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Content-Disposition: inline
In-Reply-To: <20090827095516.6817be1e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 88.69.167.238
X-SA-Exim-Mail-From: jonas@freesources.org
Subject: Re: [pkg-cryptsetup-devel] Bug#541835: crypto configuration /
 dependencies broken
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on mail01.freesources.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hey,

On 27/08/2009 Randy Dunlap wrote:
> On Tue, 25 Aug 2009 19:58:52 -0400 Celejar wrote:
>=20
> > I'm having a pretty bizarre problem with my kernel crypto
> > configuration.  I need support for a bog standard LUKS (aes /
> > cbc-essiv:sha256) / cryptsetup installation, but even after I enable
> > virtually everything in the crypto section of the kernel configs, cbc
> > fails to load.  All the relevant modules are exist (dm-mod, dm-crypt,
> > crypto_blkcipher, crypto_algapi, crypto_hash, aes_generic,
> > sha256_generic), but even after modprobing / insmoding
> > everything, /proc/crypto shows that aes and sha is there, but not cbc.
> >=20
> > The problem has been reproduced (using my kernel config) by Jonas
> > Meurer, the Debian cryptsetup maintainer, so it's not just me ;).
> > We've tried numerous different kernel versions in the .30 / .31 range.
> >=20
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D541835
> >=20
> > Does this mean that something else somewhere in the kernel needs to be
> > configured but isn't, and the necessary dependency isn't properly
> > declared?
> >=20
> > My config is at:
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=3D45;filename=3Dconfig=
-2.6.31-rc6-lizzie-00042-gb2add73;att=3D1;bug=3D541835
> >=20
> > [I'm not subscribed to lkml; please cc me on responses]
>=20
>=20
> You could try/test a patch that was just posted:
>   http://lkml.org/lkml/2009/8/27/249

that patch seems to be for ecryptfs only, while Celejar uses dm-crypt.
second, the patch just ensures that CRYPTO_ECB and CRYPTO_CBC are
selected along with ECRYPT_FS. but Celejar does have both CRYPTO_ECB and
CRYPTO_CBC selected.

the problem rather is that loading the cbc blockcipher module simply
does nothing. the module is listed in /proc/modules, but the blockcipher
is still missing from /proc/crypto.

the problem is not reproducible with a debian/unstable 2.6.30.6 kernel,
even though it has cbc compiled as module as well. but if I recompile
the same kernel sources with Celejars kernel .config, the problem
occurs. thus it must be related to the kernel config in some way.

greetings,
 jonas



--qjNfmADvan18RZcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqW0dQACgkQd6lUs+JfIQI44QCfYUZo+kTRNLejLzk6P2l9xxmA
+zsAn27R0reMdFx3/tWv3a12VzBAzKoV
=VOjs
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--

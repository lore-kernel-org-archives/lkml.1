Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZIKJcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZIKJcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 05:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZIKJcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 05:32:00 -0400
Received: from os.eurotux.com ([216.75.63.6]:43943 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbZIKJb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:31:58 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 05:31:58 EDT
Date: Fri, 11 Sep 2009 10:25:17 +0100
From: Luciano Rocha <luciano@eurotux.com>
To: Brian McGrew <brian@visionpro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmap vs. real memory
Message-ID: <20090911092517.GA5450@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Brian McGrew <brian@visionpro.com>, linux-kernel@vger.kernel.org
References: <C6CECDE3.13A4A%brian@visionpro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <C6CECDE3.13A4A%brian@visionpro.com>
User-Agent: Mutt/1.5.20 (2009-08-08)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2009 at 03:38:11PM -0700, Brian McGrew wrote:
> Good afternoon all,
>=20
> Right now, I'm in what appears [to me] to be a very tricky situation.  We
> have several programs that all need access to the same memory.  Currently,
> we use mmap and map to a file on disk like this:
>=20
> const u_long    kCommsegSize            =3D 1024L * 1024L * 1024L;
> const u_long    kCommsegMappedAddress   =3D 0xb0000000;
>=20
> And then the code is:
>=20
>     char *cseg_addr =3D reinterpret_cast<char *>(mmap(
>             reinterpret_cast<char *>(kCommsegMappedAddress),
>             size,
>             PROT_READ  | PROT_WRITE,
>             MAP_SHARED | MAP_FIXED,
>             fd,
>             0));
>     gShmemOffset =3D kCommsegMappedAddress - kCommseg;
>     return(cseg_addr);
>=20
> And, all of this has worked great ever since we went from a physical shar=
ed
> memory board on a vme bus to emulating shared memory on the computer.  In
> the beginning, kCommsegSize was only 4MB (4L * 1024L * 1024L).
>=20
> Now that we are needing more and more shared memory, we're seeing random
> performance issues.  With 16MB, 64MB and 256MB (in recent past) all was
> good.  But now, trying to allocate 1GB of shared memory, we see it taking
> anywhere from .6 to 9 SEONDS to access the file.  No good!
>=20
> What I'm wondering and needed to do is map a chunk of mymoery (1GB today,
> maybe 2GB later on) so that all my apps can access it.  Short of creating=
 a
> ramdisk and moving the mmap'ed file to ramdisk, what is the best way to do
> this???

Were are you storing the file? For memory-only, you should use /dev/shm.
Another more portable solution is to use shm_open(3), that will open the
file were the system wants it.

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqqF30ACgkQinSul6a7oB+miwCeNf5Aaat9DqgE5VezeZ9wXvS0
rRQAn1MU9WDzBUTPFZK1jlhCb4lo9pRw
=bVvP
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--

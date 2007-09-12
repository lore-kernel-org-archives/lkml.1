Return-Path: <linux-kernel-owner+w=401wt.eu-S965394AbXILDSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965394AbXILDSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 23:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbXILDSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 23:18:15 -0400
Received: from ozlabs.org ([203.10.76.45]:39571 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbXILDSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 23:18:14 -0400
Subject: Re: SYSFS: need a noncaching read
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Heiko Schocher <hs@denx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Detlev Zundel <dzu@denx.de>
In-Reply-To: <20070912020526.GD16001@localhost.localdomain>
References: <1189503798.6674.46.camel@Zeus.EmbLux>
	 <20070912020526.GD16001@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yL/TQX95aW0JgamhmoYK"
Date: Wed, 12 Sep 2007 13:18:11 +1000
Message-Id: <1189567091.17835.3.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yL/TQX95aW0JgamhmoYK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-12 at 12:05 +1000, David Gibson wrote:
> On Tue, Sep 11, 2007 at 11:43:17AM +0200, Heiko Schocher wrote:
> > Hello,
> >=20
> > I have developed a device driver and use the sysFS to export some
> > registers to userspace. I opened the sysFS File for one register and di=
d
> > some reads from this File, but I alwas becoming the same value from the
> > register, whats not OK, because they are changing. So I found out that
> > the sysFS caches the reads ... :-(
> >=20
> > Is there a way to retrigger the reads (in that way, that the sysFS
> > rereads the values from the driver), without closing and opening the
> > sysFS Files? Or must I better use the ioctl () Driver-interface for
> > exporting these registers?
> >=20
> > I am asking this, because I must read every 10 ms 2 registers, so
> > doing a open/read/close for reading one registers is a little bit too
> > much overhead.
> >=20
> > I made a sysFS seek function, which retriggers the read, and that works
> > fine, but I have again 2 syscalls, whats also is not optimal.
> >=20
> > Or can we make a open () with a (new?)Flag, that informs the sysFS to
> > always reread the values from the underlying driver?
> >=20
> > Or a new flag in the "struct attribute_group" in include/linux/sysfs.h,
> > which let the sysfs rereading the values?
>=20
> This sounds more like sysfs is really not the right interface for
> polling your registers.  You would probably be better off having your
> driver export a character device from which the register values could
> be read.

I thought relay(fs) was the trendy way to do this these days?

Documentation/filesystems/relay.txt

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-yL/TQX95aW0JgamhmoYK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG51pzdSjSd0sB4dIRAj6kAKCcrXZQQyYF3CuRR5ecgN2GJJ3u1wCglpsb
sxLP+sBnwApo7sSmM1K17sg=
=M5UB
-----END PGP SIGNATURE-----

--=-yL/TQX95aW0JgamhmoYK--


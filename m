Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYH0I1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYH0I1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYH0I0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:26:53 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:56421 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYH0I0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:26:52 -0400
Date: Wed, 27 Aug 2008 10:26:50 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [RFC v2][PATCH 7/9] Infrastructure for shared objects
Message-ID: <20080827082650.GF4784@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0808202306170.17436@takamine.ncl.cs.columbia.edu> <20080821104016.GJ581@hawkmoon.kerlabs.com> <1219770064.8680.28.camel@nimitz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-9067-1219825479-0001-2"
Content-Disposition: inline
In-Reply-To: <1219770064.8680.28.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-9067-1219825479-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2008 at 10:01:04AM -0700, Dave Hansen wrote:
> On Thu, 2008-08-21 at 12:40 +0200, Louis Rilling wrote:
> >=20
> > > +struct cr_objhash {
> > > +     struct cr_obj **hash;
> > > +     int next_tag;
> > > +};
> > > +
> > > +#define CR_OBJHASH_NBITS  10 /* 10 bits =3D 1K buckets */
> > > +#define CR_OBJHASH_ORDER  0  /* 1K buckets * 4 bytes/bucket =3D 1
> > page */
> >=20
> > Only true when PAGE_SIZE =3D=3D 4K and in 32bits. Perhaps like below?
> >=20
> > #define CR_OBJHASH_BUCKET_NBITS (BITS_PER_LONG =3D=3D 64 ? 3 : 2)
> > #define CR_MIN_OBJHASH_NBITS ((PAGE_SHIFT - CR_OBJHASH_BUCKET_NBITS)
> > #define CR_OBJHASH_NBITS (CR_MIN_OBJHASH_NBITS >=3D 10 ?
> > CR_MIN_OBJHASH_NBITS : 10)
> > #define CR_OBJHASH_ORDER (CR_OBJHASH_NBITS + CR_OBJHASH_BUCKET_NBITS -
> > PAGE_SHIFT)
>=20
> Gah.  Can't we just use the existing radix tree or hash implementations
> we already have?

AFAICS, all hash implementations work like this (I'm referring to pid hashes
and compat_ioctl hashes for instance). The only common code is the hash
functions, which Oren seems to have used.

Radix trees may be an alternative, given that object tags are sequentially
generated in some way. I have no idea about the simplicity we can gain thou=
gh.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-9067-1219825479-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFItQ/KVKcRuvQ9Q1QRAnP8AJ9KgIcf0TwVw0PGVAX7Y0SEFx0B/gCcD3CW
Qa6rZQy8I8WhtpOU2iwcMmY=
=wYLg
-----END PGP SIGNATURE-----

--=_bohort-9067-1219825479-0001-2--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbZF0CPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbZF0CPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 22:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZF0CO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 22:14:57 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:4377 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbZF0CO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 22:14:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=VOTGCjv3efk3n2nm5UD9yhObGB/p4SNkL9GxihFa9GQUYJka8QA9IQG7MXOmon6bQc
         biiSuKe2aOBYQd2N7UAE31yjdyheSw6Ok5wO8t4LwiB0ISAfU44uQM3tgaYWWqer56La
         7oszq0JAgECZy1nWIQrefJTxYrM8fu12WQGxE=
Subject: Re: [PATCHv2 2/2] PCAP regulator driver (for 2.6.32)
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Eric Miao <eric.y.miao@gmail.com>, David Brownell <david-b@pacbell.net>,
       Pierre Ossman <pierre@ossman.eu>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <20090627010434.GC4379@sirena.org.uk>
References: <1246057721.10360.318.camel@brutus>
	 <20090627010434.GC4379@sirena.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tsZFbJDFZQpdoekVMBsG"
Date: Fri, 26 Jun 2009 23:14:43 -0300
Message-Id: <1246068883.10360.367.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tsZFbJDFZQpdoekVMBsG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em S=C3=A1b, 2009-06-27 =C3=A0s 02:04 +0100, Mark Brown escreveu:
> > +	if (vreg->n_voltages =3D=3D 1)
> > +		return -EINVAL;
>=20
> It'd be a little more friendly to check if the supported voltage is in
> the requested range.  However, that'd only be an issue if constraints
> allowed voltage changes which is obviously broken so a comment to that
> effect would be enough.  I wouldn't have mentioned it but...

Ok, I will add a comment.

> > +	ezx_pcap_read(pcap, vreg->reg, &tmp);
> > +	tmp |=3D (1 << vreg->en);
> > +	ezx_pcap_write(pcap, vreg->reg, tmp);
>=20
> This read/modify/write cycle is racy; the individual regulator is locked
> by the core but this register is shared between all regulators on the
> chip so if two are being updated at once things will go wrong.  Most of
> the MFDs have a set_bits() function that does an atomic read/modify/write
> cycle for cases like this.

Good point, thanks! :)

--=20
Daniel Ribeiro

--=-tsZFbJDFZQpdoekVMBsG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpFgJIACgkQw3OYl0G0liTlzACcCWjthtvumlYb2rY5+ae+oWhV
3jgAn3NRTUOXQwLeutiY9fQf1OE6Rq2l
=MoDa
-----END PGP SIGNATURE-----

--=-tsZFbJDFZQpdoekVMBsG--


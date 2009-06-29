Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZF2Urc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZF2Urc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZF2UrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:47:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:28076 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZF2UrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=HjEkZSx8vCod6+js9sdqHVIGkjd47KZw4eyiPjzh3ygYsgOcnsk98R39nZZgjNijI+
         tUtSW4QfIxH019ihmy2f/vWzzKVZ/O3L3oZ4eZAbquJrBkPekYZvaE5qeXABxlGPA5zA
         sWyB1HfPpEapDYO9o0wOgPUpccncTlooitnIU=
Subject: Re: [PATCH] PCAP misc input driver (for 2.6.32)
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, inux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Ilya Petrov <ilya.muromec@gmail.com>
In-Reply-To: <20090629061434.GD12821@dtor-d630.eng.vmware.com>
References: <1246122592.3727.20.camel@brutus>
	 <20090629061434.GD12821@dtor-d630.eng.vmware.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uNw0TazYwdnAlF41viYz"
Date: Mon, 29 Jun 2009 17:47:07 -0300
Message-Id: <1246308427.18231.43.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uNw0TazYwdnAlF41viYz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em Dom, 2009-06-28 =C3=A0s 23:14 -0700, Dmitry Torokhov escreveu:
> >  drivers/input/keyboard/Kconfig     |    7 ++
> >  drivers/input/keyboard/Makefile    |    1 +
> >  drivers/input/keyboard/pcap_keys.c |  152 ++++++++++++++++++++++++++++=
++++++++
> >  3 files changed, 160 insertions(+), 0 deletions(-)
> >=20
>=20
> First of all I think the driver should live in misc, not in keyboard,
> since it is not a full-fledged keyboard.

Ok.

> > +          Say Y here if you want to use power key and jack events
> > +          on Motorola EZX 2nd generation phones
> > +
>=20
> To compile this driver as a module...

Ok.

> > +	case PCAP_IRQ_MIC:
> > +		input_report_key(pcap_keys->input, KEY_HP, !pstat);
>=20
> Why not SW_MICROPHONE_INSERT?

Its actually a button.

The device has a single jack for headphone and microphone. And the
headset that we connect to it has a button that you use to answer calls,
or dial.

> > +static int __init pcap_keys_probe(struct platform_device *pdev)
>=20
> __devinit, not __init should be used on driver's probe() methods.

Ok.

> > +	pcap_keys->input->name =3D pdev->name;
> > +	pcap_keys->input->phys =3D "pcap-keys/input0";
> > +	pcap_keys->input->dev.parent =3D &pdev->dev;
>=20
> I do like a temp for input_dev, it usually makes code a bit smaller.
> Also it would be nice to have but type set (BUS_HOST I think).

Ok.

> > +	set_bit(KEY_HP, pcap_keys->input->keybit);

> __set_bit() please, like Trolok said.

Ok.

> > +static int pcap_keys_remove(struct platform_device *pdev)
>=20
> __devexit here.

Ok.

> > +	.remove		=3D pcap_keys_remove,
>=20
> __devexit_p()

Ok.

> > +MODULE_DESCRIPTION("Motorola PCAP2 input events driver");
> > +MODULE_AUTHOR("Ilya Petrov <ilya.muromec@gmail.com>");
> > +MODULE_LICENSE("GPL");
>=20
> Do we need MODULE_ALIAS() here?

Do we? I think we don't, but well... It costs nothing. ;)

--=20
Daniel Ribeiro

--=-uNw0TazYwdnAlF41viYz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpJKEsACgkQw3OYl0G0liRwywCgmVlIMkIq1YVj13Wjq4roMk89
WjIAn2RKQ4UxWpUgOEX0HucJ4v3WRz8O
=h07W
-----END PGP SIGNATURE-----

--=-uNw0TazYwdnAlF41viYz--


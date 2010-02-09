Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab0BIAgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 19:36:41 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:52279 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0BIAgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 19:36:39 -0500
Date: Mon, 8 Feb 2010 22:31:32 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: setup hotkey polling after changing
 hotkey_driver_mask
Message-ID: <20100209003131.GE1420@holoscopio.com>
References: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
 <20100208155059.eed393a6.akpm@linux-foundation.org>
 <20100209000810.GC1420@holoscopio.com>
 <20100208162153.b317e434.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <20100208162153.b317e434.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 08, 2010 at 04:21:53PM -0800, Andrew Morton wrote:
> On Mon, 8 Feb 2010 22:08:10 -0200
> Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
>=20
> >
> > ...
> >
> > > --- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-setup-hotkey=
-polling-after-changing-hotkey_driver_mask-fix
> > > +++ a/drivers/platform/x86/thinkpad_acpi.c
> > > @@ -2597,6 +2597,10 @@ static void hotkey_poll_set_freq(unsigne
> > > =20
> > >  #else /* CONFIG_THINKPAD_ACPI_HOTKEY_POLL */
> > > =20
> > > +static void hotkey_poll_setup(bool __unused)
> > > +{
> > > +}
> > > +
> > >  static void hotkey_poll_setup_safe(bool __unused)
> > >  {
> > >  }
> > > @@ -2694,9 +2698,7 @@ static ssize_t hotkey_mask_store(struct=20
> > > =20
> > >  	res =3D hotkey_user_mask_set(t);
> > > =20
> > > -#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
> > >  	hotkey_poll_setup(true);
> > > -#endif
> > > =20
> > >  	mutex_unlock(&hotkey_mutex);
> > > =20
> > > @@ -6273,9 +6275,7 @@ static int __init brightness_init(struct
> > >  				| TP_ACPI_HKEY_BRGHTUP_MASK
> > >  				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
> > > =20
> > > -#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
> > > -	hotkey_poll_setup(true);
> > > -#endif
> > > +	hotkey_poll_setup_safe(true);
> > > =20
> > >  	return 0;
> > >  }
> > > _
> > >=20
> >=20
> > How about the added call to volume_init?
> >=20
>=20
> I don't know what you mean.
>=20

You've fixed the hotkey_poll_setup to a hotkey_poll_setup_safe that has
just been added by a patch of mine to the function brightness_init. The
same has not been done to the call that has been added to the function
volume_init.

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktwrOMACgkQyTpryRcqtS2NhwCfQ/7hl+viF0516S0nIAZOli3T
JRMAn18U4aYyi1X8xk5KEWV9fMRbUpPj
=JMao
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--

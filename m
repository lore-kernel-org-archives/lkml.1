Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYFGTk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYFGTk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYFGTkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:40:15 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:58173 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYFGTkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:40:14 -0400
Date: Sat, 7 Jun 2008 16:40:07 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Correct type and description of
	CONFIG_AC97_POWER_SAVE_DEFAULT
Message-ID: <20080607194006.GA9516@vespa.holoscopio.com>
References: <20080607162238.GA7893@vespa.holoscopio.com> <s5hlk1hp25b.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <s5hlk1hp25b.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 07, 2008 at 07:48:16PM +0200, Takashi Iwai wrote:
> At Sat, 7 Jun 2008 13:22:39 -0300,
> Thadeu Lima de Souza Cascardo wrote:
> >=20
> > While CONFIG_HDA_POWER_SAVE_DEFAULT is used as a timeout in seconds,
> > CONFIG_AC97_POWER_SAVE_DEFAULT simply enables or disables AC97 power
> > saving.
>=20
> Thanks for the patch.  However, I can't take this as is.  The reasons
> are below:
>=20
> The power_save option takes indeed an integer value, and this kconfig
> is nothing but its default value.
>=20
> In your way, it's set always 1 if selected.  This is a very bad choice
> as power_save value, because you'll turn on/off after one second.
> This may lead to too frequent click noises.=20
> Thus, even if we need to make it bool, a more sensitive value must be
> chosen.  And, which value is sensitive is a matter of taste, and you
> cannot define it alone by yourself.
>=20

As I said in my comment, that is true for CONFIG_HDA_POWER_SAVE_DEFAULT,
which is, in fact, used as a number of seconds, and I left that as is.
The static power_save variable in ac97_codec.c, however, is only used in
a macro ac97_is_power_save_mode, which, in turn, is only used in two
if's.

> thanks,
>=20
> Takashi
>=20

Thank you.

> > ---
> >  sound/pci/Kconfig           |    6 +++---
> >  sound/pci/ac97/ac97_codec.c |    6 +++++-
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
> > index 7e47421..fe6aad2 100644
> > --- a/sound/pci/Kconfig
> > +++ b/sound/pci/Kconfig
> > @@ -968,11 +968,11 @@ config SND_AC97_POWER_SAVE
> >  	  sysfs, too.
> > =20
> >  config SND_AC97_POWER_SAVE_DEFAULT
> > -	int "Default time-out for AC97 power-save mode"
> > +	bool "Activate AC97 power-save mode by default"
> >  	depends on SND_AC97_POWER_SAVE
> >  	default 0
> >  	help
> > -	  The default time-out value in seconds for AC97 automatic
> > -	  power-save mode.  0 means to disable the power-save mode.
> > +    By default, AC97 power-save mode is not active. This option
> > +    activates it by default.
> > =20
> >  endmenu
> > diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
> > index 45fd290..0566e3a 100644
> > --- a/sound/pci/ac97/ac97_codec.c
> > +++ b/sound/pci/ac97/ac97_codec.c
> > @@ -48,7 +48,11 @@ module_param(enable_loopback, bool, 0444);
> >  MODULE_PARM_DESC(enable_loopback, "Enable AC97 ADC/DAC Loopback Contro=
l");
> > =20
> >  #ifdef CONFIG_SND_AC97_POWER_SAVE
> > -static int power_save =3D CONFIG_SND_AC97_POWER_SAVE_DEFAULT;
> > +#ifdef CONFIG_SND_AC97_POWER_SAVE_DEFAULT
> > +static int power_save =3D 1;
> > +#else
> > +static int power_save =3D 0;
> > +#endif
> >  module_param(power_save, bool, 0644);
> >  MODULE_PARM_DESC(power_save, "Enable AC97 power-saving control");
> >  #endif
> > --=20
> > 1.5.5.3
> >=20

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhK5BYACgkQyTpryRcqtS3UkACfRIxEuOd+dE5B3dor765O6YDE
j5MAn2ImAkEPwUxd90jpt+7aVX2ZHD7p
=Uy5h
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--

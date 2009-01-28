Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbZA1M1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbZA1M1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 07:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZA1M1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 07:27:07 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:44144 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbZA1M1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 07:27:06 -0500
Date: Wed, 28 Jan 2009 10:27:30 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: Don't cold reset AC97 codecs in some ICH chipsets
Message-ID: <20090128122730.GC13699@vespa.holoscopio.com>
References: <1233136956-16830-1-git-send-email-cascardo@holoscopio.com> <s5hbptrws77.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <s5hbptrws77.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2009 at 01:06:20PM +0100, Takashi Iwai wrote:
> At Wed, 28 Jan 2009 08:02:36 -0200,
> Thadeu Lima de Souza Cascardo wrote:
> >=20
> > Check in a quirk list if it should do cold reset when AC97 power saving
> > is enabled. Some devices do not resume properly when cold reset,
> > although power saving works OK.
> >=20
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>=20
> Thanks for the patch.
> We can go better further with this patch now :)
>=20
> The logic is basically fine, but just a few comments...
>=20
> > diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
> > index 19d3391..69b3ed8 100644
> > --- a/sound/pci/intel8x0.c
> > +++ b/sound/pci/intel8x0.c
> ...
> > +static int snd_intel8x0_ich_chip_cold_reset(struct intel8x0 *chip)
> > +{
> > +	unsigned int cnt;
> >  	/* ACLink on, 2 channels */
> > +
> > +	if (snd_pci_quirk_lookup(chip->pci, ich_chip_reset_mode))
> > +		return -EIO;
>=20
> I feel it isn't intuitive to return -EIO here.
> It'd be more straightforward to call snd_intel8x0_ich_chip_reset()
> from here?
>=20
> 	if (snd_pci_quirk_lookup(chip->pci, ich_chip_reset_mode))
> 		return snd_intl8x0_ich_chip_reset(chip);
>=20
>=20
> > +	if (snd_intel8x0_ich_chip_cold_reset(chip) < 0)
> > +		if ((err =3D snd_intel8x0_ich_chip_reset(chip)) < 0)
> > +			return err;
>=20
> Please make the change checkpatch-clean.
>=20
> Could you fix and repost?

I did checkpatch it, but since this style is used in many places in the
intel8x0.c code, I thought I would leave it this way. Should I send a
cleanup patch too?

By the way, I have some very trivial comment typo patches lying around.
I will post them too.

>=20
>=20
> thanks,
>=20
> Takashi

Regards,
Cascardo.

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmATzEACgkQyTpryRcqtS3QcQCeI0Ymg86Gk2LXBC93TqgFqGq1
7KoAniP1dNomNc8zfEWYKL3kcmM2glDK
=4Zts
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--

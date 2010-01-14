Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971Ab0ANPzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0ANPzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916Ab0ANPzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:55:45 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:58477 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab0ANPzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:55:44 -0500
Date: Thu, 14 Jan 2010 13:53:43 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, ibm-acpi@hmh.eng.br,
       Jaroslav Kysela <perex@perex.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alsa: use subsys_initcall for sound core instead of
 module_init
Message-ID: <20100114155342.GA1396@holoscopio.com>
References: <1263334840-6118-1-git-send-email-cascardo@holoscopio.com>
 <s5h63765wm0.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <s5h63765wm0.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 13, 2010 at 07:48:07AM +0100, Takashi Iwai wrote:
> At Tue, 12 Jan 2010 20:20:39 -0200,
> Thadeu Lima de Souza Cascardo wrote:
> >=20
> > This is needed for built-in drivers which are built before the sound di=
rectory,
> > like thinkpad_acpi.
> >=20
> > Otherwise, registering a card fails.
>=20
> Oh well, this kind of problem hits again.
>=20
> I don't remember why subsys_init() wasn't taken before...  Maybe some
> dependency between sound and V4L or so.  But, it's worth to check again.
>=20

Any references to this dependency problem, so I can try to help and investi=
gate
about it and do some tests?

> I'll apply this after some testing.
>=20

Built-in thinkpad-acpi started working for me after these changes. I can't =
tell
you about any subsystem that stopped working, like some V4L driver.

>=20
> thanks,
>=20
> Takashi
>=20

Regards,
Cascardo.

> >=20
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > ---
> >  sound/core/sound.c |    4 ++--
> >  sound/sound_core.c |    2 +-
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/sound/core/sound.c b/sound/core/sound.c
> > index 7872a02..563d196 100644
> > --- a/sound/core/sound.c
> > +++ b/sound/core/sound.c
> > @@ -468,5 +468,5 @@ static void __exit alsa_sound_exit(void)
> >  	unregister_chrdev(major, "alsa");
> >  }
> > =20
> > -module_init(alsa_sound_init)
> > -module_exit(alsa_sound_exit)
> > +subsys_initcall(alsa_sound_init);
> > +module_exit(alsa_sound_exit);
> > diff --git a/sound/sound_core.c b/sound/sound_core.c
> > index dbca7c9..7c2d677 100644
> > --- a/sound/sound_core.c
> > +++ b/sound/sound_core.c
> > @@ -61,7 +61,7 @@ static void __exit cleanup_soundcore(void)
> >  	class_destroy(sound_class);
> >  }
> > =20
> > -module_init(init_soundcore);
> > +subsys_initcall(init_soundcore);
> >  module_exit(cleanup_soundcore);
> > =20
> > =20
> > --=20
> > 1.6.6
> >=20

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktPPgYACgkQyTpryRcqtS1DCwCeJI57xt9ZXn6Ej9ij4vyi/hmo
r3sAn0TWiWODiyy6I5H21/c5P1SLMpnQ
=5cqY
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--

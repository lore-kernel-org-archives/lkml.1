Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbXIBUXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbXIBUXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXIBUXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:23:14 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:38783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbXIBUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:23:13 -0400
Subject: Re: [PATCH -mm] net/wireless/sysfs.c: Shut up build warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.0.999.0709030139110.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n>
	 <alpine.LFD.0.999.0709030139110.29617@enigma.security.iitk.ac.in>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1T6AezXWMTICFHRunIHu"
Date: Sun, 02 Sep 2007 22:24:19 +0200
Message-Id: <1188764659.14564.0.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1T6AezXWMTICFHRunIHu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-03 at 01:41 +0530, Satyam Sharma wrote:
> net/wireless/sysfs.c:108: warning: =E2=80=98wiphy_uevent=E2=80=99 defined=
 but not used
>=20
> when CONFIG_HOTPLUG=3Dn is because the only usage site of this function
> is #ifdef'ed as such, so let's #ifdef the definition also.
>=20
> Signed-off-by: Satyam Sharma <satyam@infradead.org>

Looks good to me. The new style seems to be to do
#ifdef SOMETHING
code
#else
#define wiphy_uevent NULL
#endif

and then using it unconditionally, but I'm fine with both.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/wireless/sysfs.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> --- linux-2.6.23-rc4-mm1/net/wireless/sysfs.c=E2=80=BEfix	2007-09-02 20:0=
6:11.000000000 +0530
> +++ linux-2.6.23-rc4-mm1/net/wireless/sysfs.c	2007-09-02 20:07:01.0000000=
00 +0530
> @@ -104,11 +104,13 @@ static void wiphy_dev_release(struct dev
>  	cfg80211_dev_free(rdev);
>  }
> =20
> +#ifdef CONFIG_HOTPLUG
>  static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
>  	/* TODO, we probably need stuff here */
>  	return 0;
>  }
> +#endif
> =20
>  struct class ieee80211_class =3D {
>  	.name =3D "ieee80211",

--=-1T6AezXWMTICFHRunIHu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2xvz/ETPhpq3jKURAqQuAJ9uwYijqez3o62+Aj4ERFV5D/PMfACfRXnO
AaQH2ioC2v5/fI1GDF65XYg=
=rDcv
-----END PGP SIGNATURE-----

--=-1T6AezXWMTICFHRunIHu--


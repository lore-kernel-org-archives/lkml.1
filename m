Return-Path: <linux-kernel-owner+w=401wt.eu-S1752301AbYLXQNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbYLXQNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 11:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLXQNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 11:13:01 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45254 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYLXQNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 11:13:00 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH] sh: maple: add Maple controller as a joystick device
Date: Wed, 24 Dec 2008 11:57:31 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.27.8; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-sh" <linux-sh@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Andrew Morton <akpm@osdl.org>
References: <1229797614.6502.20.camel@localhost.localdomain>
In-Reply-To: <1229797614.6502.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5716807.DDvuXe0M0L";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812241157.33912.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5716807.DDvuXe0M0L
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 20 December 2008 13:26:54 Adrian McMenamin wrote:
> +static int probe_maple_controller(struct device *dev)
> +{
> ...
> +	mdev =3D to_maple_dev(dev);
> +	if (!mdev) {
> +		error =3D EINVAL;
> +		goto fail;
> +	}
> +
> +	mdrv =3D to_maple_driver(dev->driver);
> +	if (!mdrv) {
> +		error =3D EINVAL;
> +		goto fail;
> +	}

like Dmitry said, these NULL checks make no sense

> +	pad =3D kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
> +	if (!pad) {
> +		error =3D ENOMEM;
> +		goto fail;
> +	}
> +	idev =3D input_allocate_device();
> +	if (!idev){
> +		error =3D ENOMEM;
> +		goto fail_idev;
> +	}
> ...
> +	error =3D input_register_device(idev);
> +	if (error)
> +		goto fail_register;
> ...
> +fail_register:
> +	maple_set_drvdata(mdev, NULL);
> +	input_free_device(pad->dev);
> +fail_idev:
> +	kfree(pad);
> +fail:
> +	return -error;
> +}

this -error stuff is weird and i think wrong.  for constants, you're adding=
=20
overhead, and for the input_register_device(), i think you're negating an=20
already negative value thus breaking it.
=2Dmike

--nextPart5716807.DDvuXe0M0L
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJUmn9AAoJEEFjO5/oN/WB1hwQAL84sYqkaWhLa1U+SLr0mUTG
I4ktduD4v1/hOk0jpw+64BveIX3K9n3agivX1YogH0ye+6aCP2LfubrhNqxh4PY4
OPDICf7vMulpVguJC7914QVY9tqHyA8Rtx9vgNlBQ5Vir8/FO8X3ZhB6UrpvjdoZ
wboLY8K89vLFe3w3WC7hWTSXBLPKQ0/g9MZep/KeLP79rwC/8EsiikkVRxltU/Kp
UIg96IN7FBD+ix4lzgZgl0J2VzlXDrJLUuX1JDVxbaep8Eepk6baO1SpI9H2rF9F
CwP0jmDJgOMm7EkZ1iaga/ZfzmzUJ6XhXueBIMM56fMNmFGrOulmb9M+bc6c+V2Q
Lvl2V7YUfpAeMAEV1RJv7mgo2/0dkDFaMcUqROZrmB6PCqn5abvvb0lhoLEOB1MO
UERhkGD/HLd0jkgUp7KH6tbXJHgYHf94Nmgfn9syln1mkjF2NwNVCxnfUnEcoTle
0y0/8pvC9TxPWeqtGsvMsMGM1EsWYwGiUeZu8QQ41OTNobrdrrmvMCwPcmT+B53p
lg92FcTtMvO+5Kvv4Fc9GFVveeHw83k329dRhjkbysNqwgNU6T1aw28JtCPxjVXU
3HJ8prnositb4IP+Bnf969FuO2uvWq/2FeV+uN8RnNUI3SudJV1MKwjmCeO54YAi
7Hl0mQjXgSykT41R7g4w
=HVVg
-----END PGP SIGNATURE-----

--nextPart5716807.DDvuXe0M0L--

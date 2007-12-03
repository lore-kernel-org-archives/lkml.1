Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbXLCKgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbXLCKgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXLCKgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:36:07 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:58153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbXLCKgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:36:06 -0500
Subject: Re: [RFC v2] Documentation about unaligned memory access
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-kernel@vger.kernel.org, avuton@gmail.com, hancockr@shaw.ca,
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, mrmacman_g4@mac.com,
       dean@arctic.org, argggh@dolphinics.no, jengelh@computergmbh.de,
       shdl@zakalwe.fi, vlobanov@speakeasy.net, drzeus-list@drzeus.cx,
       strange@nsk.no-ip.org, dm.n9107@gmail.com
In-Reply-To: <20071129161523.E0C349D4B52@zog.reactivated.net>
References: <20071129161523.E0C349D4B52@zog.reactivated.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GWpspBqA4h1s8LgcaDR8"
Date: Mon, 03 Dec 2007 10:26:29 +0100
Message-Id: <1196673989.6060.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GWpspBqA4h1s8LgcaDR8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> 	void myfunc(u8 *data, u32 value)
> 	{
> 		[...]
> 		value =3D cpu_to_le32(value);
> 		put_unaligned(value, data);

> 	u32 value =3D get_unaligned(data);

Actually, this is wrong. put_unaligned and get_unaligned use the type of
the "data" pointer, e.g. on powerpc get_unaligned does just "*data".

Hence, here you'll want to use

	put_unaligned(value, (u32 *)data);

and

	u32 value =3D get_unaligned((u32 *)data);

or you end up with a single-byte store/load.

johannes

--=-GWpspBqA4h1s8LgcaDR8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1PLxKVg1VMiehFYAQIgog//Qjh2wt8k9S7fnICwStfpsByNJFeHzTff
mEHBbHW0HBhOnspY8vxlNHV4eShIjBVoyTURGXz1RiaO7U2bPEfWI5qdp62+oSrt
6BwVN9MUF4I/ObnkC1vB5u+Sl+pCWh+BX7AAkA7bF2LFrItHXGxAmwL019gf1xbx
hDeKtObBpb3qk+R613FMEcehA6AvPTEXKaIDw677J6NCaggJM3VGSwPSddSQVOQ7
Mhvhfr8ZnTS9msXUuqGmwFzYi7ChHqSMLpnCzUlg3/hZVXO6MTxImkqpqDjokAHv
yyZ3to7DGDuYyU6Q0NXgjeaEnvap2z+frqeih/pGTP1ps4AZ/WjhTo1eBAREw9u4
XOJfjK7r5qS4idpxjbOjclmu58EYIo8SnruqYr+1d4QWLGzyF0TdXXKThhifivpF
M8hvovK5gD9s2xQXmsXDZ098TtLW2/bNE73lgOa+cRS0dnvVLjRBn5NQ54Vqa/69
WeJo8FKQNZjBVWly1UsAt3e+BrPpdVmqa4YbG/wvZOHqSdg15RHY9VcBpVoVtwwv
LaF6L0Z6WzMwEHRAF3c6FRskcfv/08IJmD9fQ9lrfpdJ/ZhnDxAK3euq8d7mkK17
Z5AsCIRSk5TmK/EJzyaTlG78Oa8MGiw+I86bOs2A3aN22TG+uSardkRO+XEXZ+rc
sCxvE1F1rf0=
=etEa
-----END PGP SIGNATURE-----

--=-GWpspBqA4h1s8LgcaDR8--


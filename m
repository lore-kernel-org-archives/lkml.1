Return-Path: <linux-kernel-owner+w=401wt.eu-S1762030AbYEYMAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762030AbYEYMAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 08:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758631AbYEYMAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 08:00:12 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783AbYEYMAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 08:00:10 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>,
       Michael Buesch <mb@bu3sch.de>
In-Reply-To: <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211550374.28967.10.camel@pmac.infradead.org>
	 <20080523164108.GA31545@uranus.ravnborg.org>
	 <1211640377.540.14.camel@pmac.infradead.org>
	 <20080524152214.GA12582@uranus.ravnborg.org>
	 <1211642706.31212.85.camel@shinybook.infradead.org>
	 <1211643245.31212.88.camel@shinybook.infradead.org>
	 <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org>
	 <1211707837.17151.14.camel@johannes.berg>
	 <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hJuD05c3mnjvdSt2CeXS"
Date: Sun, 25 May 2008 13:59:44 +0200
Message-Id: <1211716784.17151.19.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hJuD05c3mnjvdSt2CeXS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Marcel,

> The kernel should not in any case have knowledge about directories or =20
> subdirectories where the firmware files are stored. That is fully =20
> irrelevant for the kernel.

Exactly my point! Hence, the kernel just gives it an arbitrary name. The
fact that userspace uses this as a filename could be regarded as a bug,
but it works fine. Therefore, the kernel simply assigns an arbitrary,
NULL-terminated string as the name. It happens to include a / because it
is convenient with the current userspace implementation, but that's mere
detail, the ABI/API here is to allow any arbitrary names.

> Especially with the case of built-in firmwares now, it because more =20
> important to do it right. The one reason why we have to handover the =20
> struct device to request_firmware() is that we can give the helper =20
> script full access to the device and driver information of the caller. =20
> Hence adding for example b43/ as prefix simply duplicates everything =20
> since the struct device has a link to the driver that is requesting a =20
> firmware file.

But that doesn't matter at all! Dave's work to build firmware files into
the kernel will simply result in an entry in the kernel firmware table
that has a '.name =3D "b43/pcm5.fw"', nothing needs to know that b43 is a
module name, in fact, it could very well be 'broadcom wlan/pcm5.fw' as
well.

> That is not what I am proposing. What I am proposing is that we do =20
> this the right way. Meaning that we fix udev to do the namespacing. I =20
> am working on a way to have this change in a backward compatible way.

That will introduce a "flag-day" where you have to upgrade userspace
with the kernel, and vice versa, OR userspace will have to guess. Not a
good solution either.

Why are you so fixated on special-casing the single character '/'?

johannes

--=-hJuD05c3mnjvdSt2CeXS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDlUr6Vg1VMiehFYAQKjTw//b5a0XEkR8wu0u5B2dB7fvZcCcWiQuRnU
Tmhp9wqcOec2hVzd1nS44WUJ3B5/LSkvcx6R4BapZSXIBkOpJecoCcxiLRGiYKGi
Q8IVr7b9mO/y7B8hUoombj+7g7WiT8spbeKjZfdNZwPyc0qRS78k13Y1u8ioyofC
BVdzBTXxQGLmfGRKurg4Z7SISsN503dm5Cdmbsb8w65Ssa2ak7BNd243Z8MX/2pH
N+ozqt8GCa/eFNyGq83awZk1ugJDdfti6UZgdjF7kEO/Ay+cS2BSHXiusfnbdW+O
WjXj7V+mycIZJKmA9qrIsBuRqJwI33ulXJfA92UcXnV/9YgCHU4LK2rVR0WHcTXA
SQA7Xx9D1t/ZLJZ4WBwxaEewFFsDehQFNfWkBOemaG/b78SJpU7S7pNll4B+H8c0
nTEy/pUM833PrDsA80ZHxEOVaGTNUgknHFN8uk+6Bigprv9hsQ30gYeGzBLOuySr
w+XQ86uYbhtz3W3gIIol6MK8H6SSCB0FqW+APtxTQlKmlVFnRiqjEYvabM0fPUv1
0GHHiXnDUSYBkE2l49U23Ij/tt3R6Z0pXPhaXk7GuaBATRNF+YiAVOPe7jGDU7/W
CDi4z5w6wI4SSbyTZGkmEvgjvgum0oY0hLUVbjrlgjhVG8JqWUh/DRAtUvQqMvAG
iuT3nYH/ucs=
=nMls
-----END PGP SIGNATURE-----

--=-hJuD05c3mnjvdSt2CeXS--


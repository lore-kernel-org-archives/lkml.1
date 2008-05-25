Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYEYNlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYEYNlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYEYNlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:41:14 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:57270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYEYNk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:40:59 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>,
       Michael Buesch <mb@bu3sch.de>
In-Reply-To: <54EDAF0A-907B-46D0-925E-56ADDA37E106@holtmann.org>
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
	 <1211716784.17151.19.camel@johannes.berg>
	 <54EDAF0A-907B-46D0-925E-56ADDA37E106@holtmann.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BBaIG2ieX18x9FIOFOWD"
Date: Sun, 25 May 2008 15:40:35 +0200
Message-Id: <1211722835.17151.24.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BBaIG2ieX18x9FIOFOWD
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> > Why are you so fixated on special-casing the single character '/'?
>=20
> It is not the "/" character. It is the directory separator. Just =20
> happened to be "/" on Unix operating systems. You are really missing =20
> my point here. The kernel should not be involved in enforcing this =20
> kind of namespaces.

Why are you thinking of it as namespaces then? It isn't. The "firmware
key" lives in a flat namespace where each key is an arbitrary
nul-terminated string.

> Look at the device nodes. The kernel has mouse0 for example and udev =20
> will translate this into /dev/input/mouse0. Nobody expects the kernel =20
> to use input/mouse0 and actually you even can't do that at all since =20
> the device model forbids "/" as bus id. Same applies for the firmware =20
> filenames.

No, it doesn't.

> Also at some point we might change the actual implementation of =20
> request_firmware() to allow running multiple request_firmware() at the =20
> same time to improve the init time of devices (if that makes sense). =20
> In that case the filename would become a kobject and then the =20
> directory separator would become illegal.

There's no need to think of it that way. Look at a uevent now:

UEVENT[1211722721.323011] add      /devices/pci0001:10/0001:10:12.0/ssb0:0/=
firmware/ssb0:0 (firmware)
ACTION=3Dadd
DEVPATH=3D/devices/pci0001:10/0001:10:12.0/ssb0:0/firmware/ssb0:0
SUBSYSTEM=3Dfirmware
FIRMWARE=3Db43/b0g0bsinitvals5.fw
TIMEOUT=3D60
SEQNUM=3D1376


The "firmware key" is contained in the FIRMWARE environment variable. If
you want to allow loading multiple firmwares at the same time, you
wouldn't have to make the key part of the device name, you would only
have to add a unique ID to the firmware device name, say

=EF=BB=BF
UEVENT[1211722721.323011] add      /devices/pci0001:10/0001:10:12.0/ssb0:0/=
firmware/ssb0:0-1234 (firmware)
ACTION=3Dadd
DEVPATH=3D/devices/pci0001:10/0001:10:12.0/ssb0:0/firmware/ssb0:0-1234
SUBSYSTEM=3Dfirmware
FIRMWARE=3Db43/b0g0bsinitvals5.fw
TIMEOUT=3D60
SEQNUM=3D1376

johannes

--=-BBaIG2ieX18x9FIOFOWD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDlsUqVg1VMiehFYAQIPpA//YzaGpwS+LXyTDF0YsmSZ1pdmpSj+leYf
h48kyBSJgouI3qnsrxnQJnocwH65iJ30wYmt4znNi9zpg70LfRBj6WqcsQfCUwss
JKJ5qrnG+zCkj4MkoMXbzhQo4UkE5bOTMW8eSfTKHMd1RDVyHC0NC6Rhu2PdPVaa
YRS8c7YyDX0wjQL4KlpraqFTgN1MS6KLVSwCW0P1yWHCsBSEIDOuNtwUBZNuVXtY
7H/S0xOz89hviMCzClmaeoP0KP2f2QVHM/qrrr8EstK0Tp7BOyWF5LB9DmMo+hZy
8W55b3ZmzA0j42U9Del/o9ATafi0j/xDF4bIYuNWaqydRrTFzJoNnUhPkGK5q1yT
BnFtqx1whpuvufXs6m44jrpvVaK5nx5eDoTda7XFUhn4+JQTlEHF5YGo6emzIzXC
qUfVVAQPE5JycDYiTdODnhR4g+ADyIHWwYNCZClRtCD68zPExUmOAxPFKl4dUas2
CgtD0/TbqdqHonyPyEm+xGKbHPKNdxHH5jhrlJyVl4ec24ji6zL4aJgLQ1zP66N3
JB0kBSiRvJJp7vBs6XehaRWksE0TROv7zPCktF4Pa1HOPuYXJL7401oRBd8KxGQv
+/HF88MBFJ6ngdL4SeM1nSyCPqqnbYIT49QuMw7G1sZqMjJhDdRWmQu/T40thDrS
xY8ocJ0KzSQ=
=+F7i
-----END PGP SIGNATURE-----

--=-BBaIG2ieX18x9FIOFOWD--


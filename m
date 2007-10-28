Return-Path: <linux-kernel-owner+w=401wt.eu-S1751623AbXJ1GvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbXJ1GvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 02:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXJ1Gux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 02:50:53 -0400
Received: from mx30.mail.ru ([194.67.23.238]:11791 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXJ1Guv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 02:50:51 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: cbou@mail.ru
Subject: Re: [PATCH] 2.6.24-rc1: ensure "present" sysfs attribute even if battery is absent
Date: Sun, 28 Oct 2007 10:50:45 +0400
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, Alexey Starikovskiy <aystarik@gmail.com>
References: <200710272054.31160.arvidjaar@mail.ru> <20071027184249.GA2982@zarina>
In-Reply-To: <20071027184249.GA2982@zarina>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3230126.ZlRjpxZkLj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710280950.46779.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3230126.ZlRjpxZkLj
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 October 2007, Anton Vorontsov wrote:
> On Sat, Oct 27, 2007 at 08:54:30PM +0400, Andrey Borzenkov wrote:
> > I am not exactly sure about this one ... what other power_supply class
> > drivers do? Should I fix HAL instead (but then, I do not know whether H=
AL
> > is the only application that is using this interface).
>
> Well, PROP_PRESENT wasn't my idea, currently it's used by pmu and
> olpc drivers becuase it's not trivial to register/unregister their
> batteries on physical insertion/removal. I have some plans to teach
> at least pmu batteries to not use PROP_PRESENT. I don't have any
> OLPC, thus I can't convert it.
>
> To sum this: the good way to handle "missing" batteries is to
> unregister them, so they'll not show up in the /sys/class/power_supply.

Well, in this case HAL behaviour makes sense (default to present =3D=3D tru=
e=20
if "present" attribute is missing)

> Is that possible with the ACPI?
>

At least looking in ACPI specs, this looks possible. What currently is=20
presented as battery object is actually battery bay according to ACPI spec:

Unlike most other devices, when a battery is inserted or removed from the=20
system, the device itself (the
battery bay) is still considered to be present in the system.

When battery is inserted/removed, ACPI notifies us and we can check whether=
=20
battery is actually present and update registration accordingly. From the=20
sysfs structure POV probably nothing has to be changed; just when and how=20
power_supply is registered=20
under /sys/devices/LNXSYSTM:00/device:00/PNP0C0A:0n

Alexey, does it make sense (or doable)?


--nextPart3230126.ZlRjpxZkLj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJDFGR6LMutpd94wRAqqkAJ9nX27iHO3qWc1pC5L21TJjAm2nWwCfemi3
f2od9RViOmueN4E3Sl+67KI=
=UncZ
-----END PGP SIGNATURE-----

--nextPart3230126.ZlRjpxZkLj--

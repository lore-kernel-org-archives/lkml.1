Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbXKPVCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbXKPVCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbXKPVBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:01:53 -0500
Received: from mx27.mail.ru ([194.67.23.23]:2473 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbXKPVBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:01:52 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24 regression:  hibernation hangs on "Suspending console" in low-battery condition
Date: Sat, 17 Nov 2007 00:01:41 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <200711052201.17150.arvidjaar@mail.ru> <200711112148.23133.arvidjaar@mail.ru> <200711112010.24874.rjw@sisk.pl>
In-Reply-To: <200711112010.24874.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3168712.bMNUBjDVkb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711170001.46710.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3168712.bMNUBjDVkb
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 11 November 2007, Rafael J. Wysocki wrote:
> On Sunday, 11 of November 2007, Andrey Borzenkov wrote:
> > On Sunday 11 November 2007, Rafael J. Wysocki wrote:
> > > On Sunday, 11 of November 2007, Andrey Borzenkov wrote:
> > > > On Monday 05 November 2007, Andrey Borzenkov wrote:
> > > > > Notice "hung" not "hangs". This happened so far only once - when =
low battery=20
> > > > > condition triggered suspend to disk. I was not able to reproduce =
it after=20
> > > > > this running on AC.
> > > > >=20
> > > > > Just in case it rings the bell for someone. This is not suspend r=
egression=20
> > > > > reported earlier by Jens - I do not even have SATA nor is using l=
ibata=20
> > > > > drivers.
> > > > >=20
> > > >=20
> > > > This happened second time, now with 2.6.24-rc2. I have kpowersave c=
onfigured
> > > > to initiate suspend-to-disk on low battery. Suspend-to-disk is init=
iated,
> > > > but system stops after Suspending console line. Suspend image is no=
t created.
> > > >=20
> > > > This did work before although I do not name exact version.
> > > >=20
> > > > I am rather at loss how to proceed further ... any idea? dmesg and =
config
> > > > attached just in case. The problem is that hibernation works when I=
 initiate
> > > > it manually ...
> > >=20
> > > Have you tried it with the battery removed?
> > >=20
> > >=20
> >=20
> > It works. Subjectively I have relatively long pause after first Suspend=
ing console
> > message (where it hangs otherwise), according to dmesg timestamp it is =
about
> > 1 second before next messages appear. Also last two times I tried it wr=
iteout
> > of suspend image was really slow; it was both with and without battery.=
 Reading
> > on resume in really in order of magnitude faster.
> >=20
> > But manual STD so far works both on AC (with or without battery) or on =
battery.
> >=20
> > Of course it is possible that battery gets exhausted during STD, but sy=
stem
> > is not switched off. Rather I would suspect something like ACPI notific=
ation
> > that comes during freeze ...
>=20
> Frankly, I'm suspecting a deadlock in the ACPI code.
>=20
> Please try to make kpowersave start hibernation a bit earlier and see what
> happens.
>=20
> What's your critical time now?
>=20
>=20

it was set to 5%. Setting it to 10% makes it work, but it just confirms wha=
t I
said before - suspend-to-RAM in normal battery conditions (or without batte=
ry)
works. With 5% threshold I have visible indication of alarm from *firmware*=
 -
battery LED flashing.

Something happens differently when battery is in dangerous state. I tried p=
atch
4c41d3ad6544f1c9aec37c441af04f5d0ad3a731 (got from ACPI tree) but it did not
change anything. It worked once when I left system on battery with artifici=
al
load (find . -exec md5sum in linux tree in a loop) but I suspect it is just
because it just triggered limit earlier. (Frankly I do not know which perce=
ntage
kpowersave computes)

--nextPart3168712.bMNUBjDVkb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHPgU2R6LMutpd94wRAq9tAKDDnM+4FW8WT3clB6JotdDL3JK1gQCdF4DM
LT8G/UntELrwAQdXUZA5wZw=
=MPZn
-----END PGP SIGNATURE-----

--nextPart3168712.bMNUBjDVkb--

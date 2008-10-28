Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYJ1QWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYJ1QWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYJ1QWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:22:30 -0400
Received: from mx30.mail.ru ([194.67.23.238]:4428 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbYJ1QW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:22:29 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: ACPI video.c brightness handler conflicts with toshiba_acpi
Date: Tue, 28 Oct 2008 19:22:12 +0300
User-Agent: KMail/1.9.10
Cc: Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       toshiba_acpi@memebeam.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200809061108.34877.arvidjaar@mail.ru> <200810281426.53499.trenn@suse.de> <200810281615.19894.rjw@sisk.pl>
In-Reply-To: <200810281615.19894.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8633294.OmLpcteX02";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810281922.20490.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8633294.OmLpcteX02
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 28 October 2008, Rafael J. Wysocki wrote:
> On Tuesday, 28 of October 2008, Thomas Renninger wrote:
> > On Monday 27 October 2008 17:52:55 Andrey Borzenkov wrote:
> > > On Monday 08 September 2008, Thomas Renninger wrote:
> > > > On Saturday 06 September 2008 09:19:59 am Andrey Borzenkov wrote:
> > > > > On Saturday 06 September 2008, Andrey Borzenkov wrote:
> > > > > > I have now two different devices that refer to the same hardwar=
e:
> > > > > >
> > > > > > lrwxrwxrwx 1 root root 0 2008-09-06 11:04 acpi_video0 ->
> > > > > > ../../devices/virtual/backlight/acpi_video0/ lrwxrwxrwx 1 root =
root 0
> > > > > > 2008-09-06 11:04 toshiba -> ../../devices/virtual/backlight/tos=
hiba/
> > > > > >
> > > > > > Unfortunately, due to ACPI implementation the acpi_video0 one i=
s much
> > > > > > inferior (as it provides only effectively two levels instead of=
 8);
> > > > > > and user level tools are apparently quite confused which one to
> > > > > > select.
> > > > > >
> > > > > > Is there any mechanism that would allow tochiba_acpi to claim
> > > > > > brightness for internal LCD screen that video would not attempt=
 to
> > > > > > grab it too?
> > > > > >
> > > > > > Of course manually disabling brightness handling in video is al=
ways
> > > > > > possible,
> > > > >
> > > > > Actually it is not. brightness_switch_enabled only disables event
> > > > > handling; it still resets actual brightness on loading and creates
> > > > > sysfs files to confuse user space.
> > > > >
> > > > > > still is nice for this to be handled automatically.
> > > >
> > > > It is in latest ACPI test branch queued for 2.6.28.
> > >
> > > It is still not in rc2; is it scheduled for 2.6.28 or delayed further?
> >=20
> > Right, it's not there.
> > Len, what happened with the:
> > "Check for ACPI backlight support otherwise use vendor ACPIdrivers - ve=
rsion 4"
> > patches?
> >=20
> > They are pretty essential for video.ko.
> > Otherwise graphics devices may get double poked (through vendor_acpi.ko=
 drivers)
> > or may register for graphics cards which are not there.
>=20
> Do you have a pointer to those patches?
>=20

So far I am running with these commits from git://git.kernel.org/pub/scm/li=
nux/kernel/git/ak/linux-acpi-2.6:

commit f43d728731c691772ddc29e50d25c68a859935b5
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:37:55 2008 +0200

    Check for ACPI backlight support otherwise use vendor ACPI drivers


commit ad9ed8385ed6ec5be8da7094db911c824258ceec
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:37:54 2008 +0200

    ACPI: video: Ignore devices that aren't present in hardware

I have been waiting for in-tree inclusion to submit patches for
toshiba_acpi against stable base.


--nextPart8633294.OmLpcteX02
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkHPDYACgkQR6LMutpd94zxBQCeIZwuhYC1aDJZ/qfGz0aaaDK8
vCoAn26UY6+C//0oC4K1DbNVjxdoS5Th
=q83M
-----END PGP SIGNATURE-----

--nextPart8633294.OmLpcteX02--

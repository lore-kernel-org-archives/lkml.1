Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbXGFEDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbXGFEDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 00:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbXGFEDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 00:03:16 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:52148 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXGFEDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 00:03:15 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 14:03:15 +1000
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20070703042916.GA17240@srcf.ucam.org> <200707060935.12706.nigel@nigel.suspend2.net> <1183694055.3388.108.camel@localhost.localdomain>
In-Reply-To: <1183694055.3388.108.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1936548.jGbeEE64qb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707061403.15932.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1936548.jGbeEE64qb
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Friday 06 July 2007 13:54:15 Benjamin Herrenschmidt wrote:
> On Fri, 2007-07-06 at 09:35 +1000, Nigel Cunningham wrote:
> >=20
> > Nice try :) Okay then, you remove the freezer, try hibernating, then ge=
t=20
back=20
> > to me after you've fixed your filesystem because some process that wasn=
't=20
> > frozen started writing things after the atomic copy (making the on disk=
=20
> > filesystem inconsistent with the snapshot).
> >=20
> > As Pavel rightly said, you can get rid of the freezer, but you're only=
=20
going=20
> > to have to implement another one that does the essentially the same thi=
ng,=20
> > even if it is at some other level.
>=20
> I was mostly talking about STR... Regarding STD, we have a different
> problem and we all know it. The freezer is one somewhat horrible way to
> get it working for now, I would prefer something more along the way that
> blocks the page cache from writing out new dirty pages though, except
> those specifically flagged by the snapshot.
>=20
> That is, some kind of proper snapshotting facility, as linus was
> describing some time ago.

The kind of thing Linus was talking about would limit you (as swsusp and=20
uswsusp do now) to only half the amount of memory. I suppose you could lzf=
=20
compress as you did the snapshot. That would generally get you up to 2/3rds=
,=20
but then again you can't know what compression ratio you'll get until you=20
try, so reliability would suffer or it would take longer because of retryin=
g.

I/O from swsusp and suspend2 use bios directly, so the page cache isn't an=
=20
issue for them (apart from the fact that Suspend2 saves the page cache=20
separately so it can get a full image). Not sure about uswsusp.

Only having half the amount of memory doesn't sound like a big limitation f=
or=20
modern desktops & laptops, but don't forget that there are embedded guys=20
wanting to hbernate too :)

Regards,

Nigel
=2D-=20
Nigel Cunningham
Christian Reformed Church of Cobden
103 Curdie Street, Cobden 3266, Victoria, Australia
Ph. +61 3 5595 1185 / +61 417 100 574
Communal Worship: 11 am Sunday.

--nextPart1936548.jGbeEE64qb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjb8DN0y+n1M3mo0RAnlCAJ0YB1WRNez65mvawvFVrbih2oE9lgCg1drl
Aa/O8qLc5htNjOLfHBJ87ls=
=ZQRS
-----END PGP SIGNATURE-----

--nextPart1936548.jGbeEE64qb--

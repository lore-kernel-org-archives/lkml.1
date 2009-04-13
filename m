Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbZDMCd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbZDMCd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 22:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZDMCdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 22:33:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53731 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbZDMCdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 22:33:17 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tedZhdy95ytFLFAK5Zod"
Date: Mon, 13 Apr 2009 03:33:12 +0100
Message-Id: <1239589992.18110.117.camel@deadeye.i.decadent.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.4.182
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 0/3] Fix rt28{6,7}0sta to use firmware loader
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tedZhdy95ytFLFAK5Zod
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Greg,

The Ralink drivers rt2860sta, rt2870sta and rt3070sta contain non-free
firmware which should be distributed separately.

Darren Salt wrote a patch for Debian for rt2860sta which I've cleaned up
slightly.  At my suggestion he also extended the ITU-T CRC code to
support this, allowing the copy in rt2860sta to be removed.  I have
duplicated and adapted the rt2860sta for rt2870sta, but this last patch
is untested.

rt3070sta remains unfixed.  So far as I can see, rt3070sta is a later
version of rt2870sta and should be merged with it rather than requiring
people to apply the same fixes twice.  Since Debian has never enabled
this driver in its kernel packages I have simply removed the firmware
and marked it as broken in our kernel source.

Ben.

Ben Hutchings (2):
  rt2860sta: use the firmware loader interface and library CRC code
  rt2870sta: use the firmware loader interface and library CRC code

Darren Salt (1):
  crc-itu-t: add bit-reversed calculation

 drivers/staging/rt2860/Kconfig            |    2 +
 drivers/staging/rt2860/common/firmware.h  |  558 -------------------------=
----
 drivers/staging/rt2860/common/rtmp_init.c |  309 ++++-------------
 drivers/staging/rt2870/Kconfig            |    2 +
 drivers/staging/rt2870/common/firmware.h  |  558 -------------------------=
----
 drivers/staging/rt2870/common/rtmp_init.c |  385 ++++----------------
 include/linux/crc-itu-t.h                 |   10 +
 lib/crc-itu-t.c                           |   18 +
 8 files changed, 168 insertions(+), 1674 deletions(-)
 delete mode 100644 drivers/staging/rt2860/common/firmware.h
 delete mode 100644 drivers/staging/rt2870/common/firmware.h


--=-tedZhdy95ytFLFAK5Zod
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJ4qRl79ZNCRIGYgcRAniXAJ9uq4Abi0P5xcjTqg9KHHs5l6w/7QCZAfdQ
pI+yUlhBRv26w+JmRN4DC6s=
=wE+S
-----END PGP SIGNATURE-----

--=-tedZhdy95ytFLFAK5Zod--

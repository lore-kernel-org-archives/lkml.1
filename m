Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZF0UeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZF0UeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 16:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZF0Ud5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 16:33:57 -0400
Received: from mx75.mail.ru ([94.100.176.90]:55366 "EHLO mx75.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZF0Ud5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 16:33:57 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Richard Purdie <rpurdie@rpsys.net>
Subject: Re: 2.6.30: hald crashes on resume from STR apparently on LED device
Date: Sun, 28 Jun 2009 00:34:48 +0400
User-Agent: KMail/1.12.0 (Linux/2.6.30-desktop-2mnb; KDE/4.2.95; x86_64; ; )
Cc: hal@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <200906142219.06891.arvidjaar@mail.ru> <200906211817.25878.arvidjaar@mail.ru> <1245679044.10200.17.camel@dax.rpnet.com>
In-Reply-To: <1245679044.10200.17.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2260842.DKW2J3TL0d";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906280034.51738.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2260842.DKW2J3TL0d
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Monday 22 of June 2009 17:57:24 Richard Purdie wrote:
> On Sun, 2009-06-21 at 18:17 +0400, Andrey Borzenkov wrote:
> > So what happens is simple. During suspend led device is removed;
> > during resume it is recreated. Apparently removing led device cause
> > hald-addon- leds to exit (thus disconnecting D-Bus connection); and
> > sometimes next "add" event comes too early, before hald had chance
> > to notice missing addon.
>
> Note that its the underlying device that is being removed here and
> since the LED is connected to that its removed as well. The LED
> subsystem hasn't changed in how it works. I don't think that has any
> bearing on your patch though.
>

Yes, looking more closely there is inherent race condition between=20
tearing down existing helper and processing ADD event for it. Most=20
likely some timing was changed in current kernel that made it more=20
easily exposed. If Mandriva had not compiled D-Bus with assertions=20
enabled, this would simply fail silently without anyone noticing.

--nextPart2260842.DKW2J3TL0d
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpGgmgACgkQR6LMutpd94yloACdHa3+V8cU4JKnFaDBfljjhG97
+E0AnA09Z8Jej9OIfdWh9o/mh43fR0x9
=kZVU
-----END PGP SIGNATURE-----

--nextPart2260842.DKW2J3TL0d--

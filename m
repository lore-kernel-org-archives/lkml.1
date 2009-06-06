Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZFFWiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZFFWiu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZFFWik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:38:40 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54607 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbZFFWij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:38:39 -0400
X-Sasl-enc: m+kpvYiz0InwBm7RK8I/UGuISR2JNzrQMXISdx1OoDDH 1244327921
Message-ID: <4A2AEFE2.2090300@imap.cc>
Date: Sun, 07 Jun 2009 00:38:26 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: karsten-keil@t-online.de, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] isdn: patches for 2.6.31
References: <20090531-patch-00.tilman@imap.cc> <20090601.030434.141357758.davem@davemloft.net>
In-Reply-To: <20090601.030434.141357758.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2F10CE731FB1CDF502B55318"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2F10CE731FB1CDF502B55318
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01.06.2009 12:04, David Miller wrote:
> First problem in the second patch.  You're doing two things
> at once.  You're adding function documentation and also adding
> a NULL pointer check.

No problem. I can split the patch in two if you prefer it that way.

> Second problem, the NULL pointer check is gratuitous.  Document
> that the 'm' member has to be non-NULL and leave the check out.

That would be a bad solution for two reasons:
First, the 'm' member is private to capiutil.{c,h}. Callers are
not supposed to access it. Therefore it shouldn't be referred to
in the interface documentation. At best, such a mention would
leave users of the function confused how to assure that condition.
At worst, it might mislead them into meddling directly with the
member, thereby producing incorrect code.
And second, the main use of capi_cmsg2str() is for error reporting
and debugging output. Oopsing in an error handler is particularly
troublesome. At the same time, the risk of the 'm' member being
unexpectedly NULL is particularly high when something has gone
wrong already. So a safety check is advisable in this case.

Thanks,
Tilman

PS: Any objections against the other two patches?

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig2F10CE731FB1CDF502B55318
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKKu/tQ3+did9BuFsRAmMaAJ90QRvFAukBuce29sULsLNxlppA5gCeJYBi
SlB+PmXl3gcCGo0JXSBItyk=
=5cc2
-----END PGP SIGNATURE-----

--------------enig2F10CE731FB1CDF502B55318--

Return-Path: <linux-kernel-owner+w=401wt.eu-S965479AbXBMJnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965479AbXBMJnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965480AbXBMJnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:43:31 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:2942 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965479AbXBMJna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:43:30 -0500
Message-ID: <45D18805.9080607@imap.cc>
Date: Tue, 13 Feb 2007 10:42:29 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Manu Abraham <abraham.manu@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: NAK new drivers without proper power management?
References: <1171059433.8675.195.camel@laptopd505.fenrus.org> <1171236787.4493.132.camel@nigel.suspend2.net> <20070212165207.GC17400@elf.ucw.cz> <200702122131.33662.rjw@sisk.pl>
In-Reply-To: <200702122131.33662.rjw@sisk.pl>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0DE75B69AE8443B01EA4D07E"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0DE75B69AE8443B01EA4D07E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki schrieb:
> I think we can introduce a "pm_safe" flag that will indicate if the dri=
ver
> handles suspend/resume correctly.  If we do it, we can flag all of the =
drivers
> currently in the tree as "pm_safe" unless we know that they aren't.  Ne=
xt,
> we can convert the core to fail the suspend for any driver that is not =
flagged
> as "pm_safe".  But I think that will take time.

Why a new flag? IMHO it would be both more readable and more efficient
to create a pm_generic_nosuspend() function which does "return -ENOSYS",
and set that as the .suspend method on drivers known to break
suspend/resume. New drivers should either have .suspend and .resume
methods of their own or set .suspend =3D pm_generic_nosuspend.

That way, NULL .suspend/.resume methods retain their current semantics
("don't know whether suspend would work, never thought about it"),
error-returning ones would clearly signal "cannot suspend safely", and
success-returning ones would equally clearly signal "suspend works ok".
(Bugs nonwithstanding.)

There could then be a policy parameter (Kconfig selectable to start)
to abort suspend when encountering a driver without .suspend/.resume
methods, or to proceed with a warning message.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig0DE75B69AE8443B01EA4D07E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF0YgFMdB4Whm86/kRArxaAJ4tYtDMawg/pnFuVGQU0OxMx30MSgCeL6TN
eisR2/3qenX91ZreShuKbxo=
=rGIi
-----END PGP SIGNATURE-----

--------------enig0DE75B69AE8443B01EA4D07E--

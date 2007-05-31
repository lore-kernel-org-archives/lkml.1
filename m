Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXEaQNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXEaQNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbXEaQN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:13:29 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39092 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbXEaQN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:13:29 -0400
X-Sasl-enc: /TpI/uSMdiO53yU3/1VJiioCz8sVz39whsueuf7VGTNv 1180628007
Message-ID: <465EF4F4.1090507@imap.cc>
Date: Thu, 31 May 2007 18:16:52 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Andrew Morton <akpm@linux-foundation.org>, kkeil@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/06] Use menuconfig objects 4 - ISDN part 2/6 (CONFIG_ISDN_I4L)
References: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net> <Pine.LNX.4.61.0705302137560.11140@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705302137560.11140@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDCFDCC3C006B371C443A3EF0"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDCFDCC3C006B371C443A3EF0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 30.05.2007 21:38 schrieb Jan Engelhardt:
> --- linux-2.6.22-rc3-git1.orig/drivers/isdn/Kconfig
> +++ linux-2.6.22-rc3-git1/drivers/isdn/Kconfig
> @@ -21,9 +21,7 @@ menuconfig ISDN
> =20
>  if ISDN
> =20
> -menu "Old ISDN4Linux"
> -
> -config ISDN_I4L
> +menuconfig ISDN_I4L
>  	tristate "Old ISDN4Linux (obsolete)"
>  	---help---
>  	  This driver allows you to use an ISDN-card for networking
> @@ -44,8 +42,6 @@ if ISDN_I4L
>  source "drivers/isdn/i4l/Kconfig"
>  endif
> =20
> -endmenu
> -
>  comment "CAPI subsystem"
> =20

This results in a rather strange and inconsistent presentation in
"make xconfig", with ISDN4Linux appearing as a subtree in the left
pane but CAPI only visible in the right pane after selecting ISDN.
IMHO it looks much saner like this:

--- a/drivers/isdn/Kconfig
+++ b/drivers/isdn/Kconfig
@@ -21,8 +21,6 @@ menuconfig ISDN

 if ISDN

-menu "Old ISDN4Linux"
-
 config ISDN_I4L
 	tristate "Old ISDN4Linux (deprecated)"
 	---help---
@@ -44,12 +42,8 @@ if ISDN_I4L
 source "drivers/isdn/i4l/Kconfig"
 endif

-endmenu
-
-comment "CAPI subsystem"
-
 config ISDN_CAPI
-	tristate "CAPI2.0 support"
+	tristate "CAPI 2.0 subsystem"
 	help
 	  This provides the CAPI (Common ISDN Application Programming
 	  Interface, a standard making it easy for programs to access ISDN

This gives you a single entry in the left pane tree for disabling
all of ISDN with a single click, and nicely presents all of its
suboptions in the right pane once you select the tree entry.

HTH
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigDCFDCC3C006B371C443A3EF0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGXvT7MdB4Whm86/kRAqKlAJ9uFQSvNw45Fdz03cG1D+GM4m6t3wCeI2KE
ZwDV9C1rq4/J2kKKAfGvSLY=
=VO8E
-----END PGP SIGNATURE-----

--------------enigDCFDCC3C006B371C443A3EF0--

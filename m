Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbXEEWUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbXEEWUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 18:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXEEWUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 18:20:37 -0400
Received: from paperstreet.colino.net ([213.41.244.236]:54684 "EHLO
	paperstreet.colino.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbXEEWUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 18:20:35 -0400
Date: Sun, 6 May 2007 00:20:28 +0200
From: Colin Leroy <colin@colino.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Richard Purdie <rpurdie@openedhand.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] led-class.c permission change
Message-ID: <20070506002028.53230d56@localhost.localdomain>
In-Reply-To: <20070505224803.67f76749@the-village.bc.nu>
References: <20070505124954.0e2bcf53@localhost.localdomain>
	<20070505224803.67f76749@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1cvs43 (GTK+ 2.10.11; i686-pc-linux-gnu)
X-Face: Fy:*XpRna1/tz}cJ@O'0^:qYs:8b[Rg`*8,+o^[fI?<%5LeB,Xz8ZJK[r7V0hBs8G)*&C+XA0qHoR=LoTohe@7X5K$A-@cN6n~~J/]+{[)E4h'lK$13WQf$.R+Pi;E09tk&{t|;~dakRD%CLHrk6m!?gA,5|Sb=fJ=>[9#n1Bu8?VngkVM4{'^'V_qgdA.8yn3)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEUAAwASFBYfISMyMTRGRUdaWFdxb2yJhoKrqaPOzMT19Ow5JzfkAAACW0lEQVQ4y6WTP1PbMBjGo6T/RkmmLWxIotCxtkRpmYqVMLAFY2i7AU0DbEDACVOvd6aED9DYnntg61NWCo0tt2N1vpyjn5/30ftIajT+Z4BVLLw3/0w7a+MsVXln8a/5x+E47fXT5FLW55ubP0ZFViTj6KImcXb7l5Pr4XD4JQo3bNDSVdIbLgLhd3ZssLwXHyUXwheACWnXivrx13bHRU3ECHMt6yjsDA8XIWygJsZeBZ5E/mrHBwAgpB9W1XodSw+Dh3cEvA8lODrQVR5i0Q8pTUB0Dq3I3LKTR/3cQyXC5KzM6b1Kugj9+YfI91LxWaUHej1gqsL0vAzkSiUHZqXGFToWuFUTSRHExEiarAsrcO1ThPDUpuVszAC4KgbcI7plQ5q4Cus2Dzh30e72w3ekbCnpSSERXpJGAdhs4Y35ImZiLVNn0y7RyqxzcKvUwDtRKne5JnhuFmJLKXXnZ/p3X0tAZQ4MONUy1UWgAXG1H/rj/HRLA1fbQuCUYN1Ueakp0UkCwMqgW1mhTvFxca67hxDxEoCtvNhHDtd5IQAc65Qs5PcSMbHjasD96iyA+TymlEujcIoza5tfFGlAKOceQm9VYG2/KFRAGeeUoOXUPtRsMupxJrkutTSuXYPonT4MbaNYOq6BlVHAPWEA34O1i5YGQmoPXWsP1a7aeEI5oxRj9LEOtu449SgmBB6FtVpPB9rBDChuagDs8Okg4FVG7Ft7eRKLtmnEWc66Fvg0Wc/boeQu7u6Ovln2PwcL6ZdO2yOrz3ujX6BySA6fpXEovbntcHNwb9x/A34/oQVbOAIKAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_xt.g+S5w7/0Cfzl8N7mIjEu";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_xt.g+S5w7/0Cfzl8N7mIjEu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On 05 May 2007 at 22h05, Alan Cox wrote:

Hi,=20

> > This patch changes the led brightness file's permissions to 0666,
> > so that a user's MUA can light up the mail LED without needing root
> > permissions. =20
>=20
> NAK.
>=20
> The management of user specific temporary permissions belongs in user
> space with a safe "no" default value to stop background daemons doing
> silly things.

Mmh, ok... My usage pattern for this is for an MUA plugin[1] that does
write 1 to /sys/class/leds/asus:mail/brightness, for example, when new
mail comes. The MUA typically runs as user and until now most of the
handled LEDs had no such permission problems
(/proc/acpi/asus/mled, /proc/acpi/acer/mailled etc).=20

So, I've got to find a way to write into that file as user so that
things automatically work.

> Take a look at the various pam console management modules (and also
> beat people up to get revoke() support into the kernel).

So, you suggest me to link my plugin to libpam and find something that
allows the plugin to write into /brightness?=20

Thanks,

[1] http://www.claws-mail.org/plugin.php?plugin=3Dacpinotifier
--=20
Colin

--Sig_xt.g+S5w7/0Cfzl8N7mIjEu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGPQMvS3OlVpbZQYkRAkn7AJ9+zQDgJwZpUbv9rFes3a7f0OjQ0ACgkKM0
WvbIE69hoBeRzht6zHQ4N2s=
=9bSB
-----END PGP SIGNATURE-----

--Sig_xt.g+S5w7/0Cfzl8N7mIjEu--

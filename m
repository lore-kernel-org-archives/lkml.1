Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZHKMGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZHKMGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZHKMGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:06:06 -0400
Received: from smtp-out26.alice.it ([85.33.2.26]:3760 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbZHKMGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:06:04 -0400
Date: Tue, 11 Aug 2009 14:05:00 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: [RFC] Freescale MC13783 PMIC support
Message-Id: <20090811140500.2678b289.ospite@studenti.unina.it>
In-Reply-To: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de>
References: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.16.5; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__11_Aug_2009_14_05_00_+0200_o6OqnD_11j7wEVXE"
X-OriginalArrivalTime: 11 Aug 2009 12:05:24.0974 (UTC) FILETIME=[0243B8E0:01CA1A7C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Aug_2009_14_05_00_+0200_o6OqnD_11j7wEVXE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Aug 2009 11:07:42 +0200
Sascha Hauer <s.hauer@pengutronix.de> wrote:

> Hi all,
>=20
> This series adds support for the Freescale MC13783 PMIC. The MC13783
> is connected via SPI, the first patch adds basic support for it in
> drivers/mfd. The rest of the patches can be applied independently.
> Individual Maintainers are on Cc, the whole series can be found on
> lkml and the Arm Linux Kernel mailing list.
> Please ignore the previous mail which lacked the intrductory mail.
>=20
> Sascha
>

Hi Sascha,

the MC13783 is also named Atlas, isn't it?
Maybe you can add this name somewhere in comments or in Kconfig entry
to help greppers and web crawlers.

BTW, I only took a very brief look to some of your patches, and here's
some humble thoughts, sorry if I don't comment patch by patch.

There is a driver queued for inclusion in 2.6.31 for the PCAP2
PMIC, which is quite similar to MC13783. This driver uses the irq_chip
mechanism to expose the PMIC IRQs to be used as general IRQs in
sub-devices drivers (which you call client-devices AFAICS). Also, it
passed all the reviews so maybe you can give it a look to take some
other solution already accepted by reviewers, like passing sub-devices
via platform data (some of the phones which use PCAP2 don't have
touchscreen, for instance), generalize the driver so to handle multiple
PMICs in one system (quite unlikely scenario?), read actual pressure
in TS driver.

The latest (fixed) version of the core and ADC driver is in [1], but you
can find also the regulator and input drivers in [2] which are queued
for 2.6.32, the rtc driver can be found in [3]
(rtc-driver-for-pcap2-pmic-*.patch).

Regards,
   Antonio

[1]
http://git.kernel.org/?p=3Dlinux/kernel/git/sameo/mfd-2.6.git;a=3Dblob;f=3D=
drivers/mfd/ezx-pcap.c;h=3D016be4938e4c4baac63168e2c478f335ae162ed9;hb=3Dfo=
r-next

[2]
http://git.kernel.org/?p=3Dlinux/kernel/git/sameo/mfd-2.6.git;a=3Dsummary

[3] http://userweb.kernel.org/~akpm/mmotm/broken-out/

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Tue__11_Aug_2009_14_05_00_+0200_o6OqnD_11j7wEVXE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqBXmwACgkQ5xr2akVTsAEM4QCfVlkdwCHhytkD/jAHiOtYr2mZ
7KAAnipKUVB67Cmg0+ji7yu0krStiiiI
=SdRZ
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Aug_2009_14_05_00_+0200_o6OqnD_11j7wEVXE--

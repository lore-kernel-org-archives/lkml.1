Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050Ab0AYFwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab0AYFwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 00:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876Ab0AYFwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 00:52:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51678 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0AYFwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 00:52:37 -0500
Date: Mon, 25 Jan 2010 16:52:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tobias Klauser <tklauser@distanz.ch>, John Linn <john.linn@xilinx.com>
Subject: linux-next: input tree build failure
Message-Id: <20100125165219.cd0b869d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Jan_2010_16_52_19_+1100_q6.2x4s0_YdtIP/1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jan_2010_16_52_19_+1100_q6.2x4s0_YdtIP/1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

Today's linux-next build (powerpc ppc44x_defconfig) failed like this:

drivers/input/serio/xilinx_ps2.c: In function 'xps2_of_probe':
drivers/input/serio/xilinx_ps2.c:273: error: incompatible type for argument=
 1 of 'resource_size'
include/linux/ioport.h:132: note: expected 'const struct resource *' but ar=
gument is of type 'struct resource'
drivers/input/serio/xilinx_ps2.c: In function 'xps2_of_remove':
drivers/input/serio/xilinx_ps2.c:347: error: incompatible type for argument=
 1 of 'resource_size'
include/linux/ioport.h:132: note: expected 'const struct resource *' but ar=
gument is of type 'struct resource'

Please at least build test this stuff ...

Caused by commit cc7bbfa322b48be82b1c86a104433d4ac349da79 ("Input:
xilinx_ps2 - use resource_size").

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Jan_2010_16_52_19_+1100_q6.2x4s0_YdtIP/1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktdMZMACgkQjjKRsyhoI8w7OgCguZPDU0meR46hLlrIsdgGExfy
qRMAniEtAb2AK3xfvPhydY3R3RiOAiRQ
=ywmw
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jan_2010_16_52_19_+1100_q6.2x4s0_YdtIP/1--

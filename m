Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbZLWXsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbZLWXsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 18:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbZLWXsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 18:48:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50804 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757511AbZLWXsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 18:48:36 -0500
Date: Thu, 24 Dec 2009 10:48:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: linux-next: tty tree build failure
Message-Id: <20091224104830.fe78906e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Dec_2009_10_48_30_+1100_dngPOR50U949FSJr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Dec_2009_10_48_30_+1100_dngPOR50U949FSJr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/mmc/card/sdio_uart.c: In function 'sdio_uart_add_port':
drivers/mmc/card/sdio_uart.c:99: warning: passing argument 1 of 'kfifo_allo=
c' makes pointer from integer without a cast
include/linux/kfifo.h:110: note: expected 'struct kfifo *' but argument is =
of type 'long unsigned int'
drivers/mmc/card/sdio_uart.c:99: warning: passing argument 3 of 'kfifo_allo=
c' makes integer from pointer without a cast
include/linux/kfifo.h:110: note: expected 'gfp_t' but argument is of type '=
struct spinlock_t *'
drivers/mmc/card/sdio_uart.c:99: warning: assignment makes pointer from int=
eger without a cast
drivers/mmc/card/sdio_uart.c: In function 'sdio_uart_transmit_chars':
drivers/mmc/card/sdio_uart.c:476: error: implicit declaration of function '=
kfifo_get'
drivers/mmc/card/sdio_uart.c: In function 'sdio_uart_write':
drivers/mmc/card/sdio_uart.c:810: error: implicit declaration of function '=
kfifo_put'

Caused by commit ed30500af457c06b533549f5554671e58c4db18a ("tty:
sdio_uart: Use kfifo instead of the messy circ stuff") interacting with
the kfifo API change in Linus' tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Dec_2009_10_48_30_+1100_dngPOR50U949FSJr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksyrE4ACgkQjjKRsyhoI8z+1ACfY2HX/j/yytLd8/H/j3+Jyf0K
lPgAnisJPYEpZ/SsqZ4EmdV3yvNBDh7t
=zzVm
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Dec_2009_10_48_30_+1100_dngPOR50U949FSJr--

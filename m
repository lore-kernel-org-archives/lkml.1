Return-Path: <linux-kernel-owner+w=401wt.eu-S940427AbXHIOp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940427AbXHIOp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935832AbXHIOpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:45:18 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:53261 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936637AbXHIOpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:45:17 -0400
Date: Thu, 9 Aug 2007 16:45:11 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: "??" <wux@landicorp.com>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] mmc: at91_mci: add multiwrite cap
Message-ID: <20070809164511.6f40fa7b@poseidon.drzeus.cx>
In-Reply-To: <46BB200F.5090300@rfo.atmel.com>
References: <46B9926B.3090707@rfo.atmel.com>
	<20070808121147.1433d055@poseidon.drzeus.cx>
	<46B9D6EE.4040705@rfo.atmel.com>
	<20070808170108.4db814d1@poseidon.drzeus.cx>
	<46BB200F.5090300@rfo.atmel.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-14570-1186670712-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-14570-1186670712-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 09 Aug 2007 16:09:19 +0200
Nicolas Ferre <nicolas.ferre@rfo.atmel.com> wrote:

>=20
> Ok thank you : it was the point.
>=20
> Results : in brief :
> - there is work to be done ;-)
> - multiwrite test result is : OK
>=20

I'm starting to get the feeling that writing this test driver was a
good idea. :)

> I had to modify the mmc_test to workaround the driver being stuck.
> I attach the patch so you can figure out the testcase I ran :
>=20
> diff -u b/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
> --- b/drivers/mmc/card/mmc_test.c
> +++ b/drivers/mmc/card/mmc_test.c
> @@ -149,7 +149,8 @@
>  	printk(KERN_INFO "%s: Testing reading power of two block
> sizes...\n", mmc_hostname(card->host));
> =20
> -	for (i =3D 1;i <=3D 512;i <<=3D 1) {
> +//	for (i =3D 1;i <=3D 512;i <<=3D 1) {
> +	for (i =3D 512;i <=3D 512;i <<=3D 2) { /*must have size%4 =3D=3D 0*/
>  		memset(&mrq, 0, sizeof(struct mmc_request));
> =20
>  		mrq.cmd =3D &cmd;

These "fixes" shouldn't be needed with the recent patch by Marc Pignat.

>=20
> And here is the output :
>=20
> With a SD card :
> root@at91sam9263ek:~$ mmc0: card is read-write
> mmc0: new SD card at address 0002
> mmc0: About to test mmc subsystem
> mmc0: Testing writing power of two block sizes...
> .<7>mmc0: starting CMD16 arg 00000200 flags 00000015
>=20
> mmc0: Result: OK
> mmc0: Testing reading power of two block sizes...
> mmc0: Result: OK
> mmc0: Testing correct bytes_xfered for a single block...
> mmc0: Result: OK
> mmc0: Testing correct bytes_xfered for multiple blocks...
> mmc0: Result: OK

This looks ok (although this test doesn't verify the more exotic cases
of updating bytes_xfered).

> I do not know if the OOps is due to a bad behavior of the driver
> during the wait for busy test...
>=20

I don't suppose you could do a bit more digging? I'm not getting that
crash here.

> And with a MMC : quite the same results but with :
>=20
> mmc0: Testing correct bytes_xfered for a single block...
> mmc0: Result: FAIL
>=20

This is very odd. Could you test some more MMC and SD cards and see if
this is just a fluke? This test shouldn't be card dependent.

Rgds
Pierre

--=_hera.drzeus.cx-14570-1186670712-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGuyh37b8eESbyJLgRAp1PAJwOXkQ9hWgPgcBMFP4dVTjjYhqJNQCfea10
SJapm7I7p5XT55uGmayjJLg=
=Aw7H
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-14570-1186670712-0001-2--

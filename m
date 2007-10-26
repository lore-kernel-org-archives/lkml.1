Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbXJZLf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbXJZLf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXJZLfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:35:51 -0400
Received: from donetsk.donpac.ru ([80.254.111.38]:42293 "EHLO
	donetsk.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXJZLfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:35:50 -0400
Date: Fri, 26 Oct 2007 15:35:45 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Chris Bergeron <chris@pcburn.com>, linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Message-ID: <20071026113544.GA20216@pazke.donpac.ru>
Mail-Followup-To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Chris Bergeron <chris@pcburn.com>, linux-kernel@vger.kernel.org
References: <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com> <20071012120826.GB23378@pazke.donpac.ru> <47150B06.3040306@pcburn.com> <20071017064219.GB1953@pazke.donpac.ru> <471689DA.4070008@pcburn.com> <20071018055755.GA9561@pazke.donpac.ru> <47179116.2070505@pcburn.com> <20071022153323.GA8123@pazke.donpac.ru> <20071022161808.GJ4003@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20071022161808.GJ4003@csclub.uwaterloo.ca>
X-Uname: Linux 2.6.22-2-amd64 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 295, 10 22, 2007 at 12:18:08PM -0400, Lennart Sorensen wrote:
> On Mon, Oct 22, 2007 at 07:33:23PM +0400, Andrey Panin wrote:
> > So the card probably generates screaming interrupt... that's bad.
> > I found some docs for IT887x chips, according to these docs  IT887x
> > have simple interrupt controller inside. Further investigation is neede=
d.
> >=20
> > Can you post output of lspci -xxx ?
>=20
> Is it possible they put a chip on to generate a PCI interrupt on perhaps
> PCIB on the slot from the serial chips directly, so that they didn't
> have to turn interrupts from the serial chips into a signal that forces
> the parallel port to generate an interrupt?  After all that would reduce
> latency, and if you use PCIA for the parallel port, PCIB for the first
> serial chip and PCIC for the second, you might get a much more efficient
> design, although the driver would have to register all those IRQs.

I dont think so. IT887x has builtin interrupt controller which multiplexes=
=20
16 external IRQ pins with IRQs from builtin devices (parallel port, UARTs
and GPIO) into single INTA# line. IT887x also contains 8-bit ISA-like bus
and 16 chip select lines and it's all you need to glue UARTs to PCI bus.

I suspect that it's interrupt controller problem, probably edge/level
triggered settings.

> What IRQ is each PCI device in that system using right now?  perhaps we
> could figure out what irq 17 would be on that PCI slot.

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHIdEQIWZCBzwS8mkRApFlAJ9s7Do/xlxsLOmGobVmnjUno0PPfwCeLxqj
GUwkkOWIApV62UmeaqBc9j0=
=YtaA
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--

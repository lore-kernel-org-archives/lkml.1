Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbYGDBwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbYGDBwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYGDBwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:52:09 -0400
Received: from ozlabs.org ([203.10.76.45]:33033 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbYGDBwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:52:08 -0400
Subject: Re: Multiple MSI
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: benh@kernel.crashing.org
Cc: Matthew Wilcox <matthew@wil.cx>, Arnd Bergmann <arnd@arndb.de>,
       linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1215085266.19689.19.camel@pasglop>
References: <20080703024445.GA14894@parisc-linux.org>
	 <1215060119.21182.77.camel@pasglop> <1215067484.17950.35.camel@localhost>
	 <200807031110.30072.arnd@arndb.de> <1215076620.19689.2.camel@pasglop>
	 <20080703113128.GC14894@parisc-linux.org>
	 <1215085266.19689.19.camel@pasglop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-matlyWlX7FUrMaDNaWDZ"
Date: Fri, 04 Jul 2008 11:52:04 +1000
Message-Id: <1215136324.7849.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-matlyWlX7FUrMaDNaWDZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-03 at 21:41 +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2008-07-03 at 05:31 -0600, Matthew Wilcox wrote:
> > On Thu, Jul 03, 2008 at 07:17:00PM +1000, Benjamin Herrenschmidt wrote:
> > > > Some years ago, we had discussions about getting rid of IRQ numbers
> > > > altogether, or at least the requirement to have device drivers know
> > > > about them. Does anyone remember what happened to that idea?
> > >=20
> > > I think it's not totally dead. Last I heard, someone (jgarzik ?) was
> > > slowly, bit by bit, removing the dependencies on the irq argument on =
irq
> > > handlers which is one step in the direction.
> >=20
> > I think that project's dead, Jim.  http://lkml.org/lkml/2008/4/22/578
>=20
> Ouch, missed that one... sad, would have been a good idea in the long
> run. irq_desc array is a big PITA.

Well it looks like Linus' main objection is with changing the driver
API, which does make sense, _that_ would be a PITA.

> > You can't do that.  /proc/interrupts is so terribly useful for a
> > sysadmin that you can't remove information from it.
>=20
> You can create a new one with informations about the new stuff..
>=20
> Anyway, looks like it's not happening and we'll be stuck with the bloody
> array for the time being. Crap.

In most cases that I can see the conversion from irq number to irq_desc
is done in the genirq code, so I don't see why you couldn't just put a
remapping in there from irq numbers to descs that doesn't use an array.=20
But maybe I'm missing something.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-matlyWlX7FUrMaDNaWDZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIbYJEdSjSd0sB4dIRAjwBAJ0TQrjPfIKz8ZES/YJV9ubgm5R6QgCfVxtT
ZzCnp8c8ssVrbqIAaFLlCso=
=89F3
-----END PGP SIGNATURE-----

--=-matlyWlX7FUrMaDNaWDZ--


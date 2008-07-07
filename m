Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYGGDsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYGGDsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 23:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYGGDsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 23:48:37 -0400
Received: from ozlabs.org ([203.10.76.45]:42731 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbYGGDsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 23:48:36 -0400
Subject: Re: [PATCH 1/4] PCI MSI: Store the number of messages in the
	msi_desc
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20080707024125.GU14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org>
	 <1215264855-4372-1-git-send-email-matthew@wil.cx>
	 <1215396324.19157.14.camel@localhost>
	 <20080707024125.GU14894@parisc-linux.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u0TqH+shhaE47w6Ck6Bo"
Date: Mon, 07 Jul 2008 13:48:32 +1000
Message-Id: <1215402512.9862.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-u0TqH+shhaE47w6Ck6Bo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-07-06 at 20:41 -0600, Matthew Wilcox wrote:
> On Mon, Jul 07, 2008 at 12:05:24PM +1000, Michael Ellerman wrote:
> > On Sat, 2008-07-05 at 09:34 -0400, Matthew Wilcox wrote:
> > > This first part simply changes the msi_attrib data structure to store
> > > how many vectors have been allocated.  In order to do this, I shrink =
the
> > > 'type' from 5 bits to 2 and rename it to _type to catch any unsuspect=
ing
> > > users.
> >=20
> > Please don't, it significantly uglifies the code IMHO. Just add a new
> > field for the size, I'd rather call it qsize to match the register.
>=20
> Uglifies the code?  Seriously?  Other than the _ addition (which really
> I just did to be sure I didn't miss a case), how is MSI_ATTRIB uglier
> than PCI_CAP_ID_MSI?

Yeah seriously :)  The _ is part of it, but MSI_ATTRIB is uglier than
PCI_CAP_ID_MSI exactly because it's not PCI_CAP_ID_MSI, which exists and
is well defined and is used in the rest of the code.

> I'd like to rename the register definition from QSIZE.  It's _not_ a
> queue.  I don't know where this misunderstanding came from, but I
> certainly don't want to spread it any further.

I didn't say it was a queue, but a Q ;)  But I agree it's not a good
name, the spec calls it "multiple message enable", nvec would match the
existing code best, or log_nvec.

> > If you're worried about bloating msi_desc, there's several fields in
> > there that are per-device not per-desc, so we could do another patch to
> > move them into pci_dev or something hanging off it, eg.
> > pci_dev->msi_info rather than storing them in every desc.
>=20
> Might be worth it anyway for devices with lots of MSI-X interrupts.

Eventually yeah, last I looked we didn't have any drivers using more
than a few MSI-X, but at some point it will happen.

> I think the MSI-X implementation is a bit poorly written anyway.  If we
> had an array of msi_desc for each device, we could avoid the list_head
> in the msi_desc, for example.  That'd save two pointers (8 or 16 bytes),
> plus the overhead of allocating each one individually.

Yeah that would be nice.

> I also think that MSI-X could be improved by changing the interface to
> do away with this msix_entry list passed in -- just allocate the irqs
> consecutively.

It would be nice, but as I said the other day we have at least one
driver (s2io) which asks for non-consecutive entries. That doesn't
effect the irq allocation, but you need some way for the driver to
express it.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-u0TqH+shhaE47w6Ck6Bo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIcZIQdSjSd0sB4dIRAgwPAKCWNL0cJ7rfKR1sAmL3Sj1UR7F7CwCgxn3I
4zdpLeMNTKm4Cx5Ed7+NZ7k=
=+PU/
-----END PGP SIGNATURE-----

--=-u0TqH+shhaE47w6Ck6Bo--


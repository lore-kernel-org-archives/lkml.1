Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYGGD5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYGGD5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 23:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYGGD4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 23:56:54 -0400
Received: from ozlabs.org ([203.10.76.45]:43255 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbYGGD4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 23:56:54 -0400
Subject: Re: [PATCH 2/4] PCI: Support multiple MSI
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20080707024525.GV14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org>
	 <1215264855-4372-2-git-send-email-matthew@wil.cx>
	 <1215396326.19157.15.camel@localhost>
	 <20080707024525.GV14894@parisc-linux.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X8a4ZKpKerEs/RqS+GPp"
Date: Mon, 07 Jul 2008 13:56:52 +1000
Message-Id: <1215403012.9862.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X8a4ZKpKerEs/RqS+GPp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-07-06 at 20:45 -0600, Matthew Wilcox wrote:
> On Mon, Jul 07, 2008 at 12:05:25PM +1000, Michael Ellerman wrote:
> > On Sat, 2008-07-05 at 09:34 -0400, Matthew Wilcox wrote:
> > > Add the new API pci_enable_msi_block() to allow drivers to
> > > request multiple MSIs.  Reimplement pci_enable_msi in terms
> > > of pci_enable_msi_block.  Add a default implementation of
> > > arch_setup_msi_block() that only allows one MSI to be requested.
> >=20
> > I don't think you need arch_setup_msi_block() at all.
> >=20
> > We already have an arch hook that takes a number of irqs, it's
> > arch_setup_msi_irqs(), plural. It also has the type passed to it (MSI o=
r
> > MSI-X), so it can decide if it needs to allocate the irq numbers
> > contiguously.
> >=20
> > Or am I missing something?
>=20
> I suppose I should audit the current implementors of arch_setup_msi_irqs
> (er, maybe that's just you?) to be sure that there's no assumption that
> MSI -> asked for one. =20

Yeah I think it's just us.

But there's also the default implementation, which will happily use the
singular arch hook to setup multiple MSIs without any constraint on the
irq numbers - which will break.

So I think you want to make the default arch_msi_check_device() return
an error if you ask for MSI & nvec > 1. Then on powerpc we'll probably
add the same check to our version (at least until we can test it), but
on x86 you can let MSI & nvec > 1 pass.

> I'll look into doing it your way tomorrow (my timezone ;-)

Sure, although that'll be today in my timezone :D

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-X8a4ZKpKerEs/RqS+GPp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIcZQEdSjSd0sB4dIRAlZqAKCCXaFujmjjaQt+7lmpcYMM8Xz8TACdG/u2
I1Q2EThHZ9XjsBJmO29E6iU=
=Kk0m
-----END PGP SIGNATURE-----

--=-X8a4ZKpKerEs/RqS+GPp--


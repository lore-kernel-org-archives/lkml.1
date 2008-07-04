Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbYGDWDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbYGDWDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 18:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYGDWDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 18:03:13 -0400
Received: from server.drzeus.cx ([85.8.24.28]:60960 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752145AbYGDWDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 18:03:12 -0400
Date: Sat, 5 Jul 2008 00:02:59 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: How to alloc highmem page below 4GB on i386?
Message-ID: <20080705000259.3d74c5b6@mjolnir.drzeus.cx>
In-Reply-To: <20080704133733.278b6458@infradead.org>
References: <20080630200323.2a5992cd@mjolnir.drzeus.cx>
	<20080704195800.4ef6e00a@mjolnir.drzeus.cx>
	<20080704111224.68266afc@infradead.org>
	<20080704222323.68afbe88@mjolnir.drzeus.cx>
	<20080704133733.278b6458@infradead.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-3737-1215208990-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-3737-1215208990-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 4 Jul 2008 13:37:33 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 4 Jul 2008 22:23:23 +0200
> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> >=20
> > I was under the impression that the PCI bus was utterly incapable of
> > any larger address than 32 bits? But perhaps you only consider PCIE
> > stuff high-perf. :)
>=20
> actually your impression is not correct. There's a difference between
> how many physical bits the bus has, and the logical data. Specifically,
> PCI (and PCIE etc) have something that's called "Dual Address Cycle",
> which is a pci bus transaction that sends the 64 bit address using 2
> cycles on the bus even if the buswidth is 32 bit (logically).
>=20

Ah, I see. I have to admit to only have read the PCI spec briefly. :)

Still, the devices I'm poking have 32-bit fields, so the limitation is
still there for my case.

> >=20
> > The strange thing is that I keep getting pages from > 4GB all the
> > time, even on a loaded system. I would have expected mostly getting
> > pages below that limit as that's where most of the memory is. Do you
> > have any insight into which areas tend to fill up first?
>=20
> ok this is tricky and goes way deep into buddy allocator internals.
> On the highest level (2Mb chunks iirc, but it could be a bit or
> two bigger now) we allocate top down. But once we split such a top level
> chunk up, inside the chunk we allocate bottom up (so that the scatter
> gather IOs tend to group nicer).=20
> In addition, the kernel will prefer allocating userspace/pagecache
> memory from highmem over lowmem, out of an effort to keep memory
> pressure in the lowmem zones lower.
>=20

For the test I'm playing with, in does a second order allocation, which
I suppose has good odds of finding a suitable hole somewhere in the
upper GB.

Ah well, I suppose this highmem business will eventually blow over. ;)

Thanks
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-3737-1215208990-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhunh0ACgkQ7b8eESbyJLgPZwCggF4dNRT2eN/UDdaS3/eDoX0p
7/sAoIZW22+C4/Ewm64CFDQWwCbZqmAI
=WkXH
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-3737-1215208990-0001-2--

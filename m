Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbYGDUXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYGDUXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYGDUXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:23:32 -0400
Received: from server.drzeus.cx ([85.8.24.28]:60483 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817AbYGDUXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:23:32 -0400
Date: Fri, 4 Jul 2008 22:23:23 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: How to alloc highmem page below 4GB on i386?
Message-ID: <20080704222323.68afbe88@mjolnir.drzeus.cx>
In-Reply-To: <20080704111224.68266afc@infradead.org>
References: <20080630200323.2a5992cd@mjolnir.drzeus.cx>
	<20080704195800.4ef6e00a@mjolnir.drzeus.cx>
	<20080704111224.68266afc@infradead.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-2886-1215203009-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-2886-1215203009-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 4 Jul 2008 11:12:24 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 4 Jul 2008 19:58:00 +0200
> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
>=20
> > On Mon, 30 Jun 2008 20:03:23 +0200
> > Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> >=20
> > > Simple question. How do I allocate a page from highmem, that's still
> > > within 32 bits? x86_64 has the DMA32 zone, but i386 has just
> > > HIGHMEM. As most devices can't DMA above 32 bit, I have 3 GB of
> > > memory that's not getting decent usage (or results in needless
> > > bouncing). What to do?
> > >=20
> > > I tried just enabling CONFIG_DMA32 for i386, but there is some guard
> > > against too many memory zones. I'm assuming this is there for a good
> > > reason?
> > >=20
> >=20
> > Anyone?
> >=20
>=20
> well... the assumption sort of is that all high-perf devices are 64 bit
> capable. For the rest... well you get what you get. There's IOMMU's in
> modern systems from Intel (and soon AMD) that help you avoid the bounce
> if you really care.=20

I was under the impression that the PCI bus was utterly incapable of
any larger address than 32 bits? But perhaps you only consider PCIE
stuff high-perf. :)

>=20
> The second assumption sort of is that you don't have 'too much' above
> 4Gb; once you're over 16Gb or so people assume you will run the 64 bit
> kernel instead...

Unfortunately some proprietary crud keeps migration somewhat annoying.
And in my case it's a 4 GB system, where 1 GB gets mapped up to make
room for devices, so it's not that uncommon.

The strange thing is that I keep getting pages from > 4GB all the time,
even on a loaded system. I would have expected mostly getting pages
below that limit as that's where most of the memory is. Do you have any
insight into which areas tend to fill up first?

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-2886-1215203009-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhuhsAACgkQ7b8eESbyJLhQHgCcDj+RSLJ2yV+HQt/hJ2uwiDId
N10AoJGqXA/ie16jCKDTk6uvHGOTzSn4
=cZRp
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-2886-1215203009-0001-2--

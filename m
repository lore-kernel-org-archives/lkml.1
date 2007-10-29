Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbXJ2UNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbXJ2UNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbXJ2UN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:13:26 -0400
Received: from home.keithp.com ([63.227.221.253]:4046 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbXJ2UNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:13:25 -0400
Subject: Re: [RFC] AGP initial support for chipset flushing..
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Dave Airlie <airlied@skynet.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
In-Reply-To: <200710291247.24791.jesse.barnes@intel.com>
References: <Pine.LNX.4.64.0710290811070.1170@skynet.skynet.ie>
	 <200710291247.24791.jesse.barnes@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8xI0ekkhwxh9IEjF1EsV"
Date: Mon, 29 Oct 2007 13:12:58 -0700
Message-Id: <1193688778.4723.35.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8xI0ekkhwxh9IEjF1EsV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-10-29 at 12:47 -0700, Jesse Barnes wrote:

> In this case, we're performing basically a dma_sync*(...DMA_TO_DEVICE)=20
> right?

But this is just for the GPU; every other DMA device in the system is
cache-coherent.

>   Can we be sure that a single flush is sufficient?  Is there any=20
> window between when we flush and when we start accessing memory with=20
> the device that we could get into more caching trouble?

An uncached write to this page will not complete until the buffers are
completely flushed.

> Looks reasonable, I'm not sure we can do much better.  The only concern=20
> I have is that allocating some more PCI space like that may end up=20
> clobbering some *other* hidden BIOS mapping, but there's not a whole=20
> lot we can do about that.

This isn't a hidden mapping; the i965 doesn't allocate space for it in
the BIOS.

--=20
keith.packard@intel.com

--=-8xI0ekkhwxh9IEjF1EsV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHJj7KQp8BWwlsTdMRAjBVAKCG9eVDGR2612BjtJNTCvVJlmFGoQCgmpCn
927OcNuGsJYFRS0o/iblMEc=
=U0YV
-----END PGP SIGNATURE-----

--=-8xI0ekkhwxh9IEjF1EsV--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbXJYLZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbXJYLZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbXJYLYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:24:52 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:36231 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbXJYLYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:24:51 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2.6.24-rc1] fix sg_phys to use dma_addr_t
Date: Thu, 25 Oct 2007 13:24:38 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0710241957240.4733@blonde.wat.veritas.com> <200710251100.29739.eike-kernel@sf-tec.de> <20071025090646.GI5053@kernel.dk>
In-Reply-To: <20071025090646.GI5053@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1481609.6DQFjXFsSr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710251324.45776.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1481609.6DQFjXFsSr
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Jens Axboe wrote:
> On Thu, Oct 25 2007, Rolf Eike Beer wrote:
> > Jens Axboe wrote:
> > > On Thu, Oct 25 2007, Rolf Eike Beer wrote:
> > > > Am Donnerstag, 25. Oktober 2007 schrieb Arjan van de Ven:
> > > > > > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > > > > > ---
> > > > > > Whether this is a complete patch, suitable for all architectures,
> > > > > > I'm not sure: it builds, boots and runs correctly on the x86_32
> > > > > > box in question, but you'll be a lot wiser than me about using
> > > > > > dma_addr_t for everyone.  (Seems a bit of a shame to include
> > > > > > <asm/types.h> here, when I think all arches already get to
> > > > > > include it one way or another, typically via asm/scatterlist.h;
> > > > > > but I guess it's safest to repeat it.)
> > > > >
> > > > > there is a problem with this... sg_phys doesn't return an actual
> > > > > *dma* address.... at least not an address you can give to the
> > > > > device. Using dma_addr_t is thus a bit misleading.....
> > > >
> > > > Ok, then: how do I actually get such an address?
> > >
> > > You use the dma mapping api, Documentation/DMA-mapping.txt
> >
> > Which comes back always to the same point: if I get a buffer from
> > userspace to use for DMA: what can I do then? I need to convert a
> > given list of (physical, pinned) pages to DMA addresses.
>
> get_user_pages() -> fill in sg table -> pci/dma_map_sg()

So the answer to the first question should have been sg_dma_address() ;)

Eike

--nextPart1481609.6DQFjXFsSr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHIHz9XKSJPmm5/E4RAmo7AJ9b6YWqxlGPnNYD8RIoo4DepereLQCgoOG9
wRFJhbZZdJrkkO9UPz1lLkY=
=uSoA
-----END PGP SIGNATURE-----

--nextPart1481609.6DQFjXFsSr--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYJRTY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYJRTY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYJRTL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:11:26 -0400
Received: from home.keithp.com ([63.227.221.253]:41919 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbYJRTLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:11:23 -0400
Subject: Re: [git pull] drm patches for 2.6.27-rc1
From: Keith Packard <keithp@keithp.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: keithp@keithp.com, Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
In-Reply-To: <200810181237.49784.nickpiggin@yahoo.com.au>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <200810181237.49784.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kNO+RfBr8iARJrB3rrHj"
Date: Sat, 18 Oct 2008 12:11:02 -0700
Message-Id: <1224357062.4384.72.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kNO+RfBr8iARJrB3rrHj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-18 at 12:37 +1100, Nick Piggin wrote:

> OK. I was hoping that kmap_atomic_pfn thing *never* see the light of
> mainline ;) Because hopefully the vmap improvements should be OK for
> 2.6.28 as well...

Eric and I chatted with Venki Pallipadi this week and decided what we
really need is an official API for getting at pfns in our device BAR,
which is what we're (ab)using kmap_atomic_pfn for. This ties in with
some PAT issues as well, where we want to assert that all mappings of
our BAR are in WC mode. The basic plan is to have four new functions
(yes, I'm making up names here):

struct io_mapping *io_reserve_pci_resource(struct pci_dev *dev,=20
                                           int bar,=20
                                           int prot);
void io_mapping_free(struct io_mapping *mapping);

void *io_map_atomic(struct io_mapping *mapping, unsigned long pfn);
void io_unmap_atomic(struct io_mapping *mapping, unsigned long pfn);

This would have the additional effect of making all other mappings of
this BAR be required to match the specific prot, both providing
protection against broken drivers, and providing support for old X
servers which would directly map this BAR from user space.

> But it's already there. OK, if vmap patches go upstream, then it can
> be switched over and the export removed before the release...

I'd say we should leave things alone for .28 and work on making an
official IO mapping API available.

--=20
keith.packard@intel.com

--=-kNO+RfBr8iARJrB3rrHj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI+jTGQp8BWwlsTdMRAj8YAJ9eJ4J//B7/07ZZv608q8kUS1BBzgCgoC1a
o7SEVx03x1p95WhfI0tBi/8=
=kjl4
-----END PGP SIGNATURE-----

--=-kNO+RfBr8iARJrB3rrHj--


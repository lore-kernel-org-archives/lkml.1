Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbXJaL1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbXJaL1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbXJaL1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:27:20 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:39711 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbXJaL1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:27:17 -0400
X-Greylist: delayed 1826 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2007 07:27:16 EDT
Subject: Re: [PATCH 00/33] Swap over NFS -v14
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
In-Reply-To: <200710311426.33223.nickpiggin@yahoo.com.au>
References: <20071030160401.296770000@chello.nl>
	 <200710311426.33223.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H8xFTlN2az+i59IqNUDQ"
Date: Wed, 31 Oct 2007 12:27:13 +0100
Message-Id: <1193830033.27652.159.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H8xFTlN2az+i59IqNUDQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-31 at 14:26 +1100, Nick Piggin wrote:
> On Wednesday 31 October 2007 03:04, Peter Zijlstra wrote:
> > Hi,
> >
> > Another posting of the full swap over NFS series.
>=20
> Hi,
>=20
> Is it really worth all the added complexity of making swap
> over NFS files work, given that you could use a network block
> device instead?

As it stands, we don't have a usable network block device IMHO.
NFS is by far the most used and usable network storage solution out
there, anybody with half a brain knows how to set it up and use it.

> Also, have you ensured that page_file_index, page_file_mapping
> and page_offset are only ever used on anonymous pages when the
> page is locked? (otherwise PageSwapCache could change)

Good point, I hope so, both ->readpage() and ->writepage() take a locked
page, I'd have to look if it remains locked throughout the NFS call
chain.

Then again, it might become obsolete with the extended swap a_ops.


--=-H8xFTlN2az+i59IqNUDQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHKGaRXA2jU0ANEf4RApFUAJ4+CBvPm0mCVlIMmXKt1KBmtVP/3wCfWg+f
0Bv7xVApLAX9gH4Chrrlb70=
=IEK+
-----END PGP SIGNATURE-----

--=-H8xFTlN2az+i59IqNUDQ--


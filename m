Return-Path: <linux-kernel-owner+w=401wt.eu-S1031091AbXHMNMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031091AbXHMNMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969983AbXHMIgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:36:47 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:46463 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S969975AbXHMIgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:36:44 -0400
Subject: Re: [PATCH 17/23] mm: count writeback pages per BDI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0708091225470.28074@schroedinger.engr.sgi.com>
References: <20070803123712.987126000@chello.nl>
	 <20070803125237.072937000@chello.nl>
	 <Pine.LNX.4.64.0708091214330.27092@schroedinger.engr.sgi.com>
	 <1186687416.11797.182.camel@lappy>
	 <Pine.LNX.4.64.0708091225470.28074@schroedinger.engr.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fONaKnYZIJSZEqCzSeXq"
Date: Mon, 13 Aug 2007 10:36:39 +0200
Message-Id: <1186994199.20108.53.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fONaKnYZIJSZEqCzSeXq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-09 at 12:27 -0700, Christoph Lameter wrote:
> On Thu, 9 Aug 2007, Peter Zijlstra wrote:
>=20
> > Less conditionals. We already have a branch for mapping, why create
> > another?
>=20
> Ah. Okay. This also avoids an interrupt enable disable since you can use=20
> __ functions. Hmmm... Would be good if we could move the vmstat=20
> NR_WRITEBACK update there too. Can a page without a mapping be under=20
> writeback? (Direct I/O?)

DIO still uses the mapping afaik (it needs to invalidate the page before
and after the OP).

But you could put the increment in both paths, and use the irq disable
from the mapping branch - which should be the most frequent case anyway.

--=-fONaKnYZIJSZEqCzSeXq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGwBgXXA2jU0ANEf4RAsxcAJ9Kn809Vlp9vaVlD7HocGpCA2CA7gCfZmu+
GNyVHt1++OkEBR3zQPx/PNg=
=ejba
-----END PGP SIGNATURE-----

--=-fONaKnYZIJSZEqCzSeXq--


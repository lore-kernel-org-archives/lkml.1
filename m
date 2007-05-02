Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXEBG6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXEBG6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1749667AbXEBG6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:58:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43160 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbXEBG6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:58:43 -0400
X-Sasl-enc: uN8kp+Ie0MQiUfuzyZZX5F06pJhOdnV/cNnZ5jzn9Pqj 1178089122
Message-ID: <46383742.9050503@imap.cc>
Date: Wed, 02 May 2007 09:01:22 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative!
 (-1)
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>	<46338AEB.2070109@imap.cc>	<20070428141024.887342bd.akpm@linux-foundation.org>	<4636248E.7030309@imap.cc>	<20070430112130.b64321d3.akpm@linux-foundation.org>	<46364346.6030407@imap.cc> <20070430124638.10611058.akpm@linux-foundation.org>
In-Reply-To: <20070430124638.10611058.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEAD6DD5674EDB7A6243AF5BE"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEAD6DD5674EDB7A6243AF5BE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 30.04.2007 21:46 schrieb Andrew Morton:
> Not really - everything's tangled up.  A bisection search on the
> 2.6.21-rc7-mm2 driver tree would be the best bet.

And the winner is:

gregkh-driver-driver-core-make-uevent-environment-available-in-uevent-fil=
e.patch

Reverting only that from 2.6.21-rc7-mm2 gives me a working kernel
again.

I'll try building 2.6.21-git3 minus that one next, but I'll have
to revert it manually, because my naive attempt to "patch -R" it
failed 1 out of 2 hunks.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- Undetected errors are handled as if no error occurred. (IBM) -


--------------enigEAD6DD5674EDB7A6243AF5BE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGODdLMdB4Whm86/kRAmt/AJ4oeZhZQlRmU8q4c4apkLcszDCPGQCfeAQf
p9mC4P9Z6qzlo/nrZnokt0w=
=zn2T
-----END PGP SIGNATURE-----

--------------enigEAD6DD5674EDB7A6243AF5BE--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760801AbYFWRfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801AbYFWRfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYFWRe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:34:56 -0400
Received: from home.keithp.com ([63.227.221.253]:2858 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbYFWRez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:34:55 -0400
Subject: kmap_atomic_pfn for PCI BAR access?
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: keithp@keithp.com
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dqc9VffN+UZGmmDg0EbF"
Date: Mon, 23 Jun 2008 10:34:47 -0700
Message-Id: <1214242487.11887.35.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dqc9VffN+UZGmmDg0EbF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The graphics memory BAR is generally fairly good sized; on Intel chips,
it's between 256M and 1G (and growing). I want to write data into this
region from kernel space, but it's really too big to map the whole thing
into kernel address space, especially on 32-bit systems. ioremap is not
a good option here -- it's way too slow.

With CONFIG_HIGHMEM enabled, I can use kmap_atomic_pfn (well, actually
the kmap_atomic_proc_pfn included in the DRM tree) and things work quite
well -- performance is good, with barely any measurable time spent in
the PTE whacking (~1%).

However, with CONFIG_HIGHMEM disabled, there aren't any PTEs reserved
for this kind of mapping fun. This makes me suspect that abusing
kmap_atomic for this operation would not be appreciated.=20

Should I use kmap_atomic_pfn to reach my PCI BAR like this?

Would it be reasonable to supply a patch that made this work even
without CONFIG_HIGHMEM?

--=20
keith.packard@intel.com

--=-dqc9VffN+UZGmmDg0EbF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIX962Qp8BWwlsTdMRAlY3AJ9rT8VXRr4ORFNUriuK8irU8VCdygCgguH5
+4AC1/fa4NntWTRvIHXMAFY=
=ZIed
-----END PGP SIGNATURE-----

--=-dqc9VffN+UZGmmDg0EbF--


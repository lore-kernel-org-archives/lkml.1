Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbZBWUEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbZBWUEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbZBWUC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:02:29 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:53416 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448AbZBWUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:02:28 -0500
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not
	ioremap  virtual address for G33 hw status page
From: Eric Anholt <eric@anholt.net>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, rui.zhang@intel.com
In-Reply-To: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-d9UK60VbkgjhGAA9KiqI"
Date: Mon, 23 Feb 2009 12:02:23 -0800
Message-Id: <1235419343.4816.27.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d9UK60VbkgjhGAA9KiqI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 15:46 +0100, Maciej Rutecki wrote:
> 2.6.29-rc5 and 2.6.29-rc5-git6 work OK. In 2.6.29-rc6 XWindow (KDM)
> doesn't start, from dmesg:
>=20
> [   18.170614] [drm] Initialized drm 1.1.0 20060810
> [   18.247445] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
> [   18.247455] pci 0000:00:02.0: setting latency timer to 64
> [   18.249610] mtrr: type mismatch for d0000000,10000000 old:
> write-back new: write-combining
> [   18.249621] [drm] MTRR allocation failed
> [   18.249622] .  Graphics performance may suffer.
> [   18.249658] pci 0000:00:02.0: irq 27 for MSI/MSI-X
> [   18.249691] [drm] Initialized i915 1.6.0 20080730 on minor 0
> [   18.290152] mtrr: type mismatch for d0000000,10000000 old:
> write-back new: write-combining
> [   18.567435] set status page addr 0x00043000
> [   18.567463] [drm:i915_set_status_page] *ERROR* can not ioremap
> virtual address for G33 hw status page

The non-GEM G33 HWS support is wrong, and has been more or less broken
since inception (only now it's failing at startup instead of just being
slow).  It's doing a mapping of the framebuffer when it should be using
a cached mapping of the page backing the framebuffer address.

For a quick fix, converting to ioremap_wc will shut the kernel up and
get us the old ioremap behavior (whatever the MTRR said, which happens
to be WC).

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-d9UK60VbkgjhGAA9KiqI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmjAM8ACgkQHUdvYGzw6vfvHgCgi7waGd9IC6VD671l3LDgZBTM
kHUAoIMnsHVO+NL4orBlCSGQOdvvYBuo
=ral7
-----END PGP SIGNATURE-----

--=-d9UK60VbkgjhGAA9KiqI--


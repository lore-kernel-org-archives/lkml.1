Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbYJSAih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbYJSAih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 20:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYJSAi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 20:38:27 -0400
Received: from home.keithp.com ([63.227.221.253]:34719 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYJSAi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 20:38:26 -0400
Subject: Re: [git pull] drm patches for 2.6.27-rc1
From: Keith Packard <keithp@keithp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: keithp@keithp.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <20081018223214.GA5093@elte.hu>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <200810181237.49784.nickpiggin@yahoo.com.au>
	 <1224357062.4384.72.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UIGKcW/wCt/q3w5mOILv"
Date: Sat, 18 Oct 2008 17:38:11 -0700
Message-Id: <1224376691.4384.105.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UIGKcW/wCt/q3w5mOILv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-19 at 00:32 +0200, Ingo Molnar wrote:

> the _real_ remapping in a graphics aperture happens on the GPU level=20
> anyway, you manage an in-RAM GPU pagetable that just works like an=20
> IOMMU, correct?

Yes, a one-level linear MMU which uses BIOS-reserved memory.

So, at least for a prototype, on 64-bit we can just use ioremap_wc and
hold the mapping while the driver is open? Is there any huge benefit to
using the kernel mapping?

> so on 32-bit we have the INVLPG TLB overhead and preemption restrictions=20
> - but we knew that. We'd have to allow atomic_kmap() on non-highmem as=20
> well but that's fair.

Yes, the non-highmem case is currently in fairly bad shape.

> Mind sending patches for this? :-)

I've got Venki lined up to do this work for me; once we're happy enough
with the API. In particular, the non-highmem 32-bit case seems a bit
tricky.

Also, does anyone have a better set of names for this stuff?
io_reserve_pci_mapping seems fairly ugly to me.

--=20
keith.packard@intel.com

--=-UIGKcW/wCt/q3w5mOILv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI+oFyQp8BWwlsTdMRApa3AJ46WGzyhjDG2Df5RtJYx1/+UZmQhACgwxZB
L907dvlCI7Djkaq/LQdLWMc=
=hzzz
-----END PGP SIGNATURE-----

--=-UIGKcW/wCt/q3w5mOILv--


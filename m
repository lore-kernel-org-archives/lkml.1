Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYJXBui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYJXBui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 21:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbYJXBu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 21:50:28 -0400
Received: from home.keithp.com ([63.227.221.253]:37853 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYJXBu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 21:50:27 -0400
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
	2.6.27-rc1)
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: keithp@keithp.com, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, nickpiggin@yahoo.com.au, airlied@linux.ie,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net, yinghai@kernel.org
In-Reply-To: <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu>
	 <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu>
	 <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu>
	 <1224793332.22877.8.camel@koto.keithp.com>
	 <20081023133840.d4eef579.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pjXSeYZvwnoftciUs3va"
Date: Thu, 23 Oct 2008 18:50:15 -0700
Message-Id: <1224813015.22877.51.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pjXSeYZvwnoftciUs3va
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 14:24 -0700, Linus Torvalds wrote:

> The whole point of that function has absolutely nothing to do with=20
> highmem, and it *must* be useful on non-highmem configurations to be=20
> appropriate.

Right, I'd just like my io_mapping_map_atomic_wc to be able to rapidly
map random pages from my PCI BAR in WC mode. The code in your tree uses
kmap_atomic_pfn, which does the mapping, but use the wrong prot bits. On
a system with MTRR failure, this all ends badly, with factors of 20
performance drops for copying data from the CPU to the aperture.

> So I'd much rather create a new <linux/kmap.h> or something. Or just=20
> expose this from to <asm/fixmap.h> or something. Let's not confuse this=20
> with highmem, even if the implementation _historically_ was due to that.

Sure, we readily admit that we're abusing the highmem API. So we wrapped
that abusive code in a pretty package that can be re-implemented however
you desire.

How (and when) would you like to see this fixed?

--=20
keith.packard@intel.com

--=-pjXSeYZvwnoftciUs3va
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJASnXQp8BWwlsTdMRAvtdAJ9nJDeHn1YBQpvLMZx/gv7fiePqGgCff/Gv
3Ter51utv12XvOzhGu9P6Bc=
=zrmT
-----END PGP SIGNATURE-----

--=-pjXSeYZvwnoftciUs3va--


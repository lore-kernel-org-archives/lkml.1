Return-Path: <linux-kernel-owner+w=401wt.eu-S1751646AbYJSEPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbYJSEPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 00:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbYJSEPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 00:15:13 -0400
Received: from home.keithp.com ([63.227.221.253]:42474 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbYJSEPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 00:15:12 -0400
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fBsZZxT1bGAzCU/0sYh0"
Date: Sat, 18 Oct 2008 21:14:57 -0700
Message-Id: <1224389697.4384.118.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fBsZZxT1bGAzCU/0sYh0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-19 at 00:32 +0200, Ingo Molnar wrote:

> Mind sending patches for this? :-)

Here's what these functions would look like as wrappers on top of the
existing APIs:

/* x86_64 style */
static inline struct io_reserve *
iomap_reserve(unsigned long base, unsigned long size)
{
        return (struct io_reserve *) ioremap_wc(base, size);
}

static inline void *
iomap_atomic(struct io_reserve *reserve, unsigned long offset)
{
        return ((char *) reserve) + offset;
}

static inline void
iounmap_atomic(void *vaddr)
{
}

static inline void
iomap_unreserve(struct io_reserve *reserve)
{
        iounmap(reserve);
}

/* HIGHMEM style */
#if 0
static inline struct io_reserve *
iomap_reserve(unsigned long base, unsigned long size)
{
        return (struct io_reserve *) base;
}

static inline void *
iomap_atomic(struct io_reserve *reserve, unsigned long offset)
{
        offset +=3D (unsigned long) reserve;
        return kmap_atomic(offset >> PAGE_SHIFT, KM_USER0);
}

static inline void
iounmap_atomic(void *vaddr)
{
        kunmap_atomic(vaddr, KM_USER0);
}

static inline void
iomap_unreserve(struct io_reserve *reserve)
{
}
#endif

/* 32-bit non-HIGHMEM style */
#if 0
static inline struct io_reserve *
iomap_reserve(unsigned long base, unsigned long size)
{
        return NULL;
}

static inline void *
iomap_atomic(struct io_reserve *reserve, unsigned long offset)
{
        return NULL;
}

static inline void
iounmap_atomic(void *vaddr)
{
}

static inline void
iomap_unreserve(struct io_reserve *reserve)
{
}
#endif

>=20
> 	Ingo
--=20
keith.packard@intel.com

--=-fBsZZxT1bGAzCU/0sYh0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI+rRBQp8BWwlsTdMRAodCAJ9WujG3y8Vbslc1d8owMEkmdpcj4gCgqI2k
OHfWJ0Ske1dMJEfo08TedqU=
=VaO+
-----END PGP SIGNATURE-----

--=-fBsZZxT1bGAzCU/0sYh0--


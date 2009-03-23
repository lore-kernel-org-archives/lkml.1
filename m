Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZCWKPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZCWKPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZCWKO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:14:57 -0400
Received: from systemlinux.org ([83.151.29.59]:43409 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbZCWKO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:14:56 -0400
Date: Mon, 23 Mar 2009 11:11:21 +0100
From: Andre Noll <maan@systemlinux.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
       maciej.sosnowski@intel.com, Ilya Yanok <yanok@emcraft.com>,
       Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH 07/13] async_tx: add support for asynchronous RAID6 recovery operations
Message-ID: <20090323101121.GO17185@skl-net.de>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com> <20090318192052.20375.68157.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3NPeJodHuZECfqv"
Content-Disposition: inline
In-Reply-To: <20090318192052.20375.68157.stgit@dwillia2-linux.ch.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3NPeJodHuZECfqv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:20, Dan Williams wrote:
> +struct dma_async_tx_descriptor *
> +async_r6_dd_recov(int disks, size_t bytes, int faila, int failb,
> +		  struct page **ptrs, enum async_tx_flags flags,
> +		  struct dma_async_tx_descriptor *depend_tx,
> +		  dma_async_tx_callback cb, void *cb_param)
> +{
> +	struct dma_async_tx_descriptor *tx =3D NULL;
> +	struct page *lptrs[disks];
> +	unsigned char lcoef[disks-4];

This probably needs a BUG_ON(disks < 4).

> +	 * B =3D (2^(y-x))*((2^(y-x) + {01})^(-1))

Minor optimization suggestion: As B depends only on y-x, there are
255 possible values for B, so a lookup table for all these values
would only occupy 255 bytes.

> +ddr_sync:
> +	{
> +		void **sptrs =3D (void **)lptrs;

unnecessary cast

> +struct dma_async_tx_descriptor *
> +async_r6_dp_recov(int disks, size_t bytes, int faila, struct page **ptrs,
> +		  enum async_tx_flags flags,
> +		  struct dma_async_tx_descriptor *depend_tx,
> +		  dma_async_tx_callback cb, void *cb_param)
> +{
> +	struct dma_async_tx_descriptor *tx =3D NULL;

unnecessary initialization.

> +	struct page *lptrs[disks];
> +	unsigned char lcoef[disks-2];
> +	int i =3D 0, k =3D 0;

again. I'd suggest to init i and k in the for() loop.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--u3NPeJodHuZECfqv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJx2BJWto1QDEAkw8RAgW1AJ9SkTvDbhj8HoAidqQiFHKRbFOv7ACeMcr+
C9C/nRCfl2E8vQEm2v4Ebps=
=TmX4
-----END PGP SIGNATURE-----

--u3NPeJodHuZECfqv--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZLECKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZLECKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 21:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZLECKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 21:10:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39718 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbZLECKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 21:10:12 -0500
Date: Sat, 5 Dec 2009 13:10:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Emese Revfy <re.emese@gmail.com>
Cc: tony.luck@intel.com, geoffrey.levand@am.sony.com, davem@davemloft.net,
       tglx@linutronix.de, joerg.roedel@amd.com, muli@il.ibm.com,
       jdmason@kudzu.us, jbarnes@virtuousgeek.org, dwmw2@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/31] Constify struct dma_map_ops for 2.6.32 v1
Message-Id: <20091205131011.e90d7f1c.sfr@canb.auug.org.au>
In-Reply-To: <4B19BEB9.3000600@gmail.com>
References: <4B198670.2000406@gmail.com>
	<4B1989B0.102@gmail.com>
	<20091205115936.d3a7a6ec.sfr@canb.auug.org.au>
	<20091205122015.c898e234.sfr@canb.auug.org.au>
	<4B19BEB9.3000600@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__5_Dec_2009_13_10_11_+1100_BXLc1G4kGWICCRrI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_Dec_2009_13_10_11_+1100_BXLc1G4kGWICCRrI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Emese,

On Sat, 05 Dec 2009 03:00:25 +0100 Emese Revfy <re.emese@gmail.com> wrote:
>
> Ok, I made the changes, I also removed the vio_cmo_set_dma_ops function
> because I think it is now unnecessary.

It is necessary because vio_dma_mapping_ops is only defined when
CONFIG_PPC_SMLPAR is set, but that function was called from unconditional
code (and there was a trivial version for when CONFIG_PPC_SMLPAR was not
set) i.e. we only want the dma_ops set if we were built with
CONFIG_PPC_SMLPAR.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_Dec_2009_13_10_11_+1100_BXLc1G4kGWICCRrI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksZwQMACgkQjjKRsyhoI8wvvgCgl9W6DVxz4ZyhrwynRDggxHgL
Yq0AoJgo55m+Kzs8LRWJpdz8dUt95T1o
=TPSx
-----END PGP SIGNATURE-----

--Signature=_Sat__5_Dec_2009_13_10_11_+1100_BXLc1G4kGWICCRrI--

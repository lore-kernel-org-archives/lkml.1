Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbZLEA7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbZLEA7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbZLEA7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:59:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60216 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576AbZLEA7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:59:38 -0500
Date: Sat, 5 Dec 2009 11:59:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Emese Revfy <re.emese@gmail.com>
Cc: tony.luck@intel.com, geoffrey.levand@am.sony.com, davem@davemloft.net,
       tglx@linutronix.de, joerg.roedel@amd.com, muli@il.ibm.com,
       jdmason@kudzu.us, jbarnes@virtuousgeek.org, dwmw2@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/31] Constify struct dma_map_ops for 2.6.32 v1
Message-Id: <20091205115936.d3a7a6ec.sfr@canb.auug.org.au>
In-Reply-To: <4B1989B0.102@gmail.com>
References: <4B198670.2000406@gmail.com>
	<4B1989B0.102@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__5_Dec_2009_11_59_36_+1100_V81nt.fJGEq6siLP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_Dec_2009_11_59_36_+1100_V81nt.fJGEq6siLP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Emese,

On Fri, 04 Dec 2009 23:14:08 +0100 Emese Revfy <re.emese@gmail.com> wrote:
>
> --- a/arch/powerpc/kernel/vio.c
> +++ b/arch/powerpc/kernel/vio.c
> @@ -601,6 +601,7 @@ static void vio_dma_iommu_unmap_sg(struct device *dev,
>  	vio_cmo_dealloc(viodev, alloc_size);
>  }
> =20
> +/* cannot be const */
>  struct dma_map_ops vio_dma_mapping_ops =3D {

The problem with leaving this not const is that a pointer to it is later
assigned to an archdata::dma_ops which you have made into a const pointer
earlier in this patch.  This will generate a warning which is fatal in
arch/powerpc as we compile that directory with -Werror.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_Dec_2009_11_59_36_+1100_V81nt.fJGEq6siLP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksZsHgACgkQjjKRsyhoI8x5vgCeMjEvcvaya+z2X2KnBSNylwrD
QSMAnRh9RfeaCfA9rnL6zlG5tvc6oy9o
=h/Xj
-----END PGP SIGNATURE-----

--Signature=_Sat__5_Dec_2009_11_59_36_+1100_V81nt.fJGEq6siLP--

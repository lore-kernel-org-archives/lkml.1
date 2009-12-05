Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbZLEBUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbZLEBUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 20:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932654AbZLEBUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 20:20:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53701 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597AbZLEBUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 20:20:17 -0500
Date: Sat, 5 Dec 2009 12:20:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Emese Revfy <re.emese@gmail.com>
Cc: tony.luck@intel.com, geoffrey.levand@am.sony.com, davem@davemloft.net,
       tglx@linutronix.de, joerg.roedel@amd.com, muli@il.ibm.com,
       jdmason@kudzu.us, jbarnes@virtuousgeek.org, dwmw2@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/31] Constify struct dma_map_ops for 2.6.32 v1
Message-Id: <20091205122015.c898e234.sfr@canb.auug.org.au>
In-Reply-To: <20091205115936.d3a7a6ec.sfr@canb.auug.org.au>
References: <4B198670.2000406@gmail.com>
	<4B1989B0.102@gmail.com>
	<20091205115936.d3a7a6ec.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__5_Dec_2009_12_20_15_+1100_xxDhFmDLvfLKtuRa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_Dec_2009_12_20_15_+1100_xxDhFmDLvfLKtuRa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Emese,

On Sat, 5 Dec 2009 11:59:36 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Fri, 04 Dec 2009 23:14:08 +0100 Emese Revfy <re.emese@gmail.com> wrote:
> >
> > --- a/arch/powerpc/kernel/vio.c
> > +++ b/arch/powerpc/kernel/vio.c
> > @@ -601,6 +601,7 @@ static void vio_dma_iommu_unmap_sg(struct device *d=
ev,
> >  	vio_cmo_dealloc(viodev, alloc_size);
> >  }
> > =20
> > +/* cannot be const */
> >  struct dma_map_ops vio_dma_mapping_ops =3D {
>=20
> The problem with leaving this not const is that a pointer to it is later
> assigned to an archdata::dma_ops which you have made into a const pointer
> earlier in this patch.  This will generate a warning which is fatal in
> arch/powerpc as we compile that directory with -Werror.

Actually with a little more work, it can be made const.  The only
assignment to it can be put in the initialiser instead ... As an aside,
it should also be made static.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_Dec_2009_12_20_15_+1100_xxDhFmDLvfLKtuRa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksZtU8ACgkQjjKRsyhoI8wtfQCfbB8OsRB5RUhZxBfECRNJ4ktk
8kwAn1ft27gvfMGzBpQMLB1fP/oP9Z5K
=Hc5j
-----END PGP SIGNATURE-----

--Signature=_Sat__5_Dec_2009_12_20_15_+1100_xxDhFmDLvfLKtuRa--

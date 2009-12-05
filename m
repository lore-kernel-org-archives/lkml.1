Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZLEC11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZLEC11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 21:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZLEC1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 21:27:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45552 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbZLEC1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 21:27:24 -0500
Date: Sat, 5 Dec 2009 13:27:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Emese Revfy <re.emese@gmail.com>
Cc: tony.luck@intel.com, geoffrey.levand@am.sony.com, davem@davemloft.net,
       tglx@linutronix.de, joerg.roedel@amd.com, muli@il.ibm.com,
       jdmason@kudzu.us, jbarnes@virtuousgeek.org, dwmw2@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/31] Constify struct dma_map_ops for 2.6.32 v1
Message-Id: <20091205132724.154a07b6.sfr@canb.auug.org.au>
In-Reply-To: <4B19C493.4030506@gmail.com>
References: <4B198670.2000406@gmail.com>
	<4B1989B0.102@gmail.com>
	<20091205115936.d3a7a6ec.sfr@canb.auug.org.au>
	<20091205122015.c898e234.sfr@canb.auug.org.au>
	<4B19BEB9.3000600@gmail.com>
	<20091205131011.e90d7f1c.sfr@canb.auug.org.au>
	<4B19C493.4030506@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__5_Dec_2009_13_27_24_+1100_MigQqdiaIhjqUj.2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_Dec_2009_13_27_24_+1100_MigQqdiaIhjqUj.2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Emese,

On Sat, 05 Dec 2009 03:25:23 +0100 Emese Revfy <re.emese@gmail.com> wrote:
>
> I already took care of these, look at these hunks:
>=20
> @@ -1033,7 +1026,6 @@ int vio_cmo_entitlement_update(size_t new_entitleme=
nt) { return 0; }
>  void vio_cmo_set_dev_desired(struct vio_dev *viodev, size_t desired) {}
>  static int vio_cmo_bus_probe(struct vio_dev *viodev) { return 0; }
>  static void vio_cmo_bus_remove(struct vio_dev *viodev) {}
> -static void vio_cmo_set_dma_ops(struct vio_dev *viodev) {}
>  static void vio_cmo_bus_init(void) {}
>  static void vio_cmo_sysfs_init(void) { }
>  #endif /* CONFIG_PPC_SMLPAR */
> @@ -1233,7 +1225,7 @@ struct vio_dev *vio_register_device_node(struct dev=
ice_node *of_node)
>  	viodev->dev.archdata.of_node =3D of_node_get(of_node);
> =20
>  	if (firmware_has_feature(FW_FEATURE_CMO))
> -		vio_cmo_set_dma_ops(viodev);
> +		viodev->dev.archdata.dma_ops =3D &vio_dma_mapping_ops;

This code is not inside a #ifdef CONFIG_PPC_SMLPAR section, so
vio_dma_mapping_ops may not exist here.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_Dec_2009_13_27_24_+1100_MigQqdiaIhjqUj.2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksZxQwACgkQjjKRsyhoI8w5pgCgwJllI6yvv2GcyEeAZq26a2VJ
sTUAmQFy74ieJ9PJvIiNJpxWL0z1KUTH
=zjfp
-----END PGP SIGNATURE-----

--Signature=_Sat__5_Dec_2009_13_27_24_+1100_MigQqdiaIhjqUj.2--

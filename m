Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbYBEFoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbYBEFoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 00:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYBEFog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 00:44:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36278 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYBEFog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 00:44:36 -0500
Date: Tue, 5 Feb 2008 16:44:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Wei <wei.zhang@freescale.com>
Cc: mporter@kernel.crashing.org, galak@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] Add OF-tree support to RapidIO controller driver.
Message-Id: <20080205164425.b6af5bff.sfr@canb.auug.org.au>
In-Reply-To: <12016890832943-git-send-email-wei.zhang@freescale.com>
References: <1201689053956-git-send-email-wei.zhang@freescale.com>
	<12016890621727-git-send-email-wei.zhang@freescale.com>
	<120168907160-git-send-email-wei.zhang@freescale.com>
	<12016890773706-git-send-email-wei.zhang@freescale.com>
	<12016890832943-git-send-email-wei.zhang@freescale.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Feb_2008_16_44_25_+1100_.Pf1PbQrSHYAocGX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Feb_2008_16_44_25_+1100_.Pf1PbQrSHYAocGX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jan 2008 18:30:52 +0800 Zhang Wei <wei.zhang@freescale.com> wrot=
e:
>
> -void fsl_rio_setup(int law_start, int law_size)
> +int fsl_rio_setup(struct of_device *dev)
>  {

> +	if (!dev->node) {
> +		dev_err(&dev->dev, "Device OF-Node is NULL");
> +		return -EFAULT;

Probably -EINVAL would be better. Here and all the other -EFAULTs.

> +	aw =3D *(u32 *)of_get_property(dev->node, "#address-cells", NULL);
> +	sw =3D *(u32 *)of_get_property(dev->node, "#size-cells", NULL);

What happens if either of these properties is missing?

> +static struct of_device_id fsl_of_rio_rpn_ids[] =3D {

This should be "const" please.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Feb_2008_16_44_25_+1100_.Pf1PbQrSHYAocGX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHp/e9TgG2atn1QN8RAsGnAJ923qdL8k64IVemccSj7DcWuJhsYQCfbUTH
lBGJWZSD7L0H3IIzkdc28bo=
=O7Oi
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Feb_2008_16_44_25_+1100_.Pf1PbQrSHYAocGX--

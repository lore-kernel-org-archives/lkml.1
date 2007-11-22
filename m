Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXKVXRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXKVXRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 18:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbXKVXQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 18:16:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45985 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbXKVXQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 18:16:57 -0500
Date: Fri, 23 Nov 2007 10:16:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: PPCML <linuxppc-dev@ozlabs.org>, Olof Johansson <olof@lixom.net>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PPC: CHRP - fix possible NULL pointer dereference
Message-Id: <20071123101646.63550945.sfr@canb.auug.org.au>
In-Reply-To: <20071122195423.GA9877@cvg>
References: <20071122195423.GA9877@cvg>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_Nov_2007_10_16_46_+1100_X7su_ztJU5EfC4Dm"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Nov_2007_10_16_46_+1100_X7su_ztJU5EfC4Dm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Nov 2007 22:54:23 +0300 Cyrill Gorcunov <gorcunov@gmail.com> wro=
te:
>
> This patch does fix possible NULL pointer dereference
> inside of strncmp() if of_get_property() failed.

Thanks for this.

>  static void __init sio_init(void)
>  {
>  	struct device_node *root;
> +	const char *model =3D NULL;

You don't need this initialization as you always assign the variable
before you use it.

> +	root =3D of_find_node_by_path("/");
> +	if (root) {

	if (!root)
		return;

would save a level of indentation. Not important.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_Nov_2007_10_16_46_+1100_X7su_ztJU5EfC4Dm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHRg3jTgG2atn1QN8RAgS+AJ0TSnJ7K3W4eF1xYySKWQoMYZ5enwCgiyDn
eJi7c8GJEdu634081uFuVvU=
=E8Lx
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Nov_2007_10_16_46_+1100_X7su_ztJU5EfC4Dm--

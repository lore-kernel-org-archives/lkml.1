Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbXL2EDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbXL2EDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 23:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbXL2EDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 23:03:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54178 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbXL2EDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 23:03:30 -0500
Date: Sat, 29 Dec 2007 15:03:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jochen Friedrich <jochen@scram.de>
Cc: wim@iguana.be, Scott Wood <scottwood@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] Add support for PowerQUICC watchdog
Message-Id: <20071229150319.1045b2a3.sfr@canb.auug.org.au>
In-Reply-To: <47751287.6000801@scram.de>
References: <47751287.6000801@scram.de>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__29_Dec_2007_15_03_19_+1100_HhGJOTqV8F4flA2y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__29_Dec_2007_15_03_19_+1100_HhGJOTqV8F4flA2y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jochen,

Just a couple of suggestions.

On Fri, 28 Dec 2007 16:13:11 +0100 Jochen Friedrich <jochen@scram.de> wrote:
>
> +int __init pq_wdt_early_init(void)
> +{
>
> +	data =3D of_get_property(soc, "bus-frequency", NULL);
> +	if (!data) {
> +		of_node_put(soc);
> +		printk(KERN_ERR "Could not find bus-frequency in soc node\n");
> +		ret =3D -ENODEV;
> +		goto out;
> +	}
> +	of_node_put(soc);

If you move the "of_node_put(soc)" just above the "if (!data)" then you
won't need to repeat it.

> +static struct of_platform_driver pq_wdt_driver =3D {
> +	.owner		=3D THIS_MODULE,
> +	.name		=3D "pq-wdt",
> +	.match_table	=3D pq_wdt_match,
> +	.probe		=3D pq_wdt_probe,
> +	.remove		=3D pq_wdt_remove,
> +};

We are removing the owner and name fields from struct of_platform_driver, s=
o the preferred initialization looks like this:

static struct of_platform_driver pq_wdt_driver =3D {
	.match_table	=3D pq_wdt_match,
	.probe		=3D pq_wdt_probe,
	.remove		=3D pq_wdt_remove,
	.driver		=3D {
		.name	=3D "pq-wdt",
		.owner	=3D THIS_MODULE,
	}
};

or similar.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__29_Dec_2007_15_03_19_+1100_HhGJOTqV8F4flA2y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHdccNTgG2atn1QN8RAnmjAJ9nwNbZ6t1Qdau5o6Rm+uGjwisdfgCfWWnV
eSzxT51yMkDyHIS8HCPsr84=
=YWjB
-----END PGP SIGNATURE-----

--Signature=_Sat__29_Dec_2007_15_03_19_+1100_HhGJOTqV8F4flA2y--

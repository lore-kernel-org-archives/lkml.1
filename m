Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZLAPSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZLAPSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZLAPSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:18:18 -0500
Received: from romulus.commandcorp.com ([130.205.32.3]:59789 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZLAPSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:18:17 -0500
X-Greylist: delayed 1063 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2009 10:18:17 EST
Authentication-Results: romulus.wittsend.com; dkim=none (no signature)
	header.i=unknown; x-dkim-adsp=fail
Subject: Re: [PATCH] ip2: Remove #ifdef MODULE from ip2main.c
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mhw@WittsEnd.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b9df5fa10912010102p405b429dg102843fe88932b9d@mail.gmail.com>
References: <b9df5fa10912010102p405b429dg102843fe88932b9d@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-G/Lz55VRdklc7xGNNoBU"
Organization: Thaumaturgy & Speculums Technology
Date: Tue, 01 Dec 2009 10:00:14 -0500
Message-Id: <1259679614.8141.396.camel@canyon.wittsend.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.1.1 (romulus.wittsend.com [IPv6:2001:4830:3000:2:280:3fff:fe03:455b]); Tue, 01 Dec 2009 10:00:17 -0500 (EST)
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: nB1F0F9x032185
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1260284417.49749@quii8VNok6cjvCDA0CrCdQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-G/Lz55VRdklc7xGNNoBU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[Crud...  NOW I find out that I've been dumped from all the Vger mailing
lists...  Again...  Sigh...]

Looks good to me.

Regards,
Mike

Signed-off-by: Michael H. Warfield <mhw@WittsEnd.com>

On Tue, 2009-12-01 at 15:02 +0600, Rakib Mullick wrote:=20
> ip2: Remove #ifdef MODULE completely.
>=20
> From kernel command line we can pass "module parameters".
> So #ifdef MODULE is obsolute now. Remove it completely.
> When CONFIG_PCI=3Dn and building ip2main.c then we are hit
> by the following warning. So move *pdev into #ifdef CONFIG_PCI.
>=20
> drivers/char/ip2/ip2main.c: In function `ip2_loadmain':
> drivers/char/ip2/ip2main.c:542: warning: unused variable `pdev'
>=20
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
>=20
> --- linus/drivers/char/ip2/ip2main.c	2009-12-01 12:41:53.000000000 +0600
> +++ rakib/drivers/char/ip2/ip2main.c	2009-12-01 12:56:56.000000000 +0600
> @@ -263,7 +263,7 @@ static int tracewrap;
>  /* Macros */
>  /**********/
>=20
> -#if defined(MODULE) && defined(IP2DEBUG_OPEN)
> +#ifdef IP2DEBUG_OPEN
>  #define DBG_CNT(s) printk(KERN_DEBUG "(%s): [%x] ttyc=3D%d, modc=3D%x ->=
 %s\n", \
>  		    tty->name,(pCh->flags), \
>  		    tty->count,/*GET_USE_COUNT(module)*/0,s)
> @@ -487,7 +487,6 @@ static const struct firmware *ip2_reques
>  	return fw;
>  }
>=20
> -#ifndef MODULE
>  /***********************************************************************=
*******
>   *	ip2_setup:
>   *		str: kernel command line string
> @@ -531,7 +530,6 @@ static int __init ip2_setup(char *str)
>  	return 1;
>  }
>  __setup("ip2=3D", ip2_setup);
> -#endif /* !MODULE */
>=20
>  static int __init ip2_loadmain(void)
>  {
> @@ -539,7 +537,6 @@ static int __init ip2_loadmain(void)
>  	int err =3D 0;
>  	i2eBordStrPtr pB =3D NULL;
>  	int rc =3D -1;
> -	struct pci_dev *pdev =3D NULL;
>  	const struct firmware *fw =3D NULL;
>=20
>  	if (poll_only) {
> @@ -612,6 +609,7 @@ static int __init ip2_loadmain(void)
>  		case PCI:
>  #ifdef CONFIG_PCI
>  		{
> +			struct pci_dev *pdev =3D NULL;
>  			u32 addr;
>  			int status;

--=20
Michael H. Warfield (AI4NB) | (770) 985-6132 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!

--=-G/Lz55VRdklc7xGNNoBU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUASxUvfcDrlnVnRif/AQIeYwf7BPmMHfbqfq4OrUmPPgJyYoVk5kVtVKFG
0WLV0lnhnYoAUTEE7f5fwuPnfr84nKXkeu8JL6ZNjm8c9l+4ruYPwD8TI7QBJgfo
vD402Kv195OLJrf6H3zpGuh4XrGb+tqfZ8P/x+T1yKltNC85hPFVHRBQyJKRz9wY
U5xdaF+Khk4fabn9wl5177mGpIj7yFK0TKgPInM+4l/EKmpu3L5c21fO+yM+1IkU
DM6yeiTGBJs+ulWaZtamywvLAl0UlT8WH6iZmy82+C9a1SX5Hz6nGp8uUSYFz0M7
M0hTUQB3H32GQO59mnTYgxL68jtjG1IN58X/rBONYSQyz2qVLYf7lw==
=7JZc
-----END PGP SIGNATURE-----

--=-G/Lz55VRdklc7xGNNoBU--


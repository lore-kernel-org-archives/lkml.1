Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZBBKDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZBBKDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 05:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZBBKD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 05:03:27 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:24595 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbZBBKD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 05:03:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai0FADtShknCTsYx/2dsb2JhbACBbsYuhBQG
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: wenji.huang@oracle.com
Subject: Re: [PATCH] Fix the warning of uninitialized value in driver/serial/8250.c
Date: Mon, 2 Feb 2009 11:03:16 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-serial@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <4986B86E.3030604@oracle.com>
In-Reply-To: <4986B86E.3030604@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2771663.RnMNcygN0y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902021103.21887.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2771663.RnMNcygN0y
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 02 February 2009 10:10:06 Wenji Huang wrote:
> This patch is to remove the the warning of uninitialized i in
> driver/serial/8250.c
>
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
>
> diff -Nurh drivers/serial/8250.c.Orig drivers/serial/8250.c
> --- drivers/serial/8250.c.Orig  2009-02-02 14:02:47.000000000 -0500
> +++ drivers/serial/8250.c       2009-02-02 14:03:30.000000000 -0500
> @@ -1678,7 +1678,7 @@
>
>   static void serial_unlink_irq_chain(struct uart_8250_port *up)
>   {
> -       struct irq_info *i;
> +       struct irq_info *i =3D NULL;
>          struct hlist_node *n;
>          struct hlist_head *h;

gcc is wrong, i can't be used uninitialized in that function. You should us=
e=20
the following construct instead to suppress the warning without generating =
any=20
code.

	struct irq_info *uninitialized_var(i);

Best regards,

=2D-=20
Laurent Pinchart
CSE Semaphore Belgium

Chaussee de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
=46 +32 (2) 387 42 75

--nextPart2771663.RnMNcygN0y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmGxOQACgkQlyYWY4YEWhX+NwCfWyt/YHsocft+QRGDVwbgnmZZ
YsoAnjLywxfbHMmt8wUEbsbQQHVxvK0C
=Oiqq
-----END PGP SIGNATURE-----

--nextPart2771663.RnMNcygN0y--

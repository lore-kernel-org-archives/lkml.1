Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbXJGDmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbXJGDmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 23:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbXJGDmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 23:42:13 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41837 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbXJGDmN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 23:42:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Time-based RFC 4122 UUID generator
In-Reply-To: Your message of "Sat, 06 Oct 2007 15:53:37 +0200."
             <200710061553.37311.deller@gmx.de>
From: Valdis.Kletnieks@vt.edu
References: <200710061553.37311.deller@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191728530_10413P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 06 Oct 2007 23:42:10 -0400
Message-ID: <20668.1191728530@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191728530_10413P
Content-Type: text/plain; charset=us-ascii

On Sat, 06 Oct 2007 15:53:37 +0200, Helge Deller said:

> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index af274e5..c84a385 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -239,6 +239,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/percpu.h>
>  #include <linux/cryptohash.h>
> +#include <linux/netdevice.h>
>  
>  #include <asm/processor.h>
>  #include <asm/uaccess.h>
> @@ -1157,6 +1158,8 @@ void generate_random_uuid(unsigned char uuid_out[16])
>  	uuid_out[6] = (uuid_out[6] & 0x0F) | 0x40;
>  	/* Set the UUID variant to DCE */
>  	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
> +	/* Set multicast bit to avoid conflicts with NIC MAC addresses */
> +	uuid_out[10] |= 0x80;
>  }


Erm, was it *intended* that you also changed the behavior of generate_random_uuid()?


--==_Exmh_1191728530_10413P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHCFWScC3lWbTT17ARAgyMAJ0YpslRGTb4IlgsYsBd03jhsvkH1wCfUMSD
voJmum2Lebc/6PjeU2S618s=
=5yQK
-----END PGP SIGNATURE-----

--==_Exmh_1191728530_10413P--

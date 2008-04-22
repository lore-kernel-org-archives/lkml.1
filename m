Return-Path: <linux-kernel-owner+w=401wt.eu-S1762248AbYDVCF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762248AbYDVCF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 22:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYDVCFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 22:05:17 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56874 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYDVCFQ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 22:05:16 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Reuben Farrelly <reuben-linuxkernel@reub.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: StackProtector Oopses - Re: 2.6.25-mm1
In-Reply-To: Your message of "Mon, 21 Apr 2008 18:48:59 PDT."
             <20080421184859.48efcb67@laptopd505.fenrus.org>
From: Valdis.Kletnieks@vt.edu
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <48089BDE.6040100@reub.net> <20080418133645.GF31797@elte.hu> <4808B4EF.8030901@reub.net> <20080421150604.GH5474@elte.hu>
            <20080421184859.48efcb67@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1208829867_3478P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 21 Apr 2008 22:04:27 -0400
Message-ID: <1022.1208829867@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1208829867_3478P
Content-Type: text/plain; charset=us-ascii

On Mon, 21 Apr 2008 18:48:59 PDT, Arjan van de Ven said:

Typo alert?

> diff --git a/kernel/panic.c b/kernel/panic.c
> index c92c1e2..b4a6a05 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -351,7 +351,10 @@ static noinline void __stack_chk_test_func(void)
>  	}
>  #endif
>  	barrier();
> -	memset(&foo, 0, 2*sizeof(foo)); /* deliberate buffer overflow */
> +	if (current->stack_canary == *(((unsigned long *)&foo)+1))
> +		*(((unsigned long *)&foo)+1) = 0;
> +	else
> +		printk(KERN_ERR "No -ftack-protector canary found\n");
                                     -fstack?
>  	barrier();
>  }


--==_Exmh_1208829867_3478P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIDUercC3lWbTT17ARAgi4AKDUKVH8M4GZvTJ5MX7PSc4a5YAXYgCg9B09
lnWvgwYOImhTAd/gERmpWEo=
=I4g3
-----END PGP SIGNATURE-----

--==_Exmh_1208829867_3478P--

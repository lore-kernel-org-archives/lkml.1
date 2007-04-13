Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbXDMIas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbXDMIas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXDMIas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:30:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33142 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbXDMIar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:30:47 -0400
Date: Fri, 13 Apr 2007 18:30:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
Message-Id: <20070413183054.08ca0dff.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0704130416250.15118@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6>
	<20070413180942.b7cf0665.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0704130416250.15118@CPE00045a9c397f-CM001225dbafb6>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__13_Apr_2007_18_30_54_+1000_FLVncb7Vsc9P.ME5"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Apr_2007_18_30_54_+1000_FLVncb7Vsc9P.ME5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Fri, 13 Apr 2007 04:20:10 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> On Fri, 13 Apr 2007, Stephen Rothwell wrote:
> >
> > One thing that comes to mind is that you will need some way to make sure
> > that only one of ACPI and APM get initialized ...
>
> i don't see how that has anything to do with removing legacy PM
> support.  you can select both ACPI and APM *now*.  if that's a bad
> thing, then fixing it is a completely independent issue.

Except your patch removes this hunk:

@@ -2264,14 +2248,6 @@ static int __init apm_init(void)
 		apm_info.disabled = 1;
 		return -ENODEV;
 	}
-	if (PM_IS_ACTIVE()) {
-		printk(KERN_NOTICE "apm: overridden by ACPI.\n");
-		apm_info.disabled = 1;
-		return -ENODEV;
-	}
-#ifdef CONFIG_PM_LEGACY
-	pm_active = 1;
-#endif

in apm.c and a similar piece of the ACPI initialisation that prevented
one initialising if the other had already initialised.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__13_Apr_2007_18_30_54_+1000_FLVncb7Vsc9P.ME5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQFGHz/CFdBgD/zoJvwRAmCdAJi7+gs/dmaV0B4Albj637rWKK72AJ4zROwh
D8BCJ4GybVEbnZPOVS2JjQ==
=1Ii6
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Apr_2007_18_30_54_+1000_FLVncb7Vsc9P.ME5--

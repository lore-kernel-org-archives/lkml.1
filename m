Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbYFOBZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbYFOBZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 21:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYFOBZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 21:25:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44574 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbYFOBZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 21:25:37 -0400
Date: Sun, 15 Jun 2008 11:25:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 06/21] perfmon2 minimal:  X86 generic hooks
Message-Id: <20080615112529.95efd539.sfr@canb.auug.org.au>
In-Reply-To: <484dafd6.0407560a.301b.6595@mx.google.com>
References: <484dafd6.0407560a.301b.6595@mx.google.com>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__15_Jun_2008_11_25_29_+1000_OM_6eYg6REVR+=5B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__15_Jun_2008_11_25_29_+1000_OM_6eYg6REVR+=5B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephane,

On Mon, 09 Jun 2008 15:33:58 -0700 (PDT) eranian@googlemail.com wrote:
>
> +++ o/arch/x86/Makefile	2008-06-02 18:54:41.000000000 +0200
> @@ -176,6 +176,8 @@
>  core-y +=3D arch/x86/kernel/
>  core-y +=3D arch/x86/mm/
> =20
> +core-$(CONFIG_PERFMON) +=3D arch/x86/perfmon/

Again, this needs to come after some code is added to arch/x86/perfmon/
so that bisections still work.

> +++ o/include/asm-x86/Kbuild	2008-06-02 18:54:41.000000000 +0200
> @@ -11,6 +11,7 @@
>  header-y +=3D sigcontext32.h
>  header-y +=3D ucontext.h
>  header-y +=3D processor-flags.h
> +header-y +=3D perfmon.h

And this bit should go in the patch that adds that file.

> +++ o/arch/x86/Kconfig	2008-06-02 18:54:41.000000000 +0200
> @@ -1306,6 +1306,8 @@
> =20
>  	  If unsure, say Y.
> =20
> +source "arch/x86/perfmon/Kconfig"

Same here.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__15_Jun_2008_11_25_29_+1000_OM_6eYg6REVR+=5B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhUb4kACgkQTgG2atn1QN9e2gCfVztP+qq/f1a40QORNvSCCv5m
RycAn1SXn/YoTsLhNlkNTyvGoA7jwSP4
=Qd9q
-----END PGP SIGNATURE-----

--Signature=_Sun__15_Jun_2008_11_25_29_+1000_OM_6eYg6REVR+=5B--

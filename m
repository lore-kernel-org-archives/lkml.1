Return-Path: <linux-kernel-owner+w=401wt.eu-S1762422AbYEEXvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762422AbYEEXvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYEEXvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:51:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51454 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbYEEXvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:51:35 -0400
Date: Tue, 6 May 2008 09:51:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Mohr <andi@lisas.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Linux 2.6.26-rc1
Message-Id: <20080506095122.860796f6.sfr@canb.auug.org.au>
In-Reply-To: <20080505073030.GI3350@elte.hu>
References: <8287f540805041818g534c4e02qaadb0e749c5f3439@mail.gmail.com>
	<20080505053935.GA15734@rhlx01.hs-esslingen.de>
	<20080505073030.GI3350@elte.hu>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_May_2008_09_51_22_+1000_1pt8sgGcSIMmeRHB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_May_2008_09_51_22_+1000_1pt8sgGcSIMmeRHB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 5 May 2008 09:30:31 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> Subject: irda: PNP support for drivers/net/irda/nsc-ircc.c
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat May 03 21:21:13 CEST 2008
>=20
> x86.git testing found the following build failure in latest -git:
>=20
>  drivers/built-in.o: In function `nsc_ircc_pnp_probe':
>  nsc-ircc.c:(.text+0xdf1b6): undefined reference to `pnp_get_resource'
>  nsc-ircc.c:(.text+0xdf1d4): undefined reference to `pnp_get_resource'
>  nsc-ircc.c:(.text+0xdf1ee): undefined reference to `pnp_get_resource'
>  nsc-ircc.c:(.text+0xdf237): undefined reference to `pnp_get_resource'
>  nsc-ircc.c:(.text+0xdf24c): undefined reference to `pnp_get_resource'
>  drivers/built-in.o:nsc-ircc.c:(.text+0xdf266): more undefined references=
 to `pnp_get_resource' follow
>  make: *** [.tmp_vmlinux1] Error 1

This was discovered in linux-next and a patch posted on March 28 ...

From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [patch] nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Date: Fri, 28 Mar 2008 10:54:43 -0600
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
        irda-users@lists.sourceforge.net, linux-next@vger.kernel.org

> Subject: irda: !PNP support for drivers/net/irda/smsc-ircc2.c
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun May 04 00:12:12 CEST 2008
>=20
> x86.git testing found this build bug on v2.6.26-rc1:
>=20
>   ERROR: "pnp_get_resource" [drivers/net/irda/smsc-ircc2.ko] undefined!
>   make[1]: *** [__modpost] Error 1
>   make: *** [modules] Error 2

As was this:

From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP
Date: Fri, 28 Mar 2008 10:53:06 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
        irda-users@lists.sourceforge.net, linux-next@vger.kernel.org

I (and I assume Andrew) have been carrying them since then but noone took
them up.  I guess (as Andrew pointed out to me) I should have pushed them.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_May_2008_09_51_22_+1000_1pt8sgGcSIMmeRHB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIH52DTgG2atn1QN8RAps5AJ99fSvsoFHT6RCCsNpzzft5ejFOhQCfQCXu
zTMw4fIpFCr5XTx8T5/EosU=
=JN72
-----END PGP SIGNATURE-----

--Signature=_Tue__6_May_2008_09_51_22_+1000_1pt8sgGcSIMmeRHB--

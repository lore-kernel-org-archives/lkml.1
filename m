Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZIHId1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZIHId1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZIHId0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:33:26 -0400
Received: from imp03.mtu.ru ([62.5.255.20]:45608 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbZIHIdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:33:25 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2009 04:33:24 EDT
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux Inc.
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       joerg.roedel@amd.com, tglx@linutronix.de
Subject: Re: [tip:core/iommu] x86/gart: Do not select AGP for GART_IOMMU
Date: Tue, 8 Sep 2009 12:27:25 +0400
User-Agent: KMail/1.9.10
References: <tip-6ac162d6c01ac7626f46c68c0770556cf682ce34@git.kernel.org>
In-Reply-To: <tip-6ac162d6c01ac7626f46c68c0770556cf682ce34@git.kernel.org>
X-Face: =?utf-8?q?=2EqZWJ=3F=248Zrl=26r=7C-=3B8=7ESTufc!R0d=5E=3FdE-g/S=5FryU2S=5D=27?=
 =?utf-8?q?=24vQ7EYY=3DBSj=5DJ-Gp=5FVXPpl=27ci/i=0A=09yH=5B=249HGUU=3Af?=@6hyHiQKeEv#S(K4XtVe$?0UO@',
 =?utf-8?q?!=25=5CR=3A7a=3BITA=3B=7Cs=7C=3F=25+T6=7E5=3Aq=2E2i=5DzA=25=0A=09?=
 =?utf-8?q?Mn-t3kOWGQ?=(7@ZOZ/0@+baHY#Fj&e/k'#p}#F<U{[DP[@"XbG&pmU~{oOMsPc4q|4/,
 =?utf-8?q?du8=0A=09?="'s*i`2=h[f!7!`#',39O3
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2036158.P7WBynGY7t";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909081227.34725.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2036158.P7WBynGY7t
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 04 September 2009 17:17:19 tip-bot for Pavel Vasilyev wrote:
> Commit-ID:  6ac162d6c01ac7626f46c68c0770556cf682ce34
> Gitweb:   =20
> http://git.kernel.org/tip/6ac162d6c01ac7626f46c68c0770556cf682ce34 Author=
:=20
>    Pavel Vasilyev <pavel@pavlinux.ru>
> AuthorDate: Thu, 3 Sep 2009 16:20:55 +0200
> Committer:  Joerg Roedel <joerg.roedel@amd.com>
> CommitDate: Thu, 3 Sep 2009 16:20:55 +0200
>
> x86/gart: Do not select AGP for GART_IOMMU
>
> There is no dependency from the gart code to the agp code.
> And since a lot of systems today do not have agp anymore
> remove this dependency from the kernel configuration.
>
> Signed-off-by: Pavel Vasilyev <pavel@pavlinux.ru>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>
>
> ---
>  arch/x86/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 13ffa5d..1d9c18a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -586,7 +586,6 @@ config GART_IOMMU
>  	bool "GART IOMMU support" if EMBEDDED
>  	default y
>  	select SWIOTLB
> -	select AGP
>  	depends on X86_64 && PCI
>  	---help---
>  	  Support for full DMA access of devices with 32bit memory access only


But what about the second part?


diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index ccb1fa8..2fb3a48 100644
=2D-- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -56,9 +56,8 @@ config AGP_AMD
          X on AMD Irongate, 761, and 762 chipsets.

 config AGP_AMD64
=2D       tristate "AMD Opteron/Athlon64 on-CPU GART support" if !GART_IOMMU
+      tristate "AMD Opteron/Athlon64 on-CPU GART support"
        depends on AGP && X86
=2D       default y if GART_IOMMU
        help
          This option gives you AGP support for the GLX component of
          X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.

--nextPart2036158.P7WBynGY7t
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBKphV2OqfDywN0JIkRApxIAJ4xYkBZMEKYhtsw2CsXHs7BKuZ03gCgiZNG
oSbLT2TAofS3ZoaXSEIBNDY=
=IyYo
-----END PGP SIGNATURE-----

--nextPart2036158.P7WBynGY7t--

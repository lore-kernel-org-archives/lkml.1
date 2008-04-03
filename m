Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbYDCLT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbYDCLT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 07:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYDCLTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 07:19:16 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:63468 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbYDCLTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:19:15 -0400
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [POWERPC] CPM1: implement GPIO LIB API
Date: Thu, 3 Apr 2008 13:19:08 +0200
User-Agent: KMail/1.9.5
Cc: Jochen Friedrich <jochen@scram.de>, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org
References: <47E92EC8.7010700@scram.de>
In-Reply-To: <47E92EC8.7010700@scram.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1562485.dGU5ni4Ual";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804031319.12715.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1562485.dGU5ni4Ual
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Jochen,

On Tuesday 25 March 2008 17:56, Jochen Friedrich wrote:
> Implement GPIO LIB API on CPM1 Freescale SoC.
>=20
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
>=20
> This is based on the series starting at=20
http://patchwork.ozlabs.org/linuxppc/patch?id=3D17299
>=20
>  arch/powerpc/platforms/8xx/Kconfig |    2 +
>  arch/powerpc/sysdev/cpm1.c         |  240=20
+++++++++++++++++++++++++++++++++++-
>  2 files changed, 241 insertions(+), 1 deletions(-)
>=20

[snip]

> diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
> index df8bd2b..c3d5df8 100644
> --- a/arch/powerpc/sysdev/cpm1.c
> +++ b/arch/powerpc/sysdev/cpm1.c
> @@ -30,11 +30,14 @@
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
>  #include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <linux/of_gpio.h>
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
>  #include <asm/8xx_immap.h>
>  #include <asm/cpm1.h>
>  #include <asm/io.h>
> +#include <asm/gpio.h>
>  #include <asm/tlbflush.h>
>  #include <asm/rheap.h>
>  #include <asm/prom.h>
> @@ -403,7 +406,7 @@ struct cpm_ioport16 {
>  };
> =20
>  struct cpm_ioport32 {
> -	__be32 dir, par, sor;
> +	__be32 dir, par, sor, dat;
>  };

I haven't checked all CPM1-based parts, but for the MPC855 family this does=
n't=20
look right. The MPC855 has two 32-bit ports, port B and port E. Registers f=
or=20
port B are dir, par, odr and dat, and registers for port E are dir, par, so=
r,=20
odr and dat.

Are you working on a similar patch for the CPM2 ? CPM2 I/O ports are 32 bit=
=20
wide and their registers are layed out like for port E on the MPC855. It=20
should thus be possible to share code between CPM1 and CPM2.

Best regards,

=2D-=20
Laurent Pinchart
CSE Semaphore Belgium

Chauss=E9e de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
=46 +32 (2) 387 42 75

--nextPart1562485.dGU5ni4Ual
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBH9L0w8y9gWxC9vpcRAvhoAKCCygKu7qNMmsr8/NaDlngfBfaJ5gCgwKxT
QOWOIRNAhV9ZBuHI8l33Shw=
=mcgX
-----END PGP SIGNATURE-----

--nextPart1562485.dGU5ni4Ual--

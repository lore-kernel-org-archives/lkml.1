Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbYB2SRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbYB2SRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYB2SRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:17:04 -0500
Received: from bokovka.donpac.ru ([80.254.111.46]:56031 "EHLO
	bokovka.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYB2SRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:17:03 -0500
X-Greylist: delayed 4960 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Feb 2008 13:17:02 EST
Date: Fri, 29 Feb 2008 19:52:17 +0300
From: Andrey Panin <pazke@pazke.donpac.ru>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/visws: fix printk format warnings
Message-ID: <20080229165217.GB6575@pazke.donpac.ru>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20080211100509.325eb561.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <20080211100509.325eb561.randy.dunlap@oracle.com>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 042, 02 11, 2008 at 10:05:09AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix visws printk format warnings:
>=20
> /local/linsrc/linux-2.6.24-git15/arch/x86/mach-visws/traps.c:50: warning:=
 format '%#lx' expects type 'long unsigned int', but argument 2 has type 'u=
32'
> /local/linsrc/linux-2.6.24-git15/arch/x86/mach-visws/traps.c:50: warning:=
 format '%#lx' expects type 'long unsigned int', but argument 3 has type 'u=
32'
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  arch/x86/mach-visws/traps.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> --- linux-2.6.24-git15.orig/arch/x86/mach-visws/traps.c
> +++ linux-2.6.24-git15/arch/x86/mach-visws/traps.c
> @@ -46,8 +46,9 @@ static __init void cobalt_init(void)
>  	 */
>  	set_fixmap(FIX_APIC_BASE, APIC_DEFAULT_PHYS_BASE);
>  	setup_local_APIC();
> -	printk(KERN_INFO "Local APIC Version %#lx, ID %#lx\n",
> -		apic_read(APIC_LVR), apic_read(APIC_ID));
> +	printk(KERN_INFO "Local APIC Version %#x, ID %#x\n",
> +		(unsigned int)apic_read(APIC_LVR),
> +		(unsigned int)apic_read(APIC_ID));
> =20
>  	set_fixmap(FIX_CO_CPU, CO_CPU_PHYS);
>  	set_fixmap(FIX_CO_APIC, CO_APIC_PHYS);

Sorry for so late answer, I missed your mail somehow :(

Acked-By: Andrey Panin <pazke@donpac.ru>=20

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHyDhBIWZCBzwS8mkRAlIWAJ9OtNk8qZ+uW97qQUwy6pUkYX2RuwCeL5Zg
PVKe+c5CfpJNzvE8PQZEMvY=
=A9kT
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--

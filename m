Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYEDX5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYEDX5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 19:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYEDX5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 19:57:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46052 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbYEDX5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 19:57:01 -0400
Date: Mon, 5 May 2008 09:56:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: monstr@seznam.cz
Cc: paulus@samba.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 1/2] OF: Fix coding style violation in of_device.c and
 of_platform.c
Message-Id: <20080505095649.fccb57bf.sfr@canb.auug.org.au>
In-Reply-To: <765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu>
References: <monstr@seznam.cz>
	<1209824532-7939-1-git-send-email-monstr@seznam.cz>
	<765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_May_2008_09_56_49_+1000_7ZrFRfrsZksKuMgL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_May_2008_09_56_49_+1000_7ZrFRfrsZksKuMgL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Sat,  3 May 2008 16:22:11 +0200 monstr@seznam.cz wrote:
>
> From: Michal Simek <monstr@monstr.eu>
>=20
>=20
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/powerpc/kernel/of_device.c   |   25 ++++++++++++++-----------
>  arch/powerpc/kernel/of_platform.c |    5 ++++-

These two files are the architecture specific parts of
drivers/of/device.c and platform.c respectively.  If there are parts that
are usable more generally than just powerpc, then those parts should be
removed from the current sources and merged into the drivers/of files.

Some of what you have below are not cleanups and not relevant to the
powerpc architecture.

Any changes to the drivers of files should be cc'd to me (who did the
initial splitup) and Dave Miller since you may impact the sparc code
(which is the other user).

>  2 files changed, 18 insertions(+), 12 deletions(-)
>=20
> diff --git a/arch/powerpc/kernel/of_device.c b/arch/powerpc/kernel/of_dev=
ice.c
> index 5748ddb..db9ed02 100644
> --- a/arch/powerpc/kernel/of_device.c
> +++ b/arch/powerpc/kernel/of_device.c
> @@ -8,7 +8,10 @@
>  #include <linux/of_device.h>
> =20
>  #include <asm/errno.h>
> +
> +#ifdef CONFIG_PPC_PSERIES
>  #include <asm/dcr.h>
> +#endif
> =20
>  static void of_device_make_bus_id(struct of_device *dev)
>  {
> @@ -106,7 +109,7 @@ ssize_t of_device_get_modalias(struct of_device *ofde=
v,
>  		return csize;
> =20
>  	/* Find true end (we tolerate multiple \0 at the end */
> -	for (i=3D(cplen-1); i>=3D0 && !compat[i]; i--)
> +	for (i =3D (cplen-1); i >=3D 0 && !compat[i]; i--)
>  		cplen--;
>  	if (!cplen)
>  		return csize;
> @@ -116,26 +119,27 @@ ssize_t of_device_get_modalias(struct of_device *of=
dev,
>  	tsize =3D csize + cplen;
>  	repend =3D tsize;
> =20
> -	if (csize>=3Dlen)		/* @ the limit, all is already filled */
> +	if (csize >=3D len)	/* @ the limit, all is already filled */
>  		return tsize;
> =20
> -	if (tsize>=3Dlen) {		/* limit compat list */
> -		cplen =3D len-csize-1;
> +	if (tsize >=3D len) {	/* limit compat list */
> +		cplen =3D len - csize - 1;
>  		repend =3D len;
>  	}
> =20
>  	/* Copy and do char replacement */
>  	memcpy(&str[csize+1], compat, cplen);
> -	for (i=3Dcsize; i<repend; i++) {
> +	for (i =3D csize; i < repend; i++) {
>  		char c =3D str[i];
> -		if (c=3D=3D'\0')
> +		if (c =3D=3D '\0')
>  			str[i] =3D 'C';
> -		else if (c=3D=3D' ')
> +		else if (c =3D=3D ' ')
>  			str[i] =3D '_';
>  	}
> =20
>  	return tsize;
>  }
> +EXPORT_SYMBOL(of_device_get_modalias);
> =20
>  int of_device_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
> @@ -154,9 +158,9 @@ int of_device_uevent(struct device *dev, struct kobj_=
uevent_env *env)
>  	if (add_uevent_var(env, "OF_TYPE=3D%s", ofdev->node->type))
>  		return -ENOMEM;
> =20
> -        /* Since the compatible field can contain pretty much anything
> -         * it's not really legal to split it out with commas. We split it
> -         * up using a number of environment variables instead. */
> +	/* Since the compatible field can contain pretty much anything
> +	 * it's not really legal to split it out with commas. We split it
> +	 * up using a number of environment variables instead. */
> =20
>  	compat =3D of_get_property(ofdev->node, "compatible", &cplen);
>  	while (compat && *compat && cplen > 0) {
> @@ -184,4 +188,3 @@ int of_device_uevent(struct device *dev, struct kobj_=
uevent_env *env)
>  	return 0;
>  }
>  EXPORT_SYMBOL(of_device_uevent);
> -EXPORT_SYMBOL(of_device_get_modalias);
> diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_p=
latform.c
> index e79ad8a..cd9336e 100644
> --- a/arch/powerpc/kernel/of_platform.c
> +++ b/arch/powerpc/kernel/of_platform.c
> @@ -26,9 +26,12 @@
>  #include <asm/errno.h>
>  #include <asm/topology.h>
>  #include <asm/pci-bridge.h>
> -#include <asm/ppc-pci.h>
>  #include <asm/atomic.h>
> =20
> +#ifdef CONFIG_PPC_PSERIES
> +#include <asm/ppc-pci.h>
> +#endif
> +
>  /*
>   * The list of OF IDs below is used for matching bus types in the
>   * system whose devices are to be exposed as of_platform_devices.
> --=20
> 1.5.4.GIT
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_May_2008_09_56_49_+1000_7ZrFRfrsZksKuMgL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIHk1FTgG2atn1QN8RAmW/AJ9jOTwjpyuVKcyYZvlyCkn3522o0wCfY1RW
O7hG8iZ23getgxlxP4XBbZo=
=9Qxe
-----END PGP SIGNATURE-----

--Signature=_Mon__5_May_2008_09_56_49_+1000_7ZrFRfrsZksKuMgL--

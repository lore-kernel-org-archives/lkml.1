Return-Path: <linux-kernel-owner+w=401wt.eu-S1030591AbXDRIqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591AbXDRIqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030671AbXDRIqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:46:25 -0400
Received: from ozlabs.org ([203.10.76.45]:36008 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030591AbXDRIqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:46:22 -0400
Subject: Re: [PATCH 2.6.21-rc5 1/3] msi: introduce ARCH_SUPPORTS_MSI
	Kconfig option (rev2)
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Greg KH <greg@kroah.com>
Cc: linux@arm.linux.org.uk, linux-pci@atrey.karlin.mff.cuni.cz,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <20070330230549.14060.70172.stgit@dwillia2-linux.ch.intel.com>
References: <20070330220243.14060.14389.stgit@dwillia2-linux.ch.intel.com>
	 <20070330230549.14060.70172.stgit@dwillia2-linux.ch.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yZ35M8Bk+absugbAArKY"
Date: Wed, 18 Apr 2007 18:46:20 +1000
Message-Id: <1176885980.4987.67.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yZ35M8Bk+absugbAArKY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-30 at 16:05 -0700, Dan Williams wrote:
> Allows architectures to advertise that they support MSI rather than listi=
ng
> each architecture as a PCI_MSI dependency.
>=20
> rev2:
> * update i386 and x86_64 as well
>=20
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Hi Greg,

Are you planning on merging this one? AFAICT it still applies cleanly.
At the moment my powerpc MSI patches depend on it.

cheers


>  arch/arm/Kconfig     |    1 +
>  arch/i386/Kconfig    |    1 +
>  arch/ia64/Kconfig    |    1 +
>  arch/sparc64/Kconfig |    1 +
>  arch/x86_64/Kconfig  |    1 +
>  drivers/pci/Kconfig  |    6 +++++-
>  6 files changed, 10 insertions(+), 1 deletions(-)
>=20
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index e7baca2..db00376 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -255,6 +255,7 @@ config ARCH_IOP13XX
>  	depends on MMU
>  	select PLAT_IOP
>  	select PCI
> +	select ARCH_SUPPORTS_MSI
>  	help
>  	  Support for Intel's IOP13XX (XScale) family of processors.
> =20
> diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
> index 53d6237..bcf2fc4 100644
> --- a/arch/i386/Kconfig
> +++ b/arch/i386/Kconfig
> @@ -1073,6 +1073,7 @@ config PCI
>  	bool "PCI support" if !X86_VISWS
>  	depends on !X86_VOYAGER
>  	default y if X86_VISWS
> +	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
>  	help
>  	  Find out whether you have a PCI motherboard. PCI is the name of a
>  	  bus system, i.e. the way the CPU talks to the other stuff inside
> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> index e19185d..3b71f97 100644
> --- a/arch/ia64/Kconfig
> +++ b/arch/ia64/Kconfig
> @@ -14,6 +14,7 @@ config IA64
>  	select PCI if (!IA64_HP_SIM)
>  	select ACPI if (!IA64_HP_SIM)
>  	select PM if (!IA64_HP_SIM)
> +	select ARCH_SUPPORTS_MSI
>  	default y
>  	help
>  	  The Itanium Processor Family is Intel's 64-bit successor to
> diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
> index 1a6348b..b9b2b52 100644
> --- a/arch/sparc64/Kconfig
> +++ b/arch/sparc64/Kconfig
> @@ -299,6 +299,7 @@ config SUN_IO
> =20
>  config PCI
>  	bool "PCI support"
> +	select ARCH_SUPPORTS_MSI
>  	help
>  	  Find out whether you have a PCI motherboard. PCI is the name of a
>  	  bus system, i.e. the way the CPU talks to the other stuff inside
> diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
> index 56eb14c..e9b4f05 100644
> --- a/arch/x86_64/Kconfig
> +++ b/arch/x86_64/Kconfig
> @@ -676,6 +676,7 @@ menu "Bus options (PCI etc.)"
> =20
>  config PCI
>  	bool "PCI support"
> +	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
> =20
>  # x86-64 doesn't support PCI BIOS access from long mode so always go dir=
ect.
>  config PCI_DIRECT
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 5ea5bc7..70efe8f 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -1,10 +1,14 @@
>  #
>  # PCI configuration
>  #
> +config ARCH_SUPPORTS_MSI
> +	bool
> +	default n
> +
>  config PCI_MSI
>  	bool "Message Signaled Interrupts (MSI and MSI-X)"
>  	depends on PCI
> -	depends on (X86_LOCAL_APIC && X86_IO_APIC) || IA64 || SPARC64
> +	depends on ARCH_SUPPORTS_MSI
>  	help
>  	   This allows device drivers to enable MSI (Message Signaled
>  	   Interrupts).  Message Signaled Interrupts enable a device to
--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-yZ35M8Bk+absugbAArKY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGJdrcdSjSd0sB4dIRAn6YAJ9dgeGKbyb5m+ktV4uRr+KSq6oDHgCeLe/3
olWpINDvTfrV/7gmOOaC7yA=
=XGga
-----END PGP SIGNATURE-----

--=-yZ35M8Bk+absugbAArKY--


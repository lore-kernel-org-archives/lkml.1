Return-Path: <linux-kernel-owner+w=401wt.eu-S1765646AbXEVCm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765646AbXEVCm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 22:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758912AbXEVCmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 22:42:15 -0400
Received: from moa.IfA.Hawaii.Edu ([128.171.168.48]:36182 "EHLO
	moa.ifa.hawaii.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765561AbXEVCmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 22:42:14 -0400
Date: Mon, 21 May 2007 16:47:43 -1000
From: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
To: Dave Jones <davej@redhat.com>, Ed Sweetman <safemode2@comcast.net>,
       Duane Griffin <duaneg@dghda.com>, Prakash Punnoor <prakash@punnoor.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States driver
Message-ID: <20070522024743.GA21514@ifa.hawaii.edu>
References: <20070516011711.GE15763@ifa.hawaii.edu> <200705162039.02379.prakash@punnoor.de> <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com> <20070516204807.GA23751@redhat.com> <20070518030436.GB20793@ifa.hawaii.edu> <464D2702.1060001@comcast.net> <20070518160108.GA28021@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20070518160108.GA28021@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 18, 2007 at 12:01:08PM -0400, Dave Jones wrote:
> On Fri, May 18, 2007 at 12:09:38AM -0400, Ed Sweetman wrote:
[snip]
> still has unnecessary whitespace changes
[snip]
> and still wordwrapped.
> (also capitalise ACPI)

I haven't seen any more e-mail traffic on this topic so I'm assuming
that the ball has been dropped.  Please excuse me if an acceptable patch
has been submitted that I wasn't CC'd on.=20

Here is cleaned up version of Ed's patch that I believe addresses Dave's
stylistic concerns applies the relevant changes to both x86 & x86_64.

Signed-off-by: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
--
 i386/kernel/cpu/cpufreq/Kconfig |   13 ++++++++++---
 x86_64/kernel/cpufreq/Kconfig   |   13 ++++++++++---
 2 files changed, 20 insertions(+), 6 deletions(-)

diff -Nurp linux-2.6.22-rc1-mm1.orig/arch/i386/kernel/cpu/cpufreq/Kconfig l=
inux-2.6.22-rc1-mm1/arch/i386/kernel/cpu/cpufreq/Kconfig
--- linux-2.6.22-rc1-mm1.orig/arch/i386/kernel/cpu/cpufreq/Kconfig	2007-04-=
27 11:49:26.000000000 -1000
+++ linux-2.6.22-rc1-mm1/arch/i386/kernel/cpu/cpufreq/Kconfig	2007-05-21 16=
:20:47.000000000 -1000
@@ -90,10 +90,17 @@ config X86_POWERNOW_K8
 	  If in doubt, say N.
=20
 config X86_POWERNOW_K8_ACPI
-	bool
-	depends on X86_POWERNOW_K8 && ACPI_PROCESSOR
-	depends on !(X86_POWERNOW_K8 =3D y && ACPI_PROCESSOR =3D m)
+	bool "ACPI Support"
+	select ACPI_PROCESSOR
+	depends on X86_POWERNOW_K8
 	default y
+	help
+	  This provides access to the K8s Processor Performance States via ACPI.
+	  This driver is probably required for CPUFreq to work with multi-socket =
and
+	  SMP systems.  It is not required on at least some single-socket yet
+	  multi-core systems, even if SMP is enabled.
+
+	  It is safe to say Y here.
=20
 config X86_GX_SUSPMOD
 	tristate "Cyrix MediaGX/NatSemi Geode Suspend Modulation"
diff -Nurp linux-2.6.22-rc1-mm1.orig/arch/x86_64/kernel/cpufreq/Kconfig lin=
ux-2.6.22-rc1-mm1/arch/x86_64/kernel/cpufreq/Kconfig
--- linux-2.6.22-rc1-mm1.orig/arch/x86_64/kernel/cpufreq/Kconfig	2007-05-21=
 16:11:16.000000000 -1000
+++ linux-2.6.22-rc1-mm1/arch/x86_64/kernel/cpufreq/Kconfig	2007-05-21 16:2=
9:11.000000000 -1000
@@ -24,10 +24,17 @@ config X86_POWERNOW_K8
 	  If in doubt, say N.
=20
 config X86_POWERNOW_K8_ACPI
-	bool
-	depends on X86_POWERNOW_K8 && ACPI_PROCESSOR
-	depends on !(X86_POWERNOW_K8 =3D y && ACPI_PROCESSOR =3D m)
+	bool "ACPI Support"
+	select ACPI_PROCESSOR
+	depends on X86_POWERNOW_K8
 	default y
+	help
+	  This provides access to the K8s Processor Performance States via ACPI.
+	  This driver is probably required for CPUFreq to work with multi-socket =
and
+	  SMP systems.  It is not required on at least some single-socket yet
+	  multi-core systems, even if SMP is enabled.
+=09
+	  It is safe to say Y here.
=20
 config X86_SPEEDSTEP_CENTRINO
 	tristate "Intel Enhanced SpeedStep (deprecated)"

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGUlnPWa2BU+b7tU0RAmFSAKCPEmm4D3JlBEqeabCW133rnK458QCcC8nY
eGk7MV12kpLt4RkMPpaySnw=
=Au5F
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762155AbYBLJEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155AbYBLJEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbYBLJEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:04:30 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:4292 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbYBLJE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:04:26 -0500
Date: Tue, 12 Feb 2008 10:04:18 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>
Cc: Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Configure out DMI scanning code v2 (Linux Tiny)
Message-ID: <20080212100418.5de764da@crazy>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2dUlwZdi6drQ.K1w1qfMsv8";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2dUlwZdi6drQ.K1w1qfMsv8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

Enclosed patch is an updated version, with proper credits to Matt
Mackall and the Linux Tiny project.

Sincerly,

Thomas

---

Turn CONFIG_DMI into a selectable option if EMBEDDED is defined, in
order to be able to remove the DMI table scanning code if it's not
needed, and then reduce the kernel code size.

With CONFIG_DMI (i.e before) :

   text    data     bss     dec     hex filename
1076076  128656   98304 1303036  13e1fc vmlinux

Without CONFIG_DMI (i.e after) :

   text    data     bss     dec     hex filename
1068092  126308   98304 1292704  13b9a0 vmlinux

Result:

   text    data     bss     dec     hex filename
  -7984   -2348       0  -10332   -285c vmlinux

The new option appears in "Processor type and features", only when
CONFIG_EMBEDDED is defined.

This patch is part of the Linux Tiny project, and is based on previous
work done by Matt Mackall <mpm@selenic.com>.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

---
 arch/x86/Kconfig    |   12 +++++++++---
 include/linux/dmi.h |    1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

Index: linux/arch/x86/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/Kconfig	2008-02-11 16:51:50.000000000 +0100
+++ linux/arch/x86/Kconfig	2008-02-11 17:48:15.000000000 +0100
@@ -88,9 +88,6 @@
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
=20
-config DMI
-	def_bool y
-
 config RWSEM_GENERIC_SPINLOCK
 	def_bool !X86_XADD
=20
@@ -433,6 +430,15 @@
=20
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
+config DMI
+	default y
+	bool "Enable DMI scanning" if EMBEDDED
+	help
+	  Enabled scanning of DMI to identify machine quirks. Say Y
+	  here unless you have verified that your setup is not
+	  affected by entries in the DMI blacklist. Required by PNP
+	  BIOS code.
+
 config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
Index: linux/include/linux/dmi.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/include/linux/dmi.h	2008-02-11 16:51:30.000000000 +0100
+++ linux/include/linux/dmi.h	2008-02-11 17:40:31.000000000 +0100
@@ -90,6 +90,7 @@
 static inline const char * dmi_get_system_info(int field) { return NULL; }
 static inline const struct dmi_device * dmi_find_device(int type, const ch=
ar *name,
 	const struct dmi_device *from) { return NULL; }
+static inline void dmi_scan_machine(void) { return; }
 static inline int dmi_get_year(int year) { return 0; }
 static inline int dmi_name_in_vendors(const char *s) { return 0; }
 #define dmi_available 0


--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/2dUlwZdi6drQ.K1w1qfMsv8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsWES9lPLMJjT96cRAoVaAKCtg04rk/ggvfIFJKJ2Yd8zvki4YgCfWQRo
WZtRIo0eLecUkpI7E0tEeSk=
=UovM
-----END PGP SIGNATURE-----

--Sig_/2dUlwZdi6drQ.K1w1qfMsv8--

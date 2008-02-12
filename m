Return-Path: <linux-kernel-owner+w=401wt.eu-S1762716AbYBLKfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762716AbYBLKfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762484AbYBLKfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:35:44 -0500
Received: from ns6.enix.org ([193.19.211.1]:39949 "EHLO the-doors.enix.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbYBLKfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:35:43 -0500
X-Greylist: delayed 1634 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2008 05:35:43 EST
Date: Tue, 12 Feb 2008 11:08:25 +0100
From: Thomas Petazzoni <thomas.petazzoni@enix.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>
Cc: Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Configure out doublefault exception handler (Linux Tiny)
Message-ID: <20080212110825.35db27cb@crazy>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/juR=dXWLyO/P9J+pWfvwQ+S";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/juR=dXWLyO/P9J+pWfvwQ+S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

Enclosed patch allows to configure out the doublefault exception
handler. The original patch of Matt Mackall added the option in
init/Kconfig, but because this is a x86-specific thing, I thought
arch/x86/Kconfig would be a better place. Is that correct ?

This patch applies on top on the DMI scanning code patch I've sent
yesterday, because the DOUBLEFAULT config option is right after the DMI
config option. Is that ok, or should I propose a patch on top of a
vanilla 2.6.25-rc1 ?

Thanks for your review and comments,

Thomas

---


This patch adds the ability to disable the doublefault exception
handler, in order to save some kernel space. The doublefault exception
handler was already conditionnaly compiled using CONFIG_DOUBLEFAULT,
but there was no way to change the value of this configuration
option. The option is only visible if CONFIG_EMBEDDED is selected, in
order to not confuse other users.

The kernel space savings are as follows:

   text    data     bss     dec     hex filename
1076076  128656   98304 1303036  13e1fc vmlinux.before
1075772  119952   94208 1289932  13aecc vmlinux.after
   -304   -8704   -4096  -13104   -3330 +/-

This patch is part of the Linux Tiny project, and is based on previous
work by Matt Mackall <mpm@selenic.com>.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

---
 arch/x86/Kconfig |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/arch/x86/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -439,6 +439,13 @@
 	  affected by entries in the DMI blacklist. Required by PNP
 	  BIOS code.
=20
+config DOUBLEFAULT
+	default y
+	bool "Enable doublefault exception handler" if EMBEDDED
+	help
+	  This option allows trapping of rare doublefault exceptions
+	  that would otherwise cause a system to silently reboot.
+
 config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y


--=20
Thomas Petazzoni, thomas.petazzoni@enix.org, http://thomas.enix.org
Jabber, thomas.petazzoni@jabber.dk
Toulibre, http://www.toulibre.org - APRIL, http://www.april.org
Fingerprint : 0BE1 4CF3 CEA4 AC9D CC6E  1624 F653 CB30 98D3 F7A7

--Sig_/juR=dXWLyO/P9J+pWfvwQ+S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsXAZ9lPLMJjT96cRAoktAJ48aM51wUwWAzcLLpGrQa61x5AerwCfW/C1
+8Qi6/E7H2vHPbHzMmFfsZo=
=nfln
-----END PGP SIGNATURE-----

--Sig_/juR=dXWLyO/P9J+pWfvwQ+S--

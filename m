Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbZEHCvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbZEHCvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 22:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZEHCvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:51:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:46451 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbZEHCvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:51:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,314,1239001200"; 
   d="asc'?scan'208";a="455192892"
Subject: [BUGFIX] Fix crashdump panic with CONFIG_KEXEC_JUMP
From: Huang Ying <ying.huang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tim Starling <tstarling@wikimedia.org>,
       akpm@linux-foundation.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MOj3XKCio0x+2PXD8095"
Date: Fri, 08 May 2009 10:51:41 +0800
Message-Id: <1241751101.6259.85.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MOj3XKCio0x+2PXD8095
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Tim Starling reported that crashdump will panic with kernel compiled
with CONFIG_KEXEC_JUMP due to null pointer deference in
machine_kexec_32.c: machine_kexec(), when deferencing
kexec_image. Refering to:

http://bugzilla.kernel.org/show_bug.cgi?id=3D13265

This patch fixes the BUG via replacing global variable reference:
kexec_image in machine_kexec() with local variable reference: image,
which is more appropriate, and will not be null.

Same BUG is in machine_kexec_64.c too, so fixed too in the same way.

Reported-by: Tim Starling <tstarling@wikimedia.org>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/machine_kexec_32.c |    4 ++--
 arch/x86/kernel/machine_kexec_64.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -194,7 +194,7 @@ void machine_kexec(struct kimage *image)
 				       unsigned int preserve_context);
=20
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		save_processor_state();
 #endif
=20
@@ -253,7 +253,7 @@ void machine_kexec(struct kimage *image)
 					   image->preserve_context);
=20
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		restore_processor_state();
 #endif
=20
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -274,7 +274,7 @@ void machine_kexec(struct kimage *image)
 	int save_ftrace_enabled;
=20
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		save_processor_state();
 #endif
=20
@@ -333,7 +333,7 @@ void machine_kexec(struct kimage *image)
 				       image->preserve_context);
=20
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		restore_processor_state();
 #endif
=20


--=-MOj3XKCio0x+2PXD8095
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoDnjkACgkQKhFGF+eHlphwCACfSaYO+EqomMp2Gyo1enqklfXP
HiMAn2s9/BopPSCgA3Ug/a6mUQBA5EJk
=4ASh
-----END PGP SIGNATURE-----

--=-MOj3XKCio0x+2PXD8095--


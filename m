Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYJaBsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYJaBsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYJaBsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:48:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:58939 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbYJaBsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:48:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,519,1220252400"; 
   d="asc'?scan'208";a="354246309"
Subject: [PATCH 1/3 -v4] kexec/i386: remove PAGE_SIZE alignment from
	relocate_kernel
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Horman <horms@verge.net.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iK1vXjXz2mTvdEJlSvIR"
Date: Fri, 31 Oct 2008 09:48:02 +0800
Message-Id: <1225417682.24095.136.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iK1vXjXz2mTvdEJlSvIR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patch removes PAGE_SIZE alignment from relocate_kernel(). Before
kexec jump patches are merged, control page is mapped to
relocate_kernel in kexec page tables, so relocate_kernel must be
PAGE_SIZE aligned. Now, control page is mapped to identity mapped
address, so relocate_kernel need not to be PAGE_SIZE aligned any
more. This can reduce a few KB from kernel text segement.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/relocate_kernel_32.S |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -39,7 +39,6 @@
 #define CP_PA_BACKUP_PAGES_MAP	DATA(0x1c)
=20
 	.text
-	.align PAGE_SIZE
 	.globl relocate_kernel
 relocate_kernel:
 	/* Save the CPU context, used for jumping back */


--=-iK1vXjXz2mTvdEJlSvIR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkKY84ACgkQKhFGF+eHlpg5UACfagSQDmKle7bBEszLd9AcC2bi
pYIAn0kA9Ygn/QLAE7zkRxKqptgwDxTW
=NXjE
-----END PGP SIGNATURE-----

--=-iK1vXjXz2mTvdEJlSvIR--


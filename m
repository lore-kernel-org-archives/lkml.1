Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYJ3IRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYJ3IRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYJ3IRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:17:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:47353 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbYJ3IRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,513,1220252400"; 
   d="asc'?scan'208";a="67556018"
Subject: [PATCH -mm 1/3 -v3] kexec/i386: remove PAGE_SIZE alignment from
	relocate_kernel
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Horman <horms@verge.net.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HSAJ/F0KW4x8D9BLfKcY"
Date: Thu, 30 Oct 2008 16:17:01 +0800
Message-Id: <1225354621.24095.111.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HSAJ/F0KW4x8D9BLfKcY
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


--=-HSAJ/F0KW4x8D9BLfKcY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkJbXoACgkQKhFGF+eHlpjNwwCfcZfbtUZlnk0Mwub4h9hZUFcd
gjAAnjHNO5dWl8bApW/EWIvPw7GHtgIW
=Fy7V
-----END PGP SIGNATURE-----

--=-HSAJ/F0KW4x8D9BLfKcY--


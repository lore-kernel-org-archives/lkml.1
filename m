Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbXJWK6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbXJWK6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXJWK62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:58:28 -0400
Received: from partizan.velesys.com ([213.184.230.195]:52897 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbXJWK61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:58:27 -0400
X-Greylist: delayed 1560 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2007 06:58:26 EDT
Date: Tue, 23 Oct 2007 13:33:04 +0300
From: "Kirill A. Shutemov" <k.shutemov@velesys.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Do not export PAGE_SIZE to userspace.
Message-ID: <20071023103304.GA10209@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
X-Operating-System: ALT Linux Sisyphus (20070101) (Kernel
	2.6.18-std-smp-alt8)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Userspace should use getpagesize() or sysconf(_SC_PAGESIZE) to get memory
page size.

man 2 getpagesize:
=2E.. Generally, one uses  binaries  that are architecture but not machine
model dependent, in order to have a single binary distribution per
architecture. This means that a user program should not find PAGE_SIZE at
compile time from a header file, but use an actual system call, at least
for those architectures (like sun4)  where this dependency exists.

Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
---
 include/asm-blackfin/page.h |    4 ++--
 include/asm-m32r/page.h     |    3 ++-
 include/asm-ppc/page.h      |    4 ++--
 include/asm-s390/page.h     |    2 +-
 include/asm-sh64/page.h     |    2 +-
 include/asm-um/page.h       |    4 ++++
 include/asm-x86/page_32.h   |    3 ++-
 include/asm-x86/page_64.h   |    3 ++-
 8 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/asm-blackfin/page.h b/include/asm-blackfin/page.h
index 8bc8671..613d353 100644
--- a/include/asm-blackfin/page.h
+++ b/include/asm-blackfin/page.h
@@ -1,6 +1,8 @@
 #ifndef _BLACKFIN_PAGE_H
 #define _BLACKFIN_PAGE_H
=20
+#ifdef __KERNEL__
+
 /* PAGE_SHIFT determines the page size */
=20
 #define PAGE_SHIFT	12
@@ -11,8 +13,6 @@
 #endif
 #define PAGE_MASK	(~(PAGE_SIZE-1))
=20
-#ifdef __KERNEL__
-
 #include <asm/setup.h>
=20
 #ifndef __ASSEMBLY__
diff --git a/include/asm-m32r/page.h b/include/asm-m32r/page.h
index 04fd183..7246369 100644
--- a/include/asm-m32r/page.h
+++ b/include/asm-m32r/page.h
@@ -1,12 +1,13 @@
 #ifndef _ASM_M32R_PAGE_H
 #define _ASM_M32R_PAGE_H
=20
+#ifdef __KERNEL__
+
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
 #define PAGE_SIZE	(1UL << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
=20
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
=20
 extern void clear_page(void *to);
diff --git a/include/asm-ppc/page.h b/include/asm-ppc/page.h
index ad4c5a1..a1333a0 100644
--- a/include/asm-ppc/page.h
+++ b/include/asm-ppc/page.h
@@ -1,6 +1,8 @@
 #ifndef _PPC_PAGE_H
 #define _PPC_PAGE_H
=20
+#ifdef __KERNEL__
+
 #include <asm/asm-compat.h>
=20
 /* PAGE_SHIFT determines the page size */
@@ -13,8 +15,6 @@
  */
 #define PAGE_MASK	(~((1 << PAGE_SHIFT) - 1))
=20
-#ifdef __KERNEL__
-
 /* This must match what is in arch/ppc/Makefile */
 #define PAGE_OFFSET	CONFIG_KERNEL_START
 #define KERNELBASE	PAGE_OFFSET
diff --git a/include/asm-s390/page.h b/include/asm-s390/page.h
index 584d0ee..160293c 100644
--- a/include/asm-s390/page.h
+++ b/include/asm-s390/page.h
@@ -9,6 +9,7 @@
 #ifndef _S390_PAGE_H
 #define _S390_PAGE_H
=20
+#ifdef __KERNEL__
 #include <linux/const.h>
 #include <asm/types.h>
=20
@@ -19,7 +20,6 @@
 #define PAGE_DEFAULT_ACC	0
 #define PAGE_DEFAULT_KEY	(PAGE_DEFAULT_ACC << 4)
=20
-#ifdef __KERNEL__
 #include <asm/setup.h>
 #ifndef __ASSEMBLY__
=20
diff --git a/include/asm-sh64/page.h b/include/asm-sh64/page.h
index 472089a..d1c3fa2 100644
--- a/include/asm-sh64/page.h
+++ b/include/asm-sh64/page.h
@@ -17,6 +17,7 @@
  *
  */
=20
+#ifdef __KERNEL__
=20
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
@@ -43,7 +44,6 @@
 #define ARCH_HAS_SETCLEAR_HUGE_PTE
 #endif
=20
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
=20
 extern struct page *mem_map;
diff --git a/include/asm-um/page.h b/include/asm-um/page.h
index 4b424c7..85604ae 100644
--- a/include/asm-um/page.h
+++ b/include/asm-um/page.h
@@ -7,6 +7,8 @@
 #ifndef __UM_PAGE_H
 #define __UM_PAGE_H
=20
+#ifdef __KERNEL__
+
 struct page;
=20
 #include <linux/types.h>
@@ -118,4 +120,6 @@ extern struct page *arch_validate(struct page *page, gf=
p_t mask, int order);
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
=20
+#endif /* __KERNEL__ */
+
 #endif
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index 80ecc66..2569e21 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -1,6 +1,8 @@
 #ifndef _I386_PAGE_H
 #define _I386_PAGE_H
=20
+#ifdef __KERNEL__
+
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
 #define PAGE_SIZE	(1UL << PAGE_SHIFT)
@@ -9,7 +11,6 @@
 #define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
 #define LARGE_PAGE_SIZE (1UL << PMD_SHIFT)
=20
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
=20
 #ifdef CONFIG_X86_USE_3DNOW
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
index c3b52bc..80ab148 100644
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -1,6 +1,8 @@
 #ifndef _X86_64_PAGE_H
 #define _X86_64_PAGE_H
=20
+#ifdef __KERNEL__
+
 #include <linux/const.h>
=20
 /* PAGE_SHIFT determines the page size */
@@ -37,7 +39,6 @@
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
=20
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
=20
 extern unsigned long end_pfn;
--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + Velesys LLC, http://www.velesys.com/
 + ALT Linux Team, http://www.altlinux.com/

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHHc3gbWYnhzC5v6oRAjLKAJ94HA5gwkIVcouebYR2QskSOUoLcgCgk4Up
MfmY62jo744PIltWMByIQQg=
=+fyE
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--

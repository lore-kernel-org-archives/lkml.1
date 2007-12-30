Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbXL3GmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbXL3GmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 01:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXL3GmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 01:42:14 -0500
Received: from haddock.cd.chalmers.se ([129.16.79.2]:44157 "EHLO
	haddock.cd.chalmers.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbXL3GmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 01:42:13 -0500
X-Greylist: delayed 1096 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Dec 2007 01:42:12 EST
X-Face: ^"+mumOlNwo;yI>`\39\txuVze?eiR9uqpo2*mE!9MWXgXI0v(3ArwymNWe'.q:eLl!=guD
 x{jGFEWN6,#HoN%2qRW;7.CL]9%Ap,067"u1%!NUqS.MhV'+,6$Fj-;W2Z}Y,JUZ'L+f<?~E{ID*=T
 V\NxAOu>)|B@3k3n;gLl*#i[(J-os#fNnDJ8m["|JWNwpORh|_.MGkR#|a~QS!"4hEQ{O{[Ii14{xD
 PU/:5wuv7m1=TK=.>G8wdfpY~]{H(Qa\1`%|Hz:!)c3f9UOW|WgE"4d\E7?oDu9.
To: linux-kernel@vger.kernel.org
Cc: rth@twiddle.net, iko@cd.chalmers.se
Subject: [PATCH] include/asm-alpha/core_cia.h, kernel 2.6.23.12
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----- =_aaaaaaaaaa0"
Content-ID: <21320.1198987941.0@haddock.cd.chalmers.se>
Date: Sun, 30 Dec 2007 07:23:53 +0100
From: Anders Hammarquist <iko@cd.chalmers.se>
Message-Id: <20071230062354.8A4FB38414@haddock.cd.chalmers.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------- =_aaaaaaaaaa0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21320.1198987941.1@haddock.cd.chalmers.se>

[please Cc: me on followups]

Trying to compile 2.6.23.12 on alpha (a miata) resulted in this
failure:

cc1: warnings being treated as errors
include/asm/io_trivial.h: In function 'cia_readb':
include/asm/io_trivial.h:75: warning: passing argument 1 of 'cia_ioread8' discards qualifiers from pointer target type

This trivial patch to include/asm-alpha/core_cia.h fixed it 

------- =_aaaaaaaaaa0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21320.1198987941.2@haddock.cd.chalmers.se>

diff -ur linux-2.6.23.12/include/asm-alpha/core_cia.h ../src/linux-2.6.23.12/include/asm-alpha/core_cia.h
--- linux-2.6.23.12/include/asm-alpha/core_cia.h	2007-12-18 22:55:57.000000000 +0100
+++ ../src/linux-2.6.23.12/include/asm-alpha/core_cia.h	2007-12-30 04:52:28.956657441 +0100
@@ -341,7 +341,7 @@
 #define vuip	volatile unsigned int __force *
 #define vulp	volatile unsigned long __force *
 
-__EXTERN_INLINE unsigned int cia_ioread8(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int cia_ioread8(const volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	unsigned long result, base_and_type;
@@ -358,7 +358,7 @@
 	return __kernel_extbl(result, addr & 3);
 }
 
-__EXTERN_INLINE void cia_iowrite8(u8 b, void __iomem *xaddr)
+__EXTERN_INLINE void cia_iowrite8(u8 b, volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	unsigned long w, base_and_type;
@@ -373,7 +373,7 @@
 	*(vuip) ((addr << 5) + base_and_type) = w;
 }
 
-__EXTERN_INLINE unsigned int cia_ioread16(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int cia_ioread16(const volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	unsigned long result, base_and_type;
@@ -388,7 +388,7 @@
 	return __kernel_extwl(result, addr & 3);
 }
 
-__EXTERN_INLINE void cia_iowrite16(u16 b, void __iomem *xaddr)
+__EXTERN_INLINE void cia_iowrite16(u16 b, volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	unsigned long w, base_and_type;
@@ -403,7 +403,7 @@
 	*(vuip) ((addr << 5) + base_and_type) = w;
 }
 
-__EXTERN_INLINE unsigned int cia_ioread32(void __iomem *xaddr)
+__EXTERN_INLINE unsigned int cia_ioread32(const volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	if (addr < CIA_DENSE_MEM)
@@ -411,7 +411,7 @@
 	return *(vuip)addr;
 }
 
-__EXTERN_INLINE void cia_iowrite32(u32 b, void __iomem *xaddr)
+__EXTERN_INLINE void cia_iowrite32(u32 b, volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	if (addr < CIA_DENSE_MEM)

------- =_aaaaaaaaaa0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21320.1198987941.3@haddock.cd.chalmers.se>

Signed-off-by: Anders Hammarquist <iko@cd.chalmers.se>

-- 
 -- Of course I'm crazy, but that doesn't mean I'm wrong.
Anders Hammarquist                                  | iko@cd.chalmers.se
Physics student, Chalmers University of Technology, | Hem: +46 31 88 48 50
G|teborg, Sweden.           RADIO: SM6XMM and N2JGL | Mob: +46 707 27 86 87

------- =_aaaaaaaaaa0--

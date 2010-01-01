Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905Ab0AAB0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab0AAB0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 20:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570Ab0AAB0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 20:26:49 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:54046 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0AAB0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 20:26:49 -0500
Date: Thu, 31 Dec 2009 17:26:45 -0800
From: Jun Sun <jsun@junsun.net>
To: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       linux-arm-kernel@lists.infradead.org
Subject: [PATCH] Valid relocation symbol for FLAT format on ARM, v2
Message-ID: <20100101012645.GB16887@Pogoplug>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

See attachment.

Jun

--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="091231-valid-reloc-flat-symbol-arm.patch"


Apparently newer GCC would generate ANCHOR symbols beyond the end of
data/bss segment on ARM CPUs. As a result, the exiting validity checking
for relocation symbols in FLAT format will fail.

Signed-off-by: Jun Sun <jsun@junsun.net>
---

diff -Nru linux-2.6.32.2/arch/arm/include/asm/flat.h.orig linux-2.6.32.2/arch/arm/include/asm/flat.h
--- linux-2.6.32.2/arch/arm/include/asm/flat.h.orig	2009-12-18 14:27:07.000000000 -0800
+++ linux-2.6.32.2/arch/arm/include/asm/flat.h	2009-12-31 17:08:28.000000000 -0800
@@ -7,7 +7,12 @@
 
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
-#define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
+#define	flat_reloc_valid(reloc, size)		((reloc) <= (size) + 0x1000)
+/* [jsun] new gcc 4.x generates ANCHOR symbols in order to reduce the size
+ * of GOT table for PIC code. It is possible the ANCHOR is placed beyond
+ * the end of data/bss segment up to 4K bytes(12 bits), because ARM allows
+ * negative 12-bit offset. Thus we allow 0x1000 extra in reloc address range.
+ */
 #define	flat_get_addr_from_rp(rp, relval, flags, persistent) get_unaligned(rp)
 #define	flat_put_addr_at_rp(rp, val, relval)	put_unaligned(val,rp)
 #define	flat_get_relocate_addr(rel)		(rel)

--LyciRD1jyfeSSjG0--

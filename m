Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbZAUBvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbZAUBvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 20:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZAUBu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 20:50:56 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:48909 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbZAUBuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 20:50:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kiunvYybNaVbWJua3p3FOTkdLC3LHUkAfmcFppZrymPI/I+o6xuOkl7PXdlhFrFHOZ
         bvyXmvEArB9RxgfRBRRdA5puBPjKquzmj6iHs/8tnuSkc1RUhfQAwryfochcJA5jciUw
         v4onK4bdrl0POK45UO+ledLGSbVaWiCPtaCEg=
Subject: [PATCH] m68k{nommu}: fixups after the header move
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: torvalds@linux-foundation.org, arnd@arndb.de, gerg@uclinux.org,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org, sam@ravnborg.org, uclinux-dev@uclinux.org,
       zippel@linux-m68k.org
In-Reply-To: <1232502275.5653.2.camel@brick>
References: <200901210058.n0L0wjdf005545@localhost.localdomain>
	 <1232502275.5653.2.camel@brick>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 17:50:51 -0800
Message-Id: <1232502651.9701.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swab.h seems to have been missed during the header merge.
Add conditionals similar to byteorder.h and remove the
now unnecessary byteorder_no/mm.h

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/m68k/include/asm/byteorder.h    |   11 ++++++-----
 arch/m68k/include/asm/byteorder_mm.h |    6 ------
 arch/m68k/include/asm/byteorder_no.h |    6 ------
 arch/m68k/include/asm/swab.h         |    5 +++++
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/m68k/include/asm/byteorder.h b/arch/m68k/include/asm/byteorder.h
index f20502a..31b260a 100644
--- a/arch/m68k/include/asm/byteorder.h
+++ b/arch/m68k/include/asm/byteorder.h
@@ -1,5 +1,6 @@
-#ifdef __uClinux__
-#include "byteorder_no.h"
-#else
-#include "byteorder_mm.h"
-#endif
+#ifndef _M68K_BYTEORDER_H
+#define _M68K_BYTEORDER_H
+
+#include <linux/byteorder/big_endian.h>
+
+#endif /* _M68K_BYTEORDER_H */
diff --git a/arch/m68k/include/asm/byteorder_mm.h b/arch/m68k/include/asm/byteorder_mm.h
deleted file mode 100644
index 31b260a..0000000
--- a/arch/m68k/include/asm/byteorder_mm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _M68K_BYTEORDER_H
-#define _M68K_BYTEORDER_H
-
-#include <linux/byteorder/big_endian.h>
-
-#endif /* _M68K_BYTEORDER_H */
diff --git a/arch/m68k/include/asm/byteorder_no.h b/arch/m68k/include/asm/byteorder_no.h
deleted file mode 100644
index 9c6c76a..0000000
--- a/arch/m68k/include/asm/byteorder_no.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _M68KNOMMU_BYTEORDER_H
-#define _M68KNOMMU_BYTEORDER_H
-
-#include <linux/byteorder/big_endian.h>
-
-#endif /* _M68KNOMMU_BYTEORDER_H */
diff --git a/arch/m68k/include/asm/swab.h b/arch/m68k/include/asm/swab.h
index e69de29..7d7dde1 100644
--- a/arch/m68k/include/asm/swab.h
+++ b/arch/m68k/include/asm/swab.h
@@ -0,0 +1,5 @@
+#ifdef __uClinux__
+#include "swab_no.h"
+#else
+#include "swab_mm.h"
+#endif
-- 
1.6.1.249.g455e5




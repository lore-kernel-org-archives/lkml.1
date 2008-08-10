Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYHJPuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYHJPuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYHJPtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:49:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:7475 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbYHJPtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=xLj0CUJUaf62oMc9lsw8b9TQ1Gl33GCepRjghIZjRX/x/8tDAYS0FMZdmZSbJSnrcA
         Q8bVLkQp2JJMxex/a9aWroSBLzTJuwryS2xZ7w6X96WprsoAmuUaDmvMqd1DcDIn8lqw
         tkcDWjcig8Op2q1NfVQNCWsyo28M/WRNSiWcI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: fix support for IDE PCI controllers using MMIO on frv
Date: Sun, 10 Aug 2008 17:44:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808101744.31144.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just include <asm-generic/ide_iops.h> for __ide_mm_*() instead of
defining them to normal I/O helpers so PCI bus <-> CPU byte-swapping
is done as needed.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
David, please verify it.  Thanks.

 include/asm-frv/ide.h |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

Index: b/include/asm-frv/ide.h
===================================================================
--- a/include/asm-frv/ide.h
+++ b/include/asm-frv/ide.h
@@ -18,15 +18,7 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-/****************************************************************************/
-/*
- * some bits needed for parts of the IDE subsystem to compile
- */
-#define __ide_mm_insw(port, addr, n)	insw((unsigned long) (port), addr, n)
-#define __ide_mm_insl(port, addr, n)	insl((unsigned long) (port), addr, n)
-#define __ide_mm_outsw(port, addr, n)	outsw((unsigned long) (port), addr, n)
-#define __ide_mm_outsl(port, addr, n)	outsl((unsigned long) (port), addr, n)
-
+#include <asm-generic/ide_iops.h>
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_IDE_H */

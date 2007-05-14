Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbXENOul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbXENOul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 10:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXENOuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 10:50:13 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35254 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbXENOuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 10:50:09 -0400
X-Originating-Ip: 72.143.66.196
Date: Mon, 14 May 2007 10:49:19 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: David Woodhouse <dwmw2@infradead.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] MTD: Remove unused header file include/linux/mtd/jedec.h.
Message-ID: <Pine.LNX.4.64.0705140825370.11197@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the apparently unreferenced header file
include/linux/mtd/jedec.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  this header file *appears* to be unnecessary, but i've been wrong
before.


diff --git a/include/linux/mtd/jedec.h b/include/linux/mtd/jedec.h
deleted file mode 100644
index 9006feb..0000000
--- a/include/linux/mtd/jedec.h
+++ /dev/null
@@ -1,66 +0,0 @@
-
-/* JEDEC Flash Interface.
- * This is an older type of interface for self programming flash. It is
- * commonly use in older AMD chips and is obsolete compared with CFI.
- * It is called JEDEC because the JEDEC association distributes the ID codes
- * for the chips.
- *
- * See the AMD flash databook for information on how to operate the interface.
- *
- * $Id: jedec.h,v 1.4 2005/11/07 11:14:54 gleixner Exp $
- */
-
-#ifndef __LINUX_MTD_JEDEC_H__
-#define __LINUX_MTD_JEDEC_H__
-
-#include <linux/types.h>
-
-#define MAX_JEDEC_CHIPS 16
-
-// Listing of all supported chips and their information
-struct JEDECTable
-{
-   __u16 jedec;
-   char *name;
-   unsigned long size;
-   unsigned long sectorsize;
-   __u32 capabilities;
-};
-
-// JEDEC being 0 is the end of the chip array
-struct jedec_flash_chip
-{
-   __u16 jedec;
-   unsigned long size;
-   unsigned long sectorsize;
-
-   // *(__u8*)(base + (adder << addrshift)) = data << datashift
-   // Address size = size << addrshift
-   unsigned long base;           // Byte 0 of the flash, will be unaligned
-   unsigned int datashift;       // Useful for 32bit/16bit accesses
-   unsigned int addrshift;
-   unsigned long offset;         // linerized start. base==offset for unbanked, uninterleaved flash
-
-   __u32 capabilities;
-
-   // These markers are filled in by the flash_chip_scan function
-   unsigned long start;
-   unsigned long length;
-};
-
-struct jedec_private
-{
-   unsigned long size;         // Total size of all the devices
-
-   /* Bank handling. If sum(bank_fill) == size then this is linear flash.
-      Otherwise the mapping has holes in it. bank_fill may be used to
-      find the holes, but in the common symetric case
-      bank_fill[0] == bank_fill[*], thus addresses may be computed
-      mathmatically. bank_fill must be powers of two */
-   unsigned is_banked;
-   unsigned long bank_fill[MAX_JEDEC_CHIPS];
-
-   struct jedec_flash_chip chips[MAX_JEDEC_CHIPS];
-};
-
-#endif
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

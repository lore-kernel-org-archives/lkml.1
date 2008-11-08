Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbYKHDvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbYKHDvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbYKHDuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:50:44 -0500
Received: from xenotime.net ([72.52.64.118]:47980 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754781AbYKHDul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:50:41 -0500
Date: Fri, 7 Nov 2008 19:50:38 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] MTD: remove excess kernel-doc notation
Message-Id: <20081107195038.ee059fa1.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Delete extra kernel-doc notation for struct fields and function
parameters that don't exist:

Warning(include/linux/mtd/nand.h:428): Excess struct/union/enum/typedef member 'wq' description in 'nand_chip'
Warning(include/linux/mtd/nand.h:428): Excess struct/union/enum/typedef member 'datbuf' description in 'nand_chip'
Warning(include/linux/mtd/nand.h:428): Excess struct/union/enum/typedef member 'oobbuf' description in 'nand_chip'
Warning(include/linux/mtd/nand.h:428): Excess struct/union/enum/typedef member 'oobdirty' description in 'nand_chip'
Warning(include/linux/mtd/nand.h:428): Excess struct/union/enum/typedef member 'data_poi' description in 'nand_chip'
Warning(drivers/mtd/nand/nand_base.c:2527): Excess function parameter 'maxchips' description in 'nand_scan_tail'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/nand/nand_base.c |    1 -
 include/linux/mtd/nand.h     |    5 -----
 2 files changed, 6 deletions(-)

--- linux-2.6.28-rc3-git4.orig/drivers/mtd/nand/nand_base.c
+++ linux-2.6.28-rc3-git4/drivers/mtd/nand/nand_base.c
@@ -2517,7 +2517,6 @@ int nand_scan_ident(struct mtd_info *mtd
 /**
  * nand_scan_tail - [NAND Interface] Scan for the NAND device
  * @mtd:	    MTD device structure
- * @maxchips:	    Number of chips to scan for
  *
  * This is the second phase of the normal nand_scan() function. It
  * fills out all the uninitialized function pointers with the defaults
--- linux-2.6.28-rc3-git4.orig/include/linux/mtd/nand.h
+++ linux-2.6.28-rc3-git4/include/linux/mtd/nand.h
@@ -335,17 +335,12 @@ struct nand_buffers {
  * @erase_cmd:		[INTERN] erase command write function, selectable due to AND support
  * @scan_bbt:		[REPLACEABLE] function to scan bad block table
  * @chip_delay:		[BOARDSPECIFIC] chip dependent delay for transfering data from array to read regs (tR)
- * @wq:			[INTERN] wait queue to sleep on if a NAND operation is in progress
  * @state:		[INTERN] the current state of the NAND device
  * @oob_poi:		poison value buffer
  * @page_shift:		[INTERN] number of address bits in a page (column address bits)
  * @phys_erase_shift:	[INTERN] number of address bits in a physical eraseblock
  * @bbt_erase_shift:	[INTERN] number of address bits in a bbt entry
  * @chip_shift:		[INTERN] number of address bits in one chip
- * @datbuf:		[INTERN] internal buffer for one page + oob
- * @oobbuf:		[INTERN] oob buffer for one eraseblock
- * @oobdirty:		[INTERN] indicates that oob_buf must be reinitialized
- * @data_poi:		[INTERN] pointer to a data buffer
  * @options:		[BOARDSPECIFIC] various chip options. They can partly be set to inform nand_scan about
  *			special functionality. See the defines for further explanation
  * @badblockpos:	[INTERN] position of the bad block marker in the oob area

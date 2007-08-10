Return-Path: <linux-kernel-owner+w=401wt.eu-S934295AbXHJCit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295AbXHJCit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXHJCi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:38:28 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:59608 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbXHJCi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:38:26 -0400
Date: Thu, 9 Aug 2007 22:38:18 -0400
Message-Id: <200708100238.l7A2cIZm024347@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
CC: dwmw2@infradead.org
Subject: JFFS2/mtdsuper modprobe "unknown symbol" in 2.6.23-rc1
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting an error modprobing jffs2 due to mtdsuper failing to insmod:

# modprobe jffs2
WARNING: Error inserting mtdsuper
(/lib/modules/2.6.23-rc1/kernel/drivers/mtd/mtdsuper.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting jffs2
(/lib/modules/2.6.23-rc1/kernel/fs/jffs2/jffs2.ko): Unknown
symbol in module, or unknown parameter (see dmesg)

# dmesg | tail
mtdsuper: Unknown symbol get_mtd_device
mtdsuper: Unknown symbol put_mtd_device
jffs2: Unknown symbol get_sb_mtd
jffs2: Unknown symbol kill_mtd_super

My relevant .config is:

CONFIG_MTD=m
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_BLOCK2MTD=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_CMODE_PRIORITY=y

A "quick hack" around this which I found is to add

  MODULE_LICENSE("GPL");

to the end of drivers/mtd/mtdsuper.c, but that doesn't sound like the right
fix.

Does anyone know what am I missing?

Thanks,
Erez.

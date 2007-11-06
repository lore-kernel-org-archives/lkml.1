Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbXKFO5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbXKFO5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXKFO5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:57:23 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:33380 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXKFO5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:57:21 -0500
Date: Tue, 6 Nov 2007 20:21:19 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       wei.zhang@freescale.com, ebony.zhu@freescale.com,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded - Build Failure at fsldma.c
Message-ID: <20071106145119.GA32391@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The build fails with error

  CC      net/9p/error.o
drivers/dma/fsldma.h:152: error: conflicting types for ‘in_be64’
include/asm/io.h:136: error: previous definition of ‘in_be64’ was here
drivers/dma/fsldma.h:157: error: conflicting types for ‘out_be64’
include/asm/io.h:135: error: previous definition of ‘out_be64’ was here
drivers/dma/fsldma.h:164: error: conflicting types for ‘in_le64’
include/asm/io.h:140: error: previous definition of ‘in_le64’ was here
drivers/dma/fsldma.h:169: error: conflicting types for ‘out_le64’
include/asm/io.h:145: error: previous definition of ‘out_le64’ was here
drivers/dma/fsldma.c:504: error: implicit declaration of function ‘bus_to_virt’
make[2]: *** [drivers/dma/fsldma.o] Error 1
make[1]: *** [drivers/dma] Error 2
make: *** [drivers] Error 2

This error is caused by the patch add-dma-engine-driver-for-freescale-mpc85xx-processors.patch

The following patch solves the conflict types error, but the bus_to_virt
is under the CONFIG_PPC32 ifdef and we had a discuss on the same for the
availability of the function for ppc64 at http://lkml.org/lkml/2007/10/17/524

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.24-rc1/drivers/dma/fsldma.h	2007-11-06 09:12:09.000000000 -0500
+++ linux-2.6.24-rc1/drivers/dma/~fsldma.h	2007-11-06 09:12:31.000000000 -0500
@@ -147,7 +147,7 @@ struct fsl_dma_chan {
 #define to_fsl_desc(lh) container_of(lh, struct fsl_desc_sw, node)
 #define tx_to_fsl_desc(tx) container_of(tx, struct fsl_desc_sw, async_tx)
 
-#ifndef __powerpc64
+#ifndef __powerpc64__
 static u64 in_be64(const u64 __iomem *addr)
 {
 	return ((u64)in_be32((u32 *)addr) << 32) | (in_be32((u32 *)addr + 1));

--
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

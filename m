Return-Path: <linux-kernel-owner+w=401wt.eu-S1030333AbXCPXpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030333AbXCPXpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030343AbXCPXpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:45:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:26828 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030333AbXCPXpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:45:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,293,1170662400"; 
   d="scan'208"; a="59757925:sNHT19291518"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: [PATCH] Linux 2.4.x MTD CFI P30/P33 support
Date: Sat, 17 Mar 2007 02:45:13 +0300
Message-ID: <523F3D8D8C97554AA47E53DF1A05466A666249@nnsmsx411.ccr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Linux 2.4.x MTD CFI P30/P33 support
Thread-Index: AcdoJSPZwyB3ZqstSSWERMkJGJfJQg==
From: "Korolev, Alexey" <alexey.korolev@intel.com>
To: <wtarreau@hera.kernel.org>, "David Woodhouse" <dwmw2@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Mar 2007 23:45:18.0674 (UTC) FILETIME=[275B9320:01C76825]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Willy,

The following patch adds support of P30 and P33 NOR FLASH support in
Linux 2.4
This flash is substitution of J3 flash which is widely used it on Linux
2.4 kernels. Currently many customers wishing to substitute J3 for P3x
face issues on Linux 2.4. This patch resolves issues with P3x on all
generic Linux kernels versions since 2.4.21.

The patch just allows using minor version "4" in CFI driver. Since
differences between CFI minor version "3" and minor version "4" are
small the CFI driver is not affected by this. Patch has been verified on
Mainstone (PXA27x based) platform.

Signed-off-by: Alexey Korolev <alexey.korolev@intel.com>
==================================================
--- a/drivers/mtd/chips/cfi_cmdset_0001.c	2003-06-13
18:51:34.000000000 +0400
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c	2007-02-16
21:39:50.000000000 +0300
@@ -152,7 +152,7 @@
 		}
 		
 		if (extp->MajorVersion != '1' || 
-		    (extp->MinorVersion < '0' || extp->MinorVersion >
'3')) {
+		    (extp->MinorVersion < '0' || extp->MinorVersion >
'4')) {
 			printk(KERN_WARNING "  Unknown IntelExt Extended
Query "
 			       "version %c.%c.\n",  extp->MajorVersion,
 			       extp->MinorVersion);
===================================================

Thanks,
Alexey

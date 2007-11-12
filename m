Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbXKLEzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbXKLEzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 23:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXKLEzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 23:55:25 -0500
Received: from koto.vergenet.net ([210.128.90.7]:33612 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbXKLEzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 23:55:25 -0500
From: Simon Horman <horms@verge.net.au>
To: linux-ia64@vger.kernel.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Vivek Goyal <vgoyal@in.ibm.com>,
       Haren Myneni <hbabu@us.ibm.com>
Subject: [patch] ia64: Guard elfcorehdr_addr with #if CONFIG_PROC_FS
Message-Id: <20071112045521.2BAF54F9EB@tabatha.lab.ultramonkey.org>
Date: Mon, 12 Nov 2007 13:55:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Access to elfcorehdr_addr needs to be guarded by #if CONFIG_PROC_FS
as well as the existing #if guards.

Fixes the following build problem:

arch/ia64/hp/common/built-in.o: In function
`sba_init':arch/ia64/hp/common/sba_iommu.c:2043: undefined reference to `elfcorehdr_addr'
:arch/ia64/hp/common/sba_iommu.c:2043: undefined reference to `elfcorehdr_addr'

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: net-2.6/arch/ia64/hp/common/sba_iommu.c
===================================================================
--- net-2.6.orig/arch/ia64/hp/common/sba_iommu.c	2007-11-12 12:49:23.000000000 +0900
+++ net-2.6/arch/ia64/hp/common/sba_iommu.c	2007-11-12 13:29:07.000000000 +0900
@@ -2034,7 +2034,8 @@ sba_init(void)
 	if (!ia64_platform_is("hpzx1") && !ia64_platform_is("hpzx1_swiotlb"))
 		return 0;
 
-#if defined(CONFIG_IA64_GENERIC) && defined(CONFIG_CRASH_DUMP)
+#if defined(CONFIG_IA64_GENERIC) && defined(CONFIG_CRASH_DUMP) && \
+        defined(CONFIG_PROC_FS)
 	/* If we are booting a kdump kernel, the sba_iommu will
 	 * cause devices that were not shutdown properly to MCA
 	 * as soon as they are turned back on.  Our only option for

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYHNGrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYHNGrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYHNGil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:38:41 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38133 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbYHNGiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:38:00 -0400
Date: Thu, 14 Aug 2008 00:14:38 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6EclT006260@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 22/29] mdb: export kernel_text_address
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export the kernel_text_address() to allow symbol searching and 
matches of symbolic names contained the the kernel symbol table.


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/extable.c	2008-07-13 15:51:29.000000000 -0600
+++ b/kernel/extable.c	2008-08-13 11:56:03.000000000 -0600
@@ -59,6 +59,9 @@
 		return 1;
 	return __module_text_address(addr) != NULL;
 }
+#if defined(CONFIG_MDB_MODULE)
+EXPORT_SYMBOL_GPL(__kernel_text_address);
+#endif
 
 int kernel_text_address(unsigned long addr)
 {

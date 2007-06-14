Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbXFNIJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbXFNIJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 04:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbXFNIIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 04:08:54 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:46940 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbXFNIIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 04:08:53 -0400
Subject: [PATCH]is_power_of_2-ufs/super.c
From: vignesh babu <vignesh.babu@wipro.com>
Reply-To: vignesh.babu@wipro.com
To: daniel.pirkl@email.cz, dushistov@mail.ru
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: WIPRO Technologies
Date: Thu, 14 Jun 2007 13:39:18 +0530
Message-Id: <1181808559.2474.9.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
X-OriginalArrivalTime: 14 Jun 2007 08:08:54.0750 (UTC) FILETIME=[404E9FE0:01C7AE5B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 22ff6ed..2b30116 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -87,6 +87,7 @@
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
+#include <linux/log2.h>
 
 #include "swab.h"
 #include "util.h"
@@ -854,7 +855,7 @@ magic_found:
 	uspi->s_fmask = fs32_to_cpu(sb, usb1->fs_fmask);
 	uspi->s_fshift = fs32_to_cpu(sb, usb1->fs_fshift);
 
-	if (uspi->s_fsize & (uspi->s_fsize - 1)) {
+	if (!is_power_of_2(uspi->s_fsize)) {
 		printk(KERN_ERR "ufs_read_super: fragment size %u is not a power of 2\n",
 			uspi->s_fsize);
 			goto failed;
@@ -869,7 +870,7 @@ magic_found:
 			uspi->s_fsize);
 		goto failed;
 	}
-	if (uspi->s_bsize & (uspi->s_bsize - 1)) {
+	if (!is_power_of_2(uspi->s_bsize)) {
 		printk(KERN_ERR "ufs_read_super: block size %u is not a power of 2\n",
 			uspi->s_bsize);
 		goto failed;

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"


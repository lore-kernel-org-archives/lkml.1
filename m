Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbXJJNfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbXJJNfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 09:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXJJNfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 09:35:23 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:44156 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbXJJNfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 09:35:22 -0400
Date: Wed, 10 Oct 2007 14:35:19 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH] Add assembler equivalents to __init{,date}_refok
Message-ID: <20071010133519.GA6237@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---
I need __INIT_REFOK to fix a MODPOST warning for a few MIPS configs which
have to call init code from .text very early in the game due to bootloader
issues.  __INITDATA_REFOK is just for consistency.

 include/linux/init.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/init.h b/include/linux/init.h
index 74b1f43..031edcc 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -66,8 +66,10 @@
 
 /* For assembly routines */
 #define __INIT		.section	".init.text","ax"
+#define __INIT_REFOK	.section	".text.init.refok","ax"
 #define __FINIT		.previous
 #define __INITDATA	.section	".init.data","aw"
+#define __INITDATA_REFOK .section	".data.init.refok","aw"
 
 #ifndef __ASSEMBLY__
 /*

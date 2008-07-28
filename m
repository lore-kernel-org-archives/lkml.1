Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbYG1FfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbYG1FfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 01:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYG1FfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 01:35:04 -0400
Received: from mo31.po.2iij.net ([210.128.50.54]:12589 "EHLO mo31.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYG1FfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 01:35:01 -0400
Date: Mon, 28 Jul 2008 14:36:27 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] remove EXPORT_SYMBOL for bio_integrity_init_slab()
Message-Id: <20080728143627.2191badd.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got section mismatch message about bio_integrity_init_slab().

WARNING: fs/built-in.o(__ksymtab+0xb60): Section mismatch in reference from the variable __ksymtab_bio_integrity_init_slab to the function .init.text:bio_integrity_init_slab()
The symbol bio_integrity_init_slab is exported and annotated __init
Fix this by removing the __init annotation of bio_integrity_init_slab or drop the export.

It only call from init_bio().
EXPORT_SYMBOL() can be removed.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X /home/yuasa/Memo/dontdiff linux-orig/fs/bio-integrity.c linux/fs/bio-integrity.c
--- linux-orig/fs/bio-integrity.c	2008-07-27 20:19:06.961374681 +0900
+++ linux/fs/bio-integrity.c	2008-07-27 20:52:47.964545089 +0900
@@ -705,7 +705,6 @@ void __init bio_integrity_init_slab(void
 	bio_integrity_slab = KMEM_CACHE(bio_integrity_payload,
 					SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 }
-EXPORT_SYMBOL(bio_integrity_init_slab);
 
 static int __init integrity_init(void)
 {

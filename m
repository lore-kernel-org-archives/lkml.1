Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYC3Pdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYC3Pdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 11:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYC3Pcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 11:32:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:13349 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbYC3Pcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 11:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Eg0fH3UjvwTG0RYRwZ8aVRgQSZ4N9cSs0l9envq+I7GANhi0HXoEERj2zxSXfTbfTYmgyGm5aaV/8vauEWcGEkdQ5C4XKfsLYaPv5eEzN4dgVDQK1+KTqWKBmRwN5tSdbF/P/v5fTNwujI0IQBOaXONoiYDvcRn/siS19on2OWc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/5] ide: make 32-bit I/O support for IDE VLB available only when it makes sense
Date: Sun, 30 Mar 2008 17:12:05 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803301712.05711.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IDE VLB host drivers depend on ISA && (ALPHA || X86 || MIPS) so only then it
makes sense to support "VLB sync" (controlled by SUPPORT_VLB_SYNC define).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -26,10 +26,11 @@
 #include <asm/semaphore.h>
 #include <asm/mutex.h>
 
-#if defined(CONFIG_CRIS) || defined(CONFIG_FRV)
-# define SUPPORT_VLB_SYNC 0
-#else
+#if defined(CONFIG_ISA) && \
+    (defined(CONFIG_ALPHA) || defined(CONFIG_X86) || defined(CONFIG_MIPS))
 # define SUPPORT_VLB_SYNC 1
+#else
+# define SUPPORT_VLB_SYNC 0
 #endif
 
 /*

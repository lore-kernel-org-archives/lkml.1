Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbZCJFRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbZCJFRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZCJFL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:35665 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbZCJFLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CJu5euNNLYI8YsbTxx0uNrQ/PpVuIy6skFE3CDjghJh5dyLWGQ7/wpyStfcDtmdMjo
         LC376KnDcr5M29cMLQcxYk82XWABdUI/8On/x2qYZNhn7vnRIzui18kBot2T59libwTw
         eB1xKVfMY6+4I76DdgSykDNHOUEeVCdj5q7UU=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, chris@zankel.net
Subject: [PATCH 18/25] [xtensa] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:43 -0500
Message-Id: <1236661850-8237-19-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-18-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-17-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-18-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 arch/xtensa/kernel/pci-dma.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/kernel/pci-dma.c b/arch/xtensa/kernel/pci-dma.c
index f5319d7..3677bd0 100644
--- a/arch/xtensa/kernel/pci-dma.c
+++ b/arch/xtensa/kernel/pci-dma.c
@@ -47,10 +47,8 @@ dma_alloc_coherent(struct device *dev,size_t size,dma_addr_t *handle,gfp_t flag)
 
 	/* We currently don't support coherent memory outside KSEG */
 
-	if (ret < XCHAL_KSEG_CACHED_VADDR
-	    || ret >= XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_SIZE)
-		BUG();
-
+	BUG_ON(ret < XCHAL_KSEG_CACHED_VADDR
+	    || ret >= XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_SIZE);
 
 	if (ret != 0) {
 		memset((void*) ret, 0, size);
@@ -67,8 +65,7 @@ void dma_free_coherent(struct device *hwdev, size_t size,
 {
 	long addr=(long)vaddr+XCHAL_KSEG_CACHED_VADDR-XCHAL_KSEG_BYPASS_VADDR;
 
-	if (addr < 0 || addr >= XCHAL_KSEG_SIZE)
-		BUG();
+	BUG_ON(addr < 0 || addr >= XCHAL_KSEG_SIZE);
 
 	free_pages(addr, get_order(size));
 }
-- 
1.6.1.3


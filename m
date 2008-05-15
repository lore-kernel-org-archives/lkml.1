Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbYEOR4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbYEOR4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763178AbYEOR4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:56:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763127AbYEOR4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:56:01 -0400
Message-Id: <20080515175431.059826165@redhat.com>
References: <20080515175357.636334082@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 15 May 2008 13:53:59 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ajackson@redhat.com, airlied@redhat.com,
       benh@kernel.crashing.org
Subject: [patch 2/5] use generic_access_phys for /dev/mem mappings
Content-Disposition: inline; filename=02-devmem-access.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic_access_phys as the access_process_vm access
function for /dev/mem mappings. This makes it possible to
debug the X server.

Signed-off-by: Rik van Riel <riel@redhat.com>

Index: ptrace-2.6.26-rc2-mm1/drivers/char/mem.c
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/drivers/char/mem.c	2008-05-15 13:28:13.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/drivers/char/mem.c	2008-05-15 13:28:41.000000000 -0400
@@ -326,7 +326,8 @@ static void mmap_mem_close(struct vm_are
 
 static struct vm_operations_struct mmap_mem_ops = {
 	.open  = mmap_mem_open,
-	.close = mmap_mem_close
+	.close = mmap_mem_close,
+	.access = generic_access_phys
 };
 
 static int mmap_mem(struct file * file, struct vm_area_struct * vma)

-- 
All Rights Reversed


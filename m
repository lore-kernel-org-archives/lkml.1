Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0CCGxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:53:21 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:43341 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab0CCGxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:53:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VbOy+EAn9ShkSMgLahLISBKSrkNG0pcyJ3V9EP0tEsAw+f724842USVJZJBOr9JUJa
         MUefRiwu/fxUA3U1BFAx7Ms9m0Ex4v3t/ow5wO3yEEg56jSewTFXQKzXAVJdmTenGAj/
         MbvivWQIVddce58kukabm1fqafSP/kV2oi2Ik=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH v2] Staging: dream: pmem: fix some code style issues
Date: Wed,  3 Mar 2010 03:53:11 -0300
Message-Id: <1267599191-10327-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes some code style issues like some braces {} deleted becouse
are not necessary for a single statement blocks and to include KERN_
facility level in the printk() functions.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/dream/pmem.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
index def6468..950b5a1 100644
--- a/drivers/staging/dream/pmem.c
+++ b/drivers/staging/dream/pmem.c
@@ -708,9 +708,8 @@ int get_pmem_addr(struct file *file, unsigned long *start,
 	struct pmem_data *data;
 	int id;
 
-	if (!is_pmem_file(file) || !has_allocation(file)) {
+	if (!is_pmem_file(file) || !has_allocation(file))
 		return -1;
-	}
 
 	data = (struct pmem_data *)file->private_data;
 	if (data->index == -1) {
@@ -789,9 +788,8 @@ void flush_pmem_file(struct file *file, unsigned long offset, unsigned long len)
 	struct list_head *elt;
 	void *flush_start, *flush_end;
 
-	if (!is_pmem_file(file) || !has_allocation(file)) {
+	if (!is_pmem_file(file) || !has_allocation(file))
 		return;
-	}
 
 	id = get_id(file);
 	data = (struct pmem_data *)file->private_data;
@@ -833,7 +831,7 @@ static int pmem_connect(unsigned long connect, struct file *file)
 	src_file = fget_light(connect, &put_needed);
 	DLOG("connect %p to %p\n", file, src_file);
 	if (!src_file) {
-		printk("pmem: src file not found!\n");
+		printk(KERN_ERR "pmem: src file not found!\n");
 		ret = -EINVAL;
 		goto err_no_file;
 	}
@@ -936,8 +934,8 @@ int pmem_remap(struct pmem_region *region, struct file *file,
 	if (unlikely(!PMEM_IS_PAGE_ALIGNED(region->offset) ||
 		 !PMEM_IS_PAGE_ALIGNED(region->len))) {
 #if PMEM_DEBUG
-		printk("pmem: request for unaligned pmem suballocation "
-		       "%lx %lx\n", region->offset, region->len);
+		printk(KERN_DEBUG "pmem: request for unaligned pmem "
+			"suballocation %lx %lx\n", region->offset, region->len);
 #endif
 		return -EINVAL;
 	}
-- 
1.5.6.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751794AbYLWKkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbYLWKkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 05:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYLWKkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 05:40:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:32030 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbYLWKki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 05:40:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HHxN7cwG8yFMK+sgM/a+139/76Olx2U/CLli9pA3Y0eKv0np3OI5ux2QAvNn/+rKYY
         PlTzJyQ92sI/wb8wT0WQUh6U4xru/QhWkrrnWscSzcKJHROQ2xLokv6taBdRFN3gRB8k
         A0EYjk0BU5a6UI9K4gu8XaKPAiVeiULhvt6jI=
Date: Tue, 23 Dec 2008 19:40:18 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Theodore Tso <tytso@mit.edu>, adilger@sun.com,
       linux-ext4@vger.kernel.org
Subject: [PATCH] ext4: annotate unhandled kmem_cache_alloc() error
Message-ID: <20081223104016.GC7217@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_cache_alloc() error in ext4_mb_free_metadata is not handled.
I don't know how to fix it. But I can put BUG_ON to let others
know the problem.

Cc: Theodore Tso <tytso@mit.edu>
Cc: adilger@sun.com
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 fs/ext4/mballoc.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6-rc/fs/ext4/mballoc.c
===================================================================
--- 2.6-rc.orig/fs/ext4/mballoc.c
+++ 2.6-rc/fs/ext4/mballoc.c
@@ -4417,6 +4417,7 @@ ext4_mb_free_metadata(handle_t *handle, 
 	BUG_ON(e4b->bd_buddy_page == NULL);
 
 	new_entry  = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
+	BUG_ON(!new_entry);
 	new_entry->start_blk = block;
 	new_entry->group  = group;
 	new_entry->count = count;

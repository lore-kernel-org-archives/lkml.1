Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZDMD4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZDMD4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZDMD4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:56:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:25235 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbZDMD43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:56:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UTly2/DoVBOY20Kb73jA4Kg5ph8RWzDlkZrDlZh+/3l2hiHpm++GZYk/EsQ5L5DEQ8
         QZjoGG3z9+E8vpeHOqAxBcr2aNSTg9MIGtZBwJkc0ZjUi2Z2du27KpeMrNJA/GCE2ULb
         KKib8W6OinfZpzX+akZPwC5GvJYJOxaVjdQhk=
Date: Mon, 13 Apr 2009 12:56:23 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] hugetlbfs: return negative error code for bad mount option
Message-ID: <20090413035623.GA4156@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following BUG:

# mount -o size=MM -t hugetlbfs none /huge
hugetlbfs: Bad value 'MM' for mount option 'size=MM'
------------[ cut here ]------------
kernel BUG at fs/super.c:996!

Also, remove unused #include <linux/quotaops.h>

Cc: William Irwin <wli@holomorphy.com>
Cc: stable@kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 23a3c76..153d968 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -26,7 +26,6 @@
 #include <linux/pagevec.h>
 #include <linux/parser.h>
 #include <linux/mman.h>
-#include <linux/quotaops.h>
 #include <linux/slab.h>
 #include <linux/dnotify.h>
 #include <linux/statfs.h>
@@ -842,7 +841,7 @@ hugetlbfs_parse_options(char *options, struct hugetlbfs_config *pconfig)
 bad_val:
  	printk(KERN_ERR "hugetlbfs: Bad value '%s' for mount option '%s'\n",
 	       args[0].from, p);
- 	return 1;
+ 	return -EINVAL;
 }
 
 static int

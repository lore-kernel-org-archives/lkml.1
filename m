Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbZDWH7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbZDWH7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbZDWHff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:35:35 -0400
Received: from sous-sol.org ([216.99.217.87]:47436 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757552AbZDWHfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:35:33 -0400
Message-Id: <20090423073118.918243869@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch 097/100] hugetlbfs: return negative error code for bad mount option
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=hugetlbfs-return-negative-error-code-for-bad-mount-option.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Akinobu Mita <akinobu.mita@gmail.com>

upstream commit: c12ddba09394c60e1120e6997794fa6ed52da884

This fixes the following BUG:

  # mount -o size=MM -t hugetlbfs none /huge
  hugetlbfs: Bad value 'MM' for mount option 'size=MM'
  ------------[ cut here ]------------
  kernel BUG at fs/super.c:996!

Due to

	BUG_ON(!mnt->mnt_sb);

in vfs_kern_mount().

Also, remove unused #include <linux/quotaops.h>

Cc: William Irwin <wli@holomorphy.com>
Cc: <stable@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/hugetlbfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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
@@ -842,7 +841,7 @@ hugetlbfs_parse_options(char *options, s
 bad_val:
  	printk(KERN_ERR "hugetlbfs: Bad value '%s' for mount option '%s'\n",
 	       args[0].from, p);
- 	return 1;
+ 	return -EINVAL;
 }
 
 static int


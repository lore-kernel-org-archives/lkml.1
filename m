Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbZD2Wga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbZD2Wga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760243AbZD2WVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:44 -0400
Received: from kroah.org ([198.145.64.141]:40500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760053AbZD2WVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:29 2009
Message-Id: <20090429220928.849214831@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, William Irwin <wli@holomorphy.com>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 39/58] hugetlbfs: return negative error code for bad mount option
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0096-hugetlbfs-return-negative-error-code-for-bad-mount.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
@@ -838,7 +837,7 @@ hugetlbfs_parse_options(char *options, s
 bad_val:
  	printk(KERN_ERR "hugetlbfs: Bad value '%s' for mount option '%s'\n",
 	       args[0].from, p);
- 	return 1;
+ 	return -EINVAL;
 }
 
 static int



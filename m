Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbZIKCdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbZIKCdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 22:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZIKCdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 22:33:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:2578 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZIKCcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 22:32:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,367,1249282800"; 
   d="scan'208";a="186432883"
Message-Id: <20090911023200.518171489@intel.com>
References: <20090911022333.324128054@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 10:23:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Avi Kivity <avi@qumranet.com>, Wu Fengguang <fengguang.wu@intel.com>
cc: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] devmem: remove redundant test on len
Content-Disposition: inline; filename=kmem-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The len test in write_kmem() is always true, so can be reduced.

CC: Marcelo Tosatti <mtosatti@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Johannes Berg <johannes@sipsolutions.net>
CC: Avi Kivity <avi@qumranet.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- linux.orig/drivers/char/mem.c
+++ linux/drivers/char/mem.c
@@ -580,18 +580,16 @@ static ssize_t write_kmem(struct file * 
 		while (count > 0) {
 			int len = count;
 
 			if (len > PAGE_SIZE)
 				len = PAGE_SIZE;
-			if (len) {
-				written = copy_from_user(kbuf, buf, len);
-				if (written) {
-					if (wrote + virtr)
-						break;
-					free_page((unsigned long)kbuf);
-					return -EFAULT;
-				}
+			written = copy_from_user(kbuf, buf, len);
+			if (written) {
+				if (wrote + virtr)
+					break;
+				free_page((unsigned long)kbuf);
+				return -EFAULT;
 			}
 			len = vwrite(kbuf, (char *)p, len);
 			count -= len;
 			buf += len;
 			virtr += len;

-- 


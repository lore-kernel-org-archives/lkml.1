Return-Path: <linux-kernel-owner+w=401wt.eu-S935483AbYD1SX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935483AbYD1SX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936239AbYD1SWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:22:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936379AbYD1SWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:22:38 -0400
Message-Id: <20080428181852.265636540@redhat.com>
References: <20080428181835.502876582@redhat.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 14:18:36 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH -mm 01/15] FYI: vmstats are "off-by-one"
Content-Disposition: inline; filename=hotfix-vmstat-text.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH - add vmstat_test for NR_WRITEBACK_TEMP

Against:  2.6.25-rc8-mm2 [also missing in '.25-mm1]

/proc/vmstat output after "nr_vmscan_write" are off-by-one
because of missing test for NR_WRITEBACK_TEMP added to 
mmzone.h.  Apparently missing from:

	mm-add-nr_writeback_temp-counter.patch

in -mm tree.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

---
Andrew,

you may already have this patch.  I am posting it in this
series to help other testers of the code.

Rik


Rik, Kosaki-san:

Here's a patch that I'm going to post to Andrew and the mailing lists.
I noticed that the noreclaim events were off by one.  Missing
vmstat_text in 25-rc8-mm* and 25-mm1.

I have this in my tree as a 25-*mm* "hotfix"--i.e., before any of our
patches.  It causes a couple of 1 one offsets but no patch conflicts.

Lee


 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.25-rc8-mm2/mm/vmstat.c
===================================================================
--- linux-2.6.25-rc8-mm2.orig/mm/vmstat.c	2008-04-15 12:07:18.000000000 -0400
+++ linux-2.6.25-rc8-mm2/mm/vmstat.c	2008-04-15 12:11:48.000000000 -0400
@@ -699,6 +699,7 @@ static const char * const vmstat_text[] 
 	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
+	"nr_writeback_temp",
 
 #ifdef CONFIG_NUMA
 	"numa_hit",

-- 
All Rights Reversed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbZFKK1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbZFKK1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932407AbZFKK1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:27:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57602 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbZFKK1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:27:19 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH for mmotm 3/5] add Mapped(SwapBacked) field to /proc/meminfo
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090611192114.6D4A.A69D9226@jp.fujitsu.com>
References: <20090611192114.6D4A.A69D9226@jp.fujitsu.com>
Message-Id: <20090611192647.6D53.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 19:27:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] add Mapped(SwapBacked) field to /proc/meminfo

Now, We have NR_SWAP_BACKED_FILE_MAPPED statistics. Thus we can also
display it by /proc/meminfo.


example:

$ cat /proc/meminfo
MemTotal:       32275164 kB
MemFree:        31880212 kB
(snip)
Mapped:            28048 kB
Mapped(SwapBacked):      836 kB

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/proc/meminfo.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/fs/proc/meminfo.c
===================================================================
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -81,6 +81,7 @@ static int meminfo_proc_show(struct seq_
 		"Writeback:      %8lu kB\n"
 		"AnonPages:      %8lu kB\n"
 		"Mapped:         %8lu kB\n"
+		"Mapped(SwapBacked): %8lu kB\n"
 		"Slab:           %8lu kB\n"
 		"SReclaimable:   %8lu kB\n"
 		"SUnreclaim:     %8lu kB\n"
@@ -124,6 +125,7 @@ static int meminfo_proc_show(struct seq_
 		K(global_page_state(NR_WRITEBACK)),
 		K(global_page_state(NR_ANON_PAGES)),
 		K(global_page_state(NR_FILE_MAPPED)),
+		K(global_page_state(NR_SWAP_BACKED_FILE_MAPPED)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),



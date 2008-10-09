Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYJIGjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYJIGjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbYJIGjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:39:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59071 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYJIGjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:39:09 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm 02/Oct PATCH 1/3] adjust Quicklists field of /proc/meminfo
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>, Hugh Dickins <hugh@veritas.com>
Message-Id: <20081009153432.DEC7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  9 Oct 2008 15:39:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


vmscan-split-lru-lists-into-anon-file-sets.patch changed /proc/meminfo output length,
but only Quicklists: field doesn't.
(because quicklists field added after than split-lru)


example: 

$ cat /proc/meminfo

  MemTotal:        7994624 kB
  MemFree:           21376 kB
(snip)
  SUnreclaim:        78912 kB
  PageTables:      1233472 kB
  Quicklists:       7808 kB
  NFS_Unstable:          0 kB


this patch fix it.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 fs/proc/proc_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/proc/proc_misc.c
===================================================================
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -195,7 +195,7 @@ static int meminfo_read_proc(char *page,
 		"SUnreclaim:     %8lu kB\n"
 		"PageTables:     %8lu kB\n"
 #ifdef CONFIG_QUICKLIST
-		"Quicklists:   %8lu kB\n"
+		"Quicklists:     %8lu kB\n"
 #endif
 		"NFS_Unstable:   %8lu kB\n"
 		"Bounce:         %8lu kB\n"




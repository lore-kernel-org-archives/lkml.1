Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbYFRGJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbYFRGJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 02:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbYFRGJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 02:09:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52662 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbYFRGJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 02:09:25 -0400
Date: Wed, 18 Jun 2008 15:08:02 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][-mm] fix incorrect Mlocked field of /proc/meminfo.
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080618150253.37AD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Against: 2.6.26-rc5-mm3

Mlocked field of /proc/meminfo display silly number.
because trivial mistake exist in meminfo_read_proc().



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 fs/proc/proc_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/proc/proc_misc.c
===================================================================
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -216,7 +216,7 @@ static int meminfo_read_proc(char *page,
 		K(pages[LRU_INACTIVE_FILE]),
 #ifdef CONFIG_UNEVICTABLE_LRU
 		K(pages[LRU_UNEVICTABLE]),
-		K(pages[NR_MLOCK]),
+		K(global_page_state(NR_MLOCK)),
 #endif
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),



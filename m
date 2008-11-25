Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbYKYDXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbYKYDXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 22:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbYKYDW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 22:22:57 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43886 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbYKYDW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 22:22:56 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] memcg reclaim shouldn't change zone->recent_rotated statics.
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081125121842.26C5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 12:22:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

this is a trivial bugfix.
I think this is not serious bug.
but if memcgroup reclaim change zone statics, global reclaim can confusion a bit.


================================================
memcg reclaim shouldn't change zone->recent_rotated statics.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c	2008-11-24 06:20:24.000000000 +0900
+++ b/mm/vmscan.c	2008-11-25 01:29:16.000000000 +0900
@@ -1254,7 +1254,8 @@ static void shrink_active_list(unsigned 
 	 * This helps balance scan pressure between file and anonymous
 	 * pages in get_scan_ratio.
 	 */
-	zone->recent_rotated[!!file] += pgmoved;
+	if (scan_global_lru(sc))
+		zone->recent_rotated[!!file] += pgmoved;
 
 	/*
 	 * Move the pages to the [file or anon] inactive list.



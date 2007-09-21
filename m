Return-Path: <linux-kernel-owner+w=401wt.eu-S1765939AbXIUVAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765939AbXIUVAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763520AbXIUUqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:46:08 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34858 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763507AbXIUUqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:46:07 -0400
Date: Fri, 21 Sep 2007 21:45:52 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] LBS: fix hang in isolate_lru_pages
In-Reply-To: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0709212145100.13529@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hang in isolate_lru_pages: remember to increment scan in all cases.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.23-rc6-lbs/mm/vmscan.c	2007-09-11 20:01:08.000000000 +0100
+++ linux/mm/vmscan.c	2007-09-13 16:16:34.000000000 +0100
@@ -704,12 +704,14 @@ static unsigned long isolate_lru_pages(u
 		case -EBUSY:
 			/* else it is being freed elsewhere */
 			list_move(&page->lru, src);
+			scan++;
 			continue;
 
 		default:
 			BUG();
 		}
 
+		scan += pages;
 		if (!order)
 			continue;
 
@@ -755,7 +757,6 @@ static unsigned long isolate_lru_pages(u
 				break;
 			}
 		}
-		scan += pages;
 	}
 
 	*scanned = scan;

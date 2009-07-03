Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbZGCIc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbZGCIc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZGCIcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:32:42 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:10580
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752095AbZGCIcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:32:41 -0400
X-SpamScore: 2
X-BigFish: VPS2(zzzz1202hzz5e7biz32i63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KM76EA-01-IZQ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       stable@kernel.org
Subject: [PATCH 1/2] dma-debug: fix off-by-one error in overlap function
Date: Fri, 3 Jul 2009 10:32:03 +0200
Message-ID: <1246609924-31217-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246609924-31217-1-git-send-email-joerg.roedel@amd.com>
References: <1246609924-31217-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Jul 2009 08:32:08.0269 (UTC) FILETIME=[C0B93FD0:01C9FBB8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in the overlap function which returned true if
one region ends exactly before the second region begins. This is no
overlap but the function returned true in that case.

Cc: stable@kernel.org
Reported-by: Andrew Randrianasulu <randrik@mail.ru>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 3b93129..a9b6b5c 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -862,7 +862,7 @@ static inline bool overlap(void *addr, u64 size, void *start, void *end)
 
 	return ((addr >= start && addr < end) ||
 		(addr2 >= start && addr2 < end) ||
-		((addr < start) && (addr2 >= end)));
+		((addr < start) && (addr2 > end)));
 }
 
 static void check_for_illegal_area(struct device *dev, void *addr, u64 size)
-- 
1.6.3.3



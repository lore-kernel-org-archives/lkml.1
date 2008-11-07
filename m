Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYKGUka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYKGUka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYKGUjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:39:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52184 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbYKGUje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:39:34 -0500
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com, npiggin@suse.de
Subject: [PATCH 2/4] show size of failing allocation
Date: Fri,  7 Nov 2008 20:35:52 -0200
Message-Id: <1226097354-7523-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1226097354-7523-2-git-send-email-glommer@redhat.com>
References: <1226097354-7523-1-git-send-email-glommer@redhat.com>
 <1226097354-7523-2-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if we can't service a vmalloc allocation, show size of
the allocation that actually failed. Useful for
debugging.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 mm/vmalloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 95856d1..7db493d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -381,8 +381,8 @@ found:
 			goto retry;
 		}
 		if (printk_ratelimit())
-			printk(KERN_WARNING "vmap allocation failed: "
-				 "use vmalloc=<size> to increase size.\n");
+			printk(KERN_WARNING "vmap allocation for size %d failed: "
+				 "use vmalloc=<size> to increase size.\n", size);
 		return ERR_PTR(-EBUSY);
 	}
 
-- 
1.5.6.5


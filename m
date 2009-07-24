Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbZGXQMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbZGXQMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZGXQMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:12:35 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51187 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207AbZGXQMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:12:32 -0400
Subject: [PATCH 5/8] kmemleak: Do not report alloc_bootmem blocks as leaks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Fri, 24 Jul 2009 17:12:29 +0100
Message-ID: <20090724161229.5752.74206.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
References: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-9-gd8846
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 16:12:30.0158 (UTC) FILETIME=[8B53C6E0:01CA0C79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets the min_count for alloc_bootmem objects to 0 so that
they are never reported as leaks. This is because many of these blocks
are only referred via the physical address which is not looked up by
kmemleak.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/bootmem.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 701740c..555d5d2 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -521,7 +521,11 @@ find_block:
 		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
 				start_off);
 		memset(region, 0, size);
-		kmemleak_alloc(region, size, 1, 0);
+		/*
+		 * The min_count is set to 0 so that bootmem allocated blocks
+		 * are never reported as leaks.
+		 */
+		kmemleak_alloc(region, size, 0, 0);
 		return region;
 	}
 


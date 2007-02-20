Return-Path: <linux-kernel-owner+w=401wt.eu-S964917AbXBTOTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964917AbXBTOTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964915AbXBTOTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:19:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964917AbXBTOS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:18:59 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] FRV: No ZONE_DMA
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 20 Feb 2007 14:18:49 +0000
Message-ID: <20070220141849.1405.97238.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070220141843.1405.56344.stgit@warthog.cambridge.redhat.com>
References: <20070220141843.1405.56344.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

FRV does not require a ZONE_DMA, so all DMA'able pages that aren't highmem
should be in ZONE_NORMAL.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 arch/frv/mm/init.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index 3f3a0ed..4103c2c 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -126,8 +126,7 @@ void __init paging_init(void)
 
 	/* distribute the allocatable pages across the various zones and pass them to the allocator
 	 */
-	zones_size[ZONE_DMA]     = max_low_pfn - min_low_pfn;
-	zones_size[ZONE_NORMAL]  = 0;
+	zones_size[ZONE_NORMAL]  = max_low_pfn - min_low_pfn;
 #ifdef CONFIG_HIGHMEM
 	zones_size[ZONE_HIGHMEM] = num_physpages - num_mappedpages;
 #endif

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbXEIQZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbXEIQZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbXEIQZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:25:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60801 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbXEIQZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:25:48 -0400
Date: Thu, 10 May 2007 02:25:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: paulus@samba.org, ppc-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] early_pfn_to_nid needs to be __meminit
Message-Id: <20070510022552.4bb1a407.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

since it is referenced by memmap_init_zone (which is __meminit) via the
early_pfn_in_nid macro when CONFIG_NODES_SPAN_OTHER_NODES is set (which
basically means PowerPC 64).

This removes a section mismatch warning in those circumstances.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6fd0b74..3297fa9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2298,7 +2298,7 @@ static int __meminit next_active_region_index_in_nid(int index, int nid)
  * was used and there are no special requirements, this is a convenient
  * alternative
  */
-int __init early_pfn_to_nid(unsigned long pfn)
+int __meminit early_pfn_to_nid(unsigned long pfn)
 {
 	int i;
 
-- 
1.5.1.3


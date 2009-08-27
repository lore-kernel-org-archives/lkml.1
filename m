Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbZH0MKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbZH0MKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZH0MKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:10:45 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:62555 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZH0MKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=rVUS5ivhyACIs1TUqAxHqLx1+ArXVjyStzLmKlwcuGzF3mGxySdkdKaWQRRXKsoLQR
         XM5w2a8ZNfLeiwRom80MZ4Fr7u5F645emyJopJoHsmHJ/npqEB3zJpKKE051YJFRM5zO
         BpCrqGvpaeEI1gg3fTgHWBu9bDWvBwI45SW9c=
Message-ID: <4A9677C1.3090804@gmail.com>
Date: Thu, 27 Aug 2009 20:10:41 +0800
From: Zhu Yanhai <zhu.yanhai@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <wfg@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
       Huang Shijie <shijie8@gmail.com>
CC: linux-kernel@vger.kernel.org, Zhu Yanhai <yanhai.zhu@linux.intel.com>
Subject: [PATCH] Make radix_tree_preload alloc one more slot
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The operations against radix tree always use paths with RADIX_TREE_MAX_PATH
+ 1 slots, but radix_tree_preload only pre-allocs RADIX_TREE_MAX_PATH
slots at present, which causes radix_tree_node_alloc tries to do
kmem_cache_alloc at the last slot even if we don't have gfp_mask &
__GFP_WAIT in hand.

Signed-off-by: Zhu Yanhai <zhu.yanhai@gmail.com>

---
 lib/radix-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 23abbd9..72225a8 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -79,7 +79,7 @@ static struct kmem_cache *radix_tree_node_cachep;
  */
 struct radix_tree_preload {
 	int nr;
-	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH];
+	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH + 1];
 };
 static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
 
-- 
1.6.2.2

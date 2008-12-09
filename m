Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbYLIWOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbYLIWOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYLIWOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:14:10 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:35941 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYLIWOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:14:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=nnYGug2+CFqPm0XXlNBp0dkeC66UP9jya052TaxoYNsV6xOxITTmPuaHHWaVgutopU
         yEia9NqKbPA5BxswfebnCA7dzhptSXGucD4bS6CKMiylbM5pXVQQDogxLassN8e2h4Ly
         WqgaVwMpHvD5+nnGS74Gqj+4namfF6kKhp8Xs=
Message-ID: <493EEDAB.30403@gmail.com>
Date: Tue, 09 Dec 2008 23:14:03 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 27/31] mm: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 mm/memcontrol.c |    3 ++-
 mm/vmscan.c     |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 866dcc7..b2dbba7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -779,7 +779,8 @@ int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
 	return 0;
 }
 
-int mem_cgroup_resize_limit(struct mem_cgroup *memcg, unsigned long long val)
+static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
+		unsigned long long val)
 {
 
 	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 62e7f62..440e2a3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2472,7 +2472,7 @@ void scan_mapping_unevictable_pages(struct address_space *mapping)
  * back onto @zone's unevictable list.
  */
 #define SCAN_UNEVICTABLE_BATCH_SIZE 16UL /* arbitrary lock hold batch size */
-void scan_zone_unevictable_pages(struct zone *zone)
+static void scan_zone_unevictable_pages(struct zone *zone)
 {
 	struct list_head *l_unevictable = &zone->lru[LRU_UNEVICTABLE].list;
 	unsigned long scan;
@@ -2514,7 +2514,7 @@ void scan_zone_unevictable_pages(struct zone *zone)
  * that has possibly/probably made some previously unevictable pages
  * evictable.
  */
-void scan_all_zones_unevictable_pages(void)
+static void scan_all_zones_unevictable_pages(void)
 {
 	struct zone *zone;
 


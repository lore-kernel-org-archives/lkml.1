Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYAZH3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYAZH3c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 02:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYAZH3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 02:29:24 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:34675 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbYAZH3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 02:29:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RHUPoRzhZXKo6Rz8MAnT4glhG0JK+hnZ5gNVjwoH8EBoPCSAywRmxm6i3A4GSnaUOuFn6hmOpZJ7dYseKOUmkStPU5v9mAaI6Ye9ortTg2nZbitBs62VZqInQBU2yeN/7QDgNbXR7YZOCeicPz7AzcnWqvLd5MZ19OfDoXh110k=
Message-ID: <28c262360801252329q7232edc2l2d0e4ed17c054832@mail.gmail.com>
Date: Sat, 26 Jan 2008 02:29:23 -0500
From: "minchan kim" <minchan.kim@gmail.com>
To: akpm@linux-foundation.org
Subject: [PATCH] remove duplicating priority setting in try_to_free_p
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shrink_zones in try_to_free_pages already set zone through
note_zone_scanning_priority.
So, setting prev_priority in try_to_free_pages is needless.

This patch is made by 2.6.24-rc8.

Signed-off-by: barrios <minchan.kim@gmail.com>
---
 mm/vmscan.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e5a9597..fc55c23 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1273,23 +1273,6 @@ unsigned long try_to_free_pages(struct z
    if (!sc.all_unreclaimable)
        ret = 1;
 out:
-   /*
-    * Now that we've scanned all the zones at this priority level, note
-    * that level within the zone so that the next thread which performs
-    * scanning of this zone will immediately start out at this priority
-    * level.  This affects only the decision whether or not to bring
-    * mapped pages onto the inactive list.
-    */
-   if (priority < 0)
-       priority = 0;
-   for (i = 0; zones[i] != NULL; i++) {
-       struct zone *zone = zones[i];
-
-       if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-           continue;
-
-       zone->prev_priority = priority;
-   }
    return ret;
 }


-- 
Kinds regards,
barrios

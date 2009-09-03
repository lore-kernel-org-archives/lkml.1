Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbZICFfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbZICFfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 01:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZICFfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 01:35:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbZICFfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 01:35:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: catalin.marinas@arm.com, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mcgrof@gmail.com,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 1/5] kmemleak: use bool for true/false questions
Date: Thu,  3 Sep 2009 01:35:36 -0400
Message-Id: <1251956140-5499-2-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
In-Reply-To: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 mm/kmemleak.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 4872673..c6e71bb 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -264,17 +264,17 @@ static void kmemleak_disable(void);
  * Newly created objects don't have any color assigned (object->count == -1)
  * before the next memory scan when they become white.
  */
-static int color_white(const struct kmemleak_object *object)
+static bool color_white(const struct kmemleak_object *object)
 {
 	return object->count != -1 && object->count < object->min_count;
 }
 
-static int color_gray(const struct kmemleak_object *object)
+static bool color_gray(const struct kmemleak_object *object)
 {
 	return object->min_count != -1 && object->count >= object->min_count;
 }
 
-static int color_black(const struct kmemleak_object *object)
+static bool color_black(const struct kmemleak_object *object)
 {
 	return object->min_count == -1;
 }
@@ -284,7 +284,7 @@ static int color_black(const struct kmemleak_object *object)
  * not be deleted and have a minimum age to avoid false positives caused by
  * pointers temporarily stored in CPU registers.
  */
-static int unreferenced_object(struct kmemleak_object *object)
+static bool unreferenced_object(struct kmemleak_object *object)
 {
 	return (object->flags & OBJECT_ALLOCATED) && color_white(object) &&
 		time_before_eq(object->jiffies + jiffies_min_age,
-- 
1.6.3.3


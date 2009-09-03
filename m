Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbZICBlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbZICBlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 21:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZICBlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 21:41:03 -0400
Received: from mail.atheros.com ([12.36.123.2]:53913 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbZICBk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 21:40:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>, <penberg@cs.helsinki.fi>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/5] kmemleak: use bool for true/false questions
Date: Wed, 2 Sep 2009 18:40:55 -0700
Message-ID: <1251942059-21448-2-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
References: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S934548AbZIEApE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548AbZIEApE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934486AbZIEAo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:44:57 -0400
Received: from mail.atheros.com ([12.36.123.2]:31875 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934153AbZIEAoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:44:54 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
       <penberg@cs.helsinki.fi>, <mcgrof@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 1/5] kmemleak: use bool for true/false questions
Date: Fri, 4 Sep 2009 17:44:50 -0700
Message-ID: <1252111494-7593-2-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252111494-7593-1-git-send-email-lrodriguez@atheros.com>
References: <1252111494-7593-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 mm/kmemleak.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 401a89a..cde69f5 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -305,17 +305,17 @@ static void hex_dump_object(struct seq_file *seq,
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
@@ -325,7 +325,7 @@ static int color_black(const struct kmemleak_object *object)
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0BAPOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:14:42 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:55475 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab0BAPOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:14:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kGVPxdScNUDHWt6NB7PTh7liWozweLxoAzY8lURyr0cQ/RpoeceZdYi/Dx7SzGyAE3
         EzsoQ50qfuOIKvVjR0bmEyt0inqFGs3JyP8y7SSqTr7ATQJcEG3682nqoFGeptC8oQU0
         SYIs8fXRdaT9ZYgZyYUNw/kpFDyeLxXwlLMmQ=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/9] bitmap: Use for_each_set_bit
Date: Tue,  2 Feb 2010 00:10:35 +0900
Message-Id: <1265037040-23413-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
References: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: rename for_each_bit to for_each_set_bit

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/bitmap.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 11bf497..5f18bb0 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -733,10 +733,9 @@ void bitmap_remap(unsigned long *dst, const unsigned long *src,
 	bitmap_zero(dst, bits);
 
 	w = bitmap_weight(new, bits);
-	for (oldbit = find_first_bit(src, bits);
-	     oldbit < bits;
-	     oldbit = find_next_bit(src, bits, oldbit + 1)) {
+	for_each_set_bit(oldbit, src, bits) {
 	     	int n = bitmap_pos_to_ord(old, oldbit, bits);
+
 		if (n < 0 || w == 0)
 			set_bit(oldbit, dst);	/* identity map */
 		else
@@ -903,9 +902,7 @@ void bitmap_onto(unsigned long *dst, const unsigned long *orig,
 	 */
 
 	m = 0;
-	for (n = find_first_bit(relmap, bits);
-	     n < bits;
-	     n = find_next_bit(relmap, bits, n + 1)) {
+	for_each_set_bit(n, relmap, bits) {
 		/* m == bitmap_pos_to_ord(relmap, n, bits) */
 		if (test_bit(m, orig))
 			set_bit(n, dst);
@@ -934,9 +931,7 @@ void bitmap_fold(unsigned long *dst, const unsigned long *orig,
 		return;
 	bitmap_zero(dst, bits);
 
-	for (oldbit = find_first_bit(orig, bits);
-	     oldbit < bits;
-	     oldbit = find_next_bit(orig, bits, oldbit + 1))
+	for_each_set_bit(oldbit, orig, bits)
 		set_bit(oldbit % sz, dst);
 }
 EXPORT_SYMBOL(bitmap_fold);
-- 
1.6.0.6


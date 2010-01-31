Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907Ab0AaL5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab0AaL5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 06:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351Ab0AaL5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 06:57:09 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:64089 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0AaL5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 06:57:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dVQQQClroTeH5enqwi4e+S1k2UPL6o6uEUD6OeeyumAfGMZCAQ9mQkK2MdosANgPYn
         XqwVyf3J0QhVSrVW/LvrHGLUKsMeWBgqgTFMU1BskiVlUrRiV51m4kEQh69/qmMcU9kY
         pOg7VQEzp7BaRiXrRSJ946vDUGrudvKePxTsI=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/7] bitmap: Use for_each_bit
Date: Sun, 31 Jan 2010 20:53:25 +0900
Message-Id: <1264938810-4173-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
References: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/bitmap.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 11bf497..84292c9 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -733,10 +733,9 @@ void bitmap_remap(unsigned long *dst, const unsigned long *src,
 	bitmap_zero(dst, bits);
 
 	w = bitmap_weight(new, bits);
-	for (oldbit = find_first_bit(src, bits);
-	     oldbit < bits;
-	     oldbit = find_next_bit(src, bits, oldbit + 1)) {
+	for_each_bit(oldbit, src, bits) {
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
+	for_each_bit(n, relmap, bits) {
 		/* m == bitmap_pos_to_ord(relmap, n, bits) */
 		if (test_bit(m, orig))
 			set_bit(n, dst);
@@ -934,9 +931,7 @@ void bitmap_fold(unsigned long *dst, const unsigned long *orig,
 		return;
 	bitmap_zero(dst, bits);
 
-	for (oldbit = find_first_bit(orig, bits);
-	     oldbit < bits;
-	     oldbit = find_next_bit(orig, bits, oldbit + 1))
+	for_each_bit(oldbit, orig, bits)
 		set_bit(oldbit % sz, dst);
 }
 EXPORT_SYMBOL(bitmap_fold);
-- 
1.6.0.6


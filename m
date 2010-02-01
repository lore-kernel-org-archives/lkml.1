Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab0BAPOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:14:30 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:55475 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0BAPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:14:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G+3naHSrVN1F3B1boyfMbOwrUsEpR3zBfFg1SiAiPmZL9VOFan6Pw6KmHFbcIgy4i7
         llSi7sp+8t+nNmBRLoTcAP2LiivLcWeJg2dFFJKff3SnKgZ2vIndDioD3rk9ZZZmy6Zl
         V/Gtr6P/IbBxO1kaxOWeX4hcPyIFlu1KslppY=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jack Steiner <steiner@sgi.com>
Subject: [PATCH 2/9] sgi-gru: Use for_each_set_bit
Date: Tue,  2 Feb 2010 00:10:33 +0900
Message-Id: <1265037040-23413-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
References: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jack Steiner <steiner@sgi.com>
---
 drivers/misc/sgi-gru/grutables.h |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/sgi-gru/grutables.h b/drivers/misc/sgi-gru/grutables.h
index 02a77b8..7a8b906 100644
--- a/drivers/misc/sgi-gru/grutables.h
+++ b/drivers/misc/sgi-gru/grutables.h
@@ -516,8 +516,7 @@ struct gru_blade_state {
 
 /* Scan all active GRUs in a GRU bitmap */
 #define for_each_gru_in_bitmap(gid, map)				\
-	for ((gid) = find_first_bit((map), GRU_MAX_GRUS); (gid) < GRU_MAX_GRUS;\
-		(gid)++, (gid) = find_next_bit((map), GRU_MAX_GRUS, (gid)))
+	for_each_set_bit((gid), (map), GRU_MAX_GRUS)
 
 /* Scan all active GRUs on a specific blade */
 #define for_each_gru_on_blade(gru, nid, i)				\
@@ -536,23 +535,17 @@ struct gru_blade_state {
 
 /* Scan each CBR whose bit is set in a TFM (or copy of) */
 #define for_each_cbr_in_tfm(i, map)					\
-	for ((i) = find_first_bit(map, GRU_NUM_CBE);			\
-			(i) < GRU_NUM_CBE;				\
-			(i)++, (i) = find_next_bit(map, GRU_NUM_CBE, i))
+	for_each_set_bit((i), (map), GRU_NUM_CBE)
 
 /* Scan each CBR in a CBR bitmap. Note: multiple CBRs in an allocation unit */
 #define for_each_cbr_in_allocation_map(i, map, k)			\
-	for ((k) = find_first_bit(map, GRU_CBR_AU); (k) < GRU_CBR_AU;	\
-			(k) = find_next_bit(map, GRU_CBR_AU, (k) + 1)) 	\
+	for_each_set_bit((k), (map), GRU_CBR_AU)			\
 		for ((i) = (k)*GRU_CBR_AU_SIZE;				\
 				(i) < ((k) + 1) * GRU_CBR_AU_SIZE; (i)++)
 
 /* Scan each DSR in a DSR bitmap. Note: multiple DSRs in an allocation unit */
 #define for_each_dsr_in_allocation_map(i, map, k)			\
-	for ((k) = find_first_bit((const unsigned long *)map, GRU_DSR_AU);\
-			(k) < GRU_DSR_AU;				\
-			(k) = find_next_bit((const unsigned long *)map,	\
-					  GRU_DSR_AU, (k) + 1))		\
+	for_each_set_bit((k), (const unsigned long *)(map), GRU_DSR_AU)	\
 		for ((i) = (k) * GRU_DSR_AU_CL;				\
 				(i) < ((k) + 1) * GRU_DSR_AU_CL; (i)++)
 
-- 
1.6.0.6


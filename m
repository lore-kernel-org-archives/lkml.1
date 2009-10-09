Return-Path: <linux-kernel-owner+w=401wt.eu-S1760314AbZJIIhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314AbZJIIhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760258AbZJIIhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:37:54 -0400
Received: from mail-yw0-f182.google.com ([209.85.211.182]:35230 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbZJIIhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Kq6GsfAncPRiKXYwxL51gfDM/eg156br5EruJF2rzNoi5Y7ktNYAc4LUWy15nN8GNl
         XN2XXXQV73HouzBqD4iqFkI5H0YGuj7sfZ4cW8wDOQ5hmT9N7a6cBgAordfGyAh7bI92
         gPJssgxRDVhljzEgxKZKAI6qW9HVA/LxG7FbY=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/8] iommu-helper: Simplify find_next_zero_area
Date: Fri,  9 Oct 2009 17:29:14 +0900
Message-Id: <1255076961-21325-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use find_next_bit instead of doing test_bit for each bit

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/iommu-helper.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index 75dbda0..dddbf22 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -21,11 +21,10 @@ again:
 	end = index + nr;
 	if (end >= size)
 		return -1;
-	for (i = index; i < end; i++) {
-		if (test_bit(i, map)) {
-			start = i+1;
-			goto again;
-		}
+	i = find_next_bit(map, end, index);
+	if (i < end) {
+		start = i + 1;
+		goto again;
 	}
 	return index;
 }
-- 
1.5.4.3


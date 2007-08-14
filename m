Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbXHNVmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbXHNVmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXHNVZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:25:42 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38470 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757086AbXHNVZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:25:39 -0400
Date: Tue, 14 Aug 2007 23:25:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb/bt8xx: "extern inline" -> "static inline"
Message-ID: <20070814212530.GS18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"extern inline" will have different semantics with gcc 4.3.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6ffbe5b19606cd8756be4d04e0902de69e447c85 
diff --git a/drivers/media/dvb/bt8xx/bt878.h b/drivers/media/dvb/bt8xx/bt878.h
index f685bc1..1c8e336 100644
--- a/drivers/media/dvb/bt8xx/bt878.h
+++ b/drivers/media/dvb/bt8xx/bt878.h
@@ -149,7 +149,7 @@ void bt878_start(struct bt878 *bt, u32 controlreg, u32 op_sync_orin,
 void bt878_stop(struct bt878 *bt);
 
 #if defined(__powerpc__)	/* big-endian */
-extern __inline__ void io_st_le32(volatile unsigned __iomem *addr, unsigned val)
+static inline void io_st_le32(volatile unsigned __iomem *addr, unsigned val)
 {
 	__asm__ __volatile__("stwbrx %1,0,%2":"=m"(*addr):"r"(val),
 			     "r"(addr));


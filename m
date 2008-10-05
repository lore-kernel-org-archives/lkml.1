Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYJETV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYJETV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbYJETVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:21:20 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:36764 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbYJETVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:21:19 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alex Raimondi <raimondi@miromico.ch>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] Change comment in include linux/clk.h
Date: Sun,  5 Oct 2008 21:20:38 +0200
Message-Id: <1223234438-28004-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 05 Oct 2008 19:20:23.0382 (UTC) FILETIME=[6A123F60:01C9271F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Raimondi <raimondi@miromico.ch>

clk_get and clk_put may not be used from within interrupt
context. Change comment to this function.

Signed-off-by: Alex Raimondi <raimondi@miromico.ch>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
I see several ARM implementation using mutexes for locking in these
functions. So I assume we never want to call them from interrupt
context, right?

 include/linux/clk.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index 5ca8c6f..7787773 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -35,6 +35,8 @@ struct clk;
  * clk_get may return different clock producers depending on @dev.)
  *
  * Drivers must assume that the clock source is not enabled.
+ *
+ * clk_get should not be called from within interrupt context.
  */
 struct clk *clk_get(struct device *dev, const char *id);
 
@@ -76,6 +78,8 @@ unsigned long clk_get_rate(struct clk *clk);
  * Note: drivers must ensure that all clk_enable calls made on this
  * clock source are balanced by clk_disable calls prior to calling
  * this function.
+ *
+ * clk_put should not be called from within interrupt context.
  */
 void clk_put(struct clk *clk);
 
-- 
1.5.6.5


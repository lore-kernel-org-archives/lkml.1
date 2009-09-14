Return-Path: <linux-kernel-owner+w=401wt.eu-S933693AbZINUOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbZINUOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933638AbZINUI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54112 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933597AbZINUIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:49 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH 43/72] Blackfin: fix read buffer overflow
Date: Mon, 14 Sep 2009 16:07:47 -0400
Message-Id: <1252958896-25150-44-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/bfin_dma_5xx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 14dea1a..384868d 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -147,8 +147,8 @@ EXPORT_SYMBOL(request_dma);
 
 int set_dma_callback(unsigned int channel, irq_handler_t callback, void *data)
 {
-	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_DMA_CHANNELS));
+	BUG_ON(channel >= MAX_DMA_CHANNELS ||
+			dma_ch[channel].chan_status == DMA_CHANNEL_FREE);
 
 	if (callback != NULL) {
 		int ret;
@@ -182,8 +182,8 @@ static void clear_dma_buffer(unsigned int channel)
 void free_dma(unsigned int channel)
 {
 	pr_debug("freedma() : BEGIN \n");
-	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_DMA_CHANNELS));
+	BUG_ON(channel >= MAX_DMA_CHANNELS ||
+			dma_ch[channel].chan_status == DMA_CHANNEL_FREE);
 
 	/* Halt the DMA */
 	disable_dma(channel);
-- 
1.6.4.2


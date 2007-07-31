Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbXGaSDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbXGaSDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765153AbXGaSDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:03:17 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3454 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764865AbXGaSDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:03:15 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: PATCH 32] drivers/mtd/inftlmount.c: kmalloc + memset conversion to kcalloc
Date: Tue, 31 Jul 2007 20:03:14 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       dwmw2@infradead.org, linux-mtd@lists.infradead.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312003.15009.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/mtd/inftlmount.c | 23841 -> 23803 (-38 bytes)
 drivers/mtd/inftlmount.o | 47196 -> 46956 (-240 bytes)

 drivers/mtd/inftlmount.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/mtd/inftlmount.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/mtd/inftlmount.c	2007-07-31 11:40:20.000000000 +0200
@@ -580,14 +580,13 @@ int INFTL_mount(struct INFTLrecord *s)
 	logical_block = block = BLOCK_NIL;

 	/* Temporary buffer to store ANAC numbers. */
-	ANACtable = kmalloc(s->nb_blocks * sizeof(u8), GFP_KERNEL);
+	ANACtable = kcalloc(s->nb_blocks, sizeof(u8), GFP_KERNEL);
 	if (!ANACtable) {
 		printk(KERN_WARNING "INFTL: allocation of ANACtable "
 				"failed (%zd bytes)\n",
 				s->nb_blocks * sizeof(u8));
 		return -ENOMEM;
 	}
-	memset(ANACtable, 0, s->nb_blocks);

 	/*
 	 * First pass is to explore each physical unit, and construct the

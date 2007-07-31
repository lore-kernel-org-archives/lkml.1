Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbXGaR6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbXGaR6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761653AbXGaR6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:58:22 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4488 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760506AbXGaR6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:58:21 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 30] drivers/ide/arm/icside.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:58:20 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rmk@arm.linux.org.uk
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311958.20683.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is this a bug? In original verison memset cleared sizeof(state) bytes
instead of sizeof(*state). If it was intentional then this patch is invalid.
If not intentional -> valid :) Please review.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/ide/arm/icside.c | 18883 -> 18849 (-34 bytes)

 drivers/ide/arm/icside.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/ide/arm/icside.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/ide/arm/icside.c	2007-07-31 11:32:27.000000000 +0200
@@ -682,13 +682,12 @@ icside_probe(struct expansion_card *ec,
 	if (ret)
 		goto out;

-	state = kmalloc(sizeof(struct icside_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct icside_state), GFP_KERNEL);
 	if (!state) {
 		ret = -ENOMEM;
 		goto release;
 	}

-	memset(state, 0, sizeof(state));
 	state->type	= ICS_TYPE_NOTYPE;
 	state->dev	= &ec->dev;


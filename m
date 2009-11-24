Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbZKXI3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbZKXI3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932200AbZKXI3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:29:36 -0500
Received: from compulab.co.il ([67.18.134.219]:47096 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbZKXI3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:29:36 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] backlight: tdo24m: ensure chip select changes between transfers
Date: Tue, 24 Nov 2009 10:25:33 +0200
Message-Id: <1259051133-7911-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.6.4.4
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SPI host drivers do not change chip select betwen transfers unless
.cs_chnage field is explicitly set. The LCD spec requires chip select
change between consecuitive transfers, so ensure it at the SPI driver
level.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/video/backlight/tdo24m.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index bbfb502..4a3d46e 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -367,6 +367,7 @@ static int __devinit tdo24m_probe(struct spi_device *spi)
 
 	spi_message_init(m);
 
+	x->cs_change = 1;
 	x->tx_buf = &lcd->buf[0];
 	spi_message_add_tail(x, m);
 
-- 
1.6.4.4


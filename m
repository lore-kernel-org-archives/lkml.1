Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYDQEId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYDQEId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbYDQEIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:08:25 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:52324 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYDQEIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:08:25 -0400
Message-ID: <4806CD35.5020704@tiscali.nl>
Date: Thu, 17 Apr 2008 06:08:21 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] mcp23s08: check read_regs() retval
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of mcp23s08_read_regs() can only be evaluated when signed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/mcp23s08.c
index bb60e8c..0eef8b8 100644
--- a/drivers/gpio/mcp23s08.c
+++ b/drivers/gpio/mcp23s08.c
@@ -168,7 +168,7 @@ static void mcp23s08_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
 	struct mcp23s08	*mcp;
 	char		bank;
-	unsigned	t;
+	int		t;
 	unsigned	mask;
 
 	mcp = container_of(chip, struct mcp23s08, chip);

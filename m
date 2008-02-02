Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYBBMD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYBBMD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 07:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYBBMDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 07:03:48 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51273 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbYBBMDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 07:03:47 -0500
Date: Sat, 2 Feb 2008 23:03:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [SH] remove unneeded cast
Message-Id: <20080202230347.a126a143.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

now that platform_device_register_simple() takes a "const chat *".

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sh/drivers/dma/dma-api.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

This hasn't even been built, but is straight forward.

diff --git a/arch/sh/drivers/dma/dma-api.c b/arch/sh/drivers/dma/dma-api.c
index 76ed816..727126e 100644
--- a/arch/sh/drivers/dma/dma-api.c
+++ b/arch/sh/drivers/dma/dma-api.c
@@ -350,7 +350,7 @@ int register_dmac(struct dma_info *info)
 
 	BUG_ON((info->flags & DMAC_CHANNELS_CONFIGURED) && !info->channels);
 
-	info->pdev = platform_device_register_simple((char *)info->name, -1,
+	info->pdev = platform_device_register_simple(info->name, -1,
 						     NULL, 0);
 	if (IS_ERR(info->pdev))
 		return PTR_ERR(info->pdev);
-- 
1.5.3.8



-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

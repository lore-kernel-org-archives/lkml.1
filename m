Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZDUBMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZDUBMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbZDUBL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:11:27 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:42821 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbZDUBLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:11:23 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, gregkh@suse.de, kay.sievers@vrfy.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 4/4] ARM: use put_device instead of kfree
Date: Mon, 20 Apr 2009 21:17:16 -0300
Message-Id: <7fac8c08bd1ae80bd013ea0fbf74142e78b51191.1240272929.git.cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <144d7cc77af406a1da178a50d9bc0b87b41d2884.1240272929.git.cascardo@holoscopio.com>
References: <1240273036-5995-1-git-send-email-cascardo@holoscopio.com>
 <2289cd3dcbe25046472d90cd0b25e57fbef92dc1.1240272929.git.cascardo@holoscopio.com>
 <9027a3b74e49f79b7138880e2cffd9bc2947ca21.1240272929.git.cascardo@holoscopio.com>
 <144d7cc77af406a1da178a50d9bc0b87b41d2884.1240272929.git.cascardo@holoscopio.com>
In-Reply-To: <cover.1240272928.git.cascardo@holoscopio.com>
References: <cover.1240272928.git.cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it's not possible to allocate resources for the device, it's better
to call put_device, which will release the device name, instead of
oops'ing with a dev_set_name(&dev, NULL).

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 arch/arm/common/sa1111.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index ef12794..8e17608 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -568,8 +568,7 @@ sa1111_init_one_child(struct sa1111 *sachip, struct resource *parent,
 	if (ret) {
 		printk("SA1111: failed to allocate resource for %s\n",
 			dev->res.name);
-		dev_set_name(&dev->dev, NULL);
-		kfree(dev);
+		put_device(&dev->dev);
 		goto out;
 	}
 
-- 
1.6.2.3


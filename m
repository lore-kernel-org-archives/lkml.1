Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbZINUIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbZINUIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933556AbZINUIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54098 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933571AbZINUIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:45 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH 38/72] Blackfin: bf537-stamp: drop ATA interrupt probe workaround
Date: Mon, 14 Sep 2009 16:07:42 -0400
Message-Id: <1252958896-25150-39-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

The interrupt probe workaround doesn't work without hacks to common code,
and the add-on card only needs a simple resistor to fix the problem, so
drop the board-specific hack.

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf537/boards/stamp.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index e5fffe7..192e34e 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1728,11 +1728,6 @@ static int __init stamp_init(void)
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
-#if (defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)) \
-	 && defined(PATA_INT)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
-#endif
-
 	return 0;
 }
 
-- 
1.6.4.2


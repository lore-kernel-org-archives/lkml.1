Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbYGQNpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbYGQNpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbYGQNp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:45:28 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36539 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839AbYGQNp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:45:27 -0400
Date: Thu, 17 Jul 2008 16:45:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix avr32 build errors
Message-ID: <20080717134511.GA18502@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7d2be0749a59096a334c94dc48f43294193cb8ed
(atmel-mci: Driver for Atmel on-chip MMC controllers)
causes build errors like:

<--  snip  -->

...
  CC      arch/avr32/boards/atstk1000/atstk1003.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/avr32/boards/atstk1000/atstk1003.c: In function 'atstk1003_init':
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/avr32/boards/atstk1000/atstk1003.c:157: error: too few arguments to function 'at32_add_device_mci'
make[2]: *** [arch/avr32/boards/atstk1000/atstk1003.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/avr32/boards/atstk1000/atstk1003.c |    2 +-
 arch/avr32/boards/atstk1000/atstk1004.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

fb234419ed2174f7cf658da91ee385891ad7b3eb 
diff --git a/arch/avr32/boards/atstk1000/atstk1003.c b/arch/avr32/boards/atstk1000/atstk1003.c
index ea109f4..591fc73 100644
--- a/arch/avr32/boards/atstk1000/atstk1003.c
+++ b/arch/avr32/boards/atstk1000/atstk1003.c
@@ -154,7 +154,7 @@ static int __init atstk1003_init(void)
 	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
 #endif
 #ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
-	at32_add_device_mci(0);
+	at32_add_device_mci(0, NULL);
 #endif
 	at32_add_device_usba(0, NULL);
 #ifndef CONFIG_BOARD_ATSTK100X_SW3_CUSTOM
diff --git a/arch/avr32/boards/atstk1000/atstk1004.c b/arch/avr32/boards/atstk1000/atstk1004.c
index c7236df..d9c5e0a 100644
--- a/arch/avr32/boards/atstk1000/atstk1004.c
+++ b/arch/avr32/boards/atstk1000/atstk1004.c
@@ -137,7 +137,7 @@ static int __init atstk1004_init(void)
 	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
 #endif
 #ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
-	at32_add_device_mci(0);
+	at32_add_device_mci(0, NULL);
 #endif
 	at32_add_device_lcdc(0, &atstk1000_lcdc_data,
 			     fbmem_start, fbmem_size, 0);


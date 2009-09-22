Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbZIVPE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbZIVPE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZIVPEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:04:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:34452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbZIVPEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:04:25 -0400
Subject: [PATCH] STAGING: Remove dead code rtl8192e, ieee80211_crypt_wep.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>, Anthony Wong <awong1@novell.com>,
       Staging <devel@driverdev.osuosl.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:34:24 +0530
Message-Id: <1253631864.3784.38.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove dead code from drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c

This also fixed following 'make includecheck' warnings:

  drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c: rtl_crypto.h is included more than once.
  drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c: linux/crypto.h is included more than once.
  drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c: asm/scatterlist.h is included more than once.
  drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c: linux/crc32.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 .../rtl8192e/ieee80211/ieee80211_crypt_wep.c       |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
index 5678313..5289c27 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
@@ -9,7 +9,6 @@
  * more details.
  */
 
-//#include <linux/config.h>
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -32,19 +31,8 @@
 #else
     #include <linux/scatterlist.h>
 #endif
-//#include <asm/scatterlist.h>
 #include <linux/crc32.h>
-//
-/*
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#include "rtl_crypto.h"
-#else
-#include <linux/crypto.h>
-#endif
 
-#include <asm/scatterlist.h>
-#include <linux/crc32.h>
-*/
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP crypt: WEP");
 MODULE_LICENSE("GPL");
@@ -380,14 +368,9 @@ void __exit ieee80211_crypto_wep_exit(void)
 
 void ieee80211_wep_null(void)
 {
-//	printk("============>%s()\n", __FUNCTION__);
         return;
 }
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-//EXPORT_SYMBOL(ieee80211_wep_null);
 #else
 EXPORT_SYMBOL_NOVERS(ieee80211_wep_null);
 #endif
-
-//module_init(ieee80211_crypto_wep_init);
-//module_exit(ieee80211_crypto_wep_exit);
-- 
1.6.0.6



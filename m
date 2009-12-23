Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZLWI6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZLWI6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbZLWI5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:57:36 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:58849 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbZLWI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:57:32 -0500
Message-Id: <20091223085552.784470965@vergenet.net>
User-Agent: quilt/0.48-1
Date: Wed, 23 Dec 2009 19:54:52 +1100
Subject: [patch 4/7] [patch] rtl8192e: print the elements of tx_pn and rx_pn not the arrays themselves
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: Simon Horman <horms@verge.net.au>
References: <20091223085448.619253793@vergenet.net>
Content-Disposition: inline; filename=rtl8192e-printk-array.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Simon Horman <horms@verge.net.au>

--- 

Compile tested only

$ gcc --versino
gcc (Debian 4.4.2-6) 4.4.2
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ make
...
drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c: In function ‘ieee80211_ccmp_print_stats’:
drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c:486: warning: format ‘%02x’ expects type ‘unsigned int’, but argument 5 has type ‘u8 *’
drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c:486: warning: format ‘%02x’ expects type ‘unsigned int’, but argument 6 has type ‘u8 *’
drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c:486: warning: too few arguments for format

Index: gregkh-2.6/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
===================================================================
--- gregkh-2.6.orig/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c	2009-12-23 18:39:52.000000000 +1100
+++ gregkh-2.6/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c	2009-12-23 19:35:07.000000000 +1100
@@ -475,12 +475,19 @@ static int ieee80211_ccmp_get_key(void *
 static char * ieee80211_ccmp_print_stats(char *p, void *priv)
 {
 	struct ieee80211_ccmp_data *ccmp = priv;
-	p += sprintf(p, "key[%d] alg=CCMP key_set=%d "
-		     "tx_pn=%02x%02x%02x%02x%02x%02x "
-		     "rx_pn=%02x%02x%02x%02x%02x%02x "
-		     "format_errors=%d replays=%d decrypt_errors=%d\n",
-		     ccmp->key_idx, ccmp->key_set,
-		     ccmp->tx_pn, ccmp->rx_pn,
+	int i;
+
+	p += sprintf(p, "key[%d] alg=CCMP key_set=%d tx_pn=",
+		     ccmp->key_idx, ccmp->key_set);
+
+	for (i = 0; i < ARRAY_SIZE(ccmp->tx_pn); i++)
+		p += sprintf(p, "%02x", ccmp->tx_pn[i]);
+
+	sprintf(p, " rx_pn=");
+	for (i = 0; i < ARRAY_SIZE(ccmp->rx_pn); i++)
+		p += sprintf(p, "%02x", ccmp->tx_pn[i]);
+
+	p += sprintf(p, " format_errors=%d replays=%d decrypt_errors=%d\n",
 		     ccmp->dot11RSNAStatsCCMPFormatErrors,
 		     ccmp->dot11RSNAStatsCCMPReplays,
 		     ccmp->dot11RSNAStatsCCMPDecryptErrors);


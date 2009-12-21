Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbZLUEHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbZLUEHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 23:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZLUEHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 23:07:53 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:46399 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZLUEHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 23:07:52 -0500
Date: Mon, 21 Dec 2009 15:07:50 +1100
From: Simon Horman <horms@verge.net.au>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch] rtl8192su: Use z format qualifier for output of sizeof()
Message-ID: <20091221040750.GB22636@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ gcc --version
gcc (Debian 4.4.2-5) 4.4.2
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ make
...
drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c: In function ‘ieee80211_rx_ADDBAReq’:
drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c:342: warning: format ‘%ld’ expects type ‘long int’, but argument 3 has type ‘unsigned int’
drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c: In function ‘ieee80211_rx_ADDBARsp’:
drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c:443: warning: format ‘%ld’ expects type ‘long int’, but argument 3 has type ‘unsigned int’
drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c: In function ‘ieee80211_rx_DELBA’:
drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c:573: warning: format ‘%ld’ expects type ‘long int’, but argument 3 has type ‘unsigned int’
...

Also some style fixes for these lines:
+ Fix excessively long lines
+ Remove leading space before struct
+ Remove unnecessary parentheses

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c	2009-12-21 14:52:54.000000000 +1100
+++ linux-2.6/drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c	2009-12-21 14:59:53.000000000 +1100
@@ -339,7 +339,10 @@ int ieee80211_rx_ADDBAReq( struct ieee80
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BAREQ(%d / %ld)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR,
+				" Invalid skb len in BAREQ(%d / %zd)\n",
+				skb->len,
+				sizeof(struct ieee80211_hdr_3addr) + 9);
 		return -1;
 	}
 
@@ -440,7 +443,10 @@ int ieee80211_rx_ADDBARsp( struct ieee80
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BARSP(%d / %ld)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR,
+				" Invalid skb len in BARSP(%d / %zd)\n",
+				skb->len,
+				sizeof(struct ieee80211_hdr_3addr) + 9);
 		return -1;
 	}
 	rsp = ( struct ieee80211_hdr_3addr*)skb->data;
@@ -570,7 +576,10 @@ int ieee80211_rx_DELBA(struct ieee80211_
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 6)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in DELBA(%d / %ld)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 6));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR,
+				" Invalid skb len in DELBA(%d / %zd)\n",
+				skb->len,
+				sizeof(struct ieee80211_hdr_3addr) + 6);
 		return -1;
 	}
 

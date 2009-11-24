Return-Path: <linux-kernel-owner+w=401wt.eu-S934201AbZKXVOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201AbZKXVOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933920AbZKXVOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:14:04 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:50185 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934196AbZKXVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:14:01 -0500
Message-ID: <4B0C3E83.3060401@oracle.com>
Date: Tue, 24 Nov 2009 12:13:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH -next] staging/rtl8192x: fix printk formats
References: <20091124212255.87e083ce.sfr@canb.auug.org.au>
In-Reply-To: <20091124212255.87e083ce.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B0C4C94.00DE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in rtl8192[eu]:

drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c:979: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/rtl8192e/ieee80211/rtl819x_BAProc.c:385: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
drivers/staging/rtl8192e/ieee80211/rtl819x_BAProc.c:484: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
drivers/staging/rtl8192e/ieee80211/rtl819x_BAProc.c:614: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c:848: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c:343: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c:442: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c:572: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c   |    2 +-
 drivers/staging/rtl8192e/ieee80211/rtl819x_BAProc.c |    6 +++---
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c   |    2 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c |    6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

--- linux-next-20091124.orig/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
+++ linux-next-20091124/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
@@ -976,7 +976,7 @@ int ieee80211_wx_set_gen_ie(struct ieee8
 	{
 		if (len != ie[1]+2)
 		{
-			printk("len:%d, ie:%d\n", len, ie[1]);
+			printk("len:%zu, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
 		buf = kmalloc(len, GFP_KERNEL);
--- linux-next-20091124.orig/drivers/staging/rtl8192e/ieee80211/rtl819x_BAProc.c
+++ linux-next-20091124/drivers/staging/rtl8192e/ieee80211/rtl819x_BAProc.c
@@ -382,7 +382,7 @@ int ieee80211_rx_ADDBAReq( struct ieee80
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BAREQ(%d / %d)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BAREQ(%d / %zu)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
 		return -1;
 	}
 
@@ -481,7 +481,7 @@ int ieee80211_rx_ADDBARsp( struct ieee80
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BARSP(%d / %d)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BARSP(%d / %zu)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
 		return -1;
 	}
 	rsp = ( struct ieee80211_hdr_3addr*)skb->data;
@@ -611,7 +611,7 @@ int ieee80211_rx_DELBA(struct ieee80211_
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 6)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in DELBA(%d / %d)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 6));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in DELBA(%d / %zu)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 6));
 		return -1;
 	}
 
--- linux-next-20091124.orig/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ linux-next-20091124/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -845,7 +845,7 @@ int ieee80211_wx_set_gen_ie(struct ieee8
 	{
 		if (len != ie[1]+2)
 		{
-			printk("len:%d, ie:%d\n", len, ie[1]);
+			printk("len:%zu, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
 		buf = kmalloc(len, GFP_KERNEL);
--- linux-next-20091124.orig/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
+++ linux-next-20091124/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
@@ -340,7 +340,7 @@ int ieee80211_rx_ADDBAReq( struct ieee80
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BAREQ(%d / %d)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BAREQ(%d / %zu)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
 		return -1;
 	}
 
@@ -439,7 +439,7 @@ int ieee80211_rx_ADDBARsp( struct ieee80
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BARSP(%d / %d)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BARSP(%d / %zu)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
 		return -1;
 	}
 	rsp = ( struct ieee80211_hdr_3addr*)skb->data;
@@ -569,7 +569,7 @@ int ieee80211_rx_DELBA(struct ieee80211_
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 6)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in DELBA(%d / %d)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 6));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in DELBA(%d / %zu)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 6));
 		return -1;
 	}
 

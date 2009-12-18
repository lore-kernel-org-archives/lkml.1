Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbZLRTiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbZLRTiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZLRTgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:36:35 -0500
Received: from kroah.org ([198.145.64.141]:47447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbZLRTgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:31 -0500
Subject: patch staging-rtl8192x-fix-printk-formats.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:33:52 -0800
In-Reply-To: <4B0C3E83.3060401@oracle.com>
Message-ID: <12611648323978@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: rtl8192x: fix printk formats

to my gregkh-2.6 tree.  Its filename is

    staging-rtl8192x-fix-printk-formats.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com  Fri Dec 18 10:18:11 2009
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 24 Nov 2009 12:13:55 -0800
Subject: Staging: rtl8192x: fix printk formats
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devel@driverdev.osuosl.org, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Message-ID: <4B0C3E83.3060401@oracle.com>


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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c   |    2 +-
 drivers/staging/rtl8192e/ieee80211/rtl819x_BAProc.c |    6 +++---
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c   |    2 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c |    6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
@@ -976,7 +976,7 @@ int ieee80211_wx_set_gen_ie(struct ieee8
 	{
 		if (len != ie[1]+2)
 		{
-			printk("len:%d, ie:%d\n", len, ie[1]);
+			printk("len:%zu, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
 		buf = kmalloc(len, GFP_KERNEL);
--- a/drivers/staging/rtl8192e/ieee80211/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192e/ieee80211/rtl819x_BAProc.c
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
 
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -845,7 +845,7 @@ int ieee80211_wx_set_gen_ie(struct ieee8
 	{
 		if (len != ie[1]+2)
 		{
-			printk("len:%d, ie:%d\n", len, ie[1]);
+			printk("len:%zu, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
 		buf = kmalloc(len, GFP_KERNEL);
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
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
 


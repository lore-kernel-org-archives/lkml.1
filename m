Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbYJ2Wnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbYJ2Wnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYJ2Wnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:43:41 -0400
Received: from kroah.org ([198.145.64.141]:43727 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754614AbYJ2Wnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:43:40 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/49] staging: correct dubious use of !x & y
Date: Wed, 29 Oct 2008 15:39:28 -0700
Message-Id: <1225320016-21803-1-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

Noticed by sparse:
drivers/staging/me4000/me4000.c:1213:43: warning: dubious: !x & y
drivers/staging/wlan-ng/p80211wext.c:1583:21: warning: dubious: !x & y

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/me4000/me4000.c      |    2 +-
 drivers/staging/wlan-ng/p80211wext.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
index 0b33773..6ea2bd4 100644
--- a/drivers/staging/me4000/me4000.c
+++ b/drivers/staging/me4000/me4000.c
@@ -1181,7 +1181,7 @@ static int me4000_xilinx_download(struct me4000_info *info)
 
 	/* Wait until /INIT pin is set */
 	udelay(20);
-	if (!inl(info->plx_regbase + PLX_INTCSR) & 0x20) {
+	if (!(inl(info->plx_regbase + PLX_INTCSR) & 0x20)) {
 		printk(KERN_ERR "%s:Can't init Xilinx\n", __func__);
 		return -EIO;
 	}
diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 906ba43..c42cd7f 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -1580,7 +1580,7 @@ static int p80211wext_set_encodeext(struct net_device *dev,
 
 
   if ( ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY ) {
-    if ( ! ext->alg & IW_ENCODE_ALG_WEP) {
+    if (!(ext->alg & IW_ENCODE_ALG_WEP)) {
       WLAN_LOG_DEBUG(1,"asked to set a non wep key :(");
       return -EINVAL;
     }
-- 
1.6.0.2


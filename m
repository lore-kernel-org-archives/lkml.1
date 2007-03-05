Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbXCEBtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbXCEBtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXCEBtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:49:01 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49920 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751910AbXCEBsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:48:55 -0500
Date: Mon, 5 Mar 2007 02:48:55 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Karsten Keil <kkeil@suse.de>
Cc: kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] make drivers/isdn/capi/capiutil.c:cdebbuf_alloc()
Message-ID: <20070305014854.GU3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global cdebbuf_alloc() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/isdn/capi/capiutil.c  |    8 +-------
 include/linux/isdn/capiutil.h |    1 -
 2 files changed, 1 insertion(+), 8 deletions(-)

--- linux-2.6.21-rc2-mm1/include/linux/isdn/capiutil.h.old	2007-03-04 20:49:17.000000000 +0100
+++ linux-2.6.21-rc2-mm1/include/linux/isdn/capiutil.h	2007-03-04 20:49:25.000000000 +0100
@@ -187,7 +187,6 @@
 #define	CDEBUG_SIZE	1024
 #define	CDEBUG_GSIZE	4096
 
-_cdebbuf *cdebbuf_alloc(void);
 void cdebbuf_free(_cdebbuf *cdb);
 int cdebug_init(void);
 void cdebug_exit(void);
--- linux-2.6.21-rc2-mm1/drivers/isdn/capi/capiutil.c.old	2007-03-04 20:49:33.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/isdn/capi/capiutil.c	2007-03-04 20:50:19.000000000 +0100
@@ -855,7 +855,7 @@
 static u_long g_debbuf_lock;
 static _cmsg *g_cmsg;
 
-_cdebbuf *cdebbuf_alloc(void)
+static _cdebbuf *cdebbuf_alloc(void)
 {
 	_cdebbuf *cdb;
 
@@ -989,11 +989,6 @@
 	return &g_debbuf;
 }
 
-_cdebbuf *cdebbuf_alloc(void)
-{
-	return &g_debbuf;
-}
-
 void cdebbuf_free(_cdebbuf *cdb)
 {
 }
@@ -1009,7 +1004,6 @@
 
 #endif
 
-EXPORT_SYMBOL(cdebbuf_alloc);
 EXPORT_SYMBOL(cdebbuf_free);
 EXPORT_SYMBOL(capi_cmsg2message);
 EXPORT_SYMBOL(capi_message2cmsg);


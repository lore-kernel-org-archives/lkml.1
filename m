Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbZCWQY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbZCWQY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbZCWQYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:24:18 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:33218 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529AbZCWQYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:24:17 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Mike Lee <eemike@gmail.com>,
       Darius Augulis <augulis.darius@gmail.com>
Subject: [PATCH] imx_udc: fix leak in imx_ep_alloc_request()
Date: Mon, 23 Mar 2009 17:24:07 +0100
Message-Id: <1237825447-29391-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck found another leak in drivers/usb/gadget/imx_udc.c

Cc: Mike Lee <eemike@gmail.com>
Cc: Darius Augulis <augulis.darius@gmail.com>
Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/usb/gadget/imx_udc.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/imx_udc.c b/drivers/usb/gadget/imx_udc.c
index 77c5d0a..3ccd92c 100644
--- a/drivers/usb/gadget/imx_udc.c
+++ b/drivers/usb/gadget/imx_udc.c
@@ -718,9 +718,12 @@ static struct usb_request *imx_ep_alloc_request
 {
 	struct imx_request *req;
 
+	if (!usb_ep)
+		return NULL;
+
 	req = kzalloc(sizeof *req, gfp_flags);
-	if (!req || !usb_ep)
-		return 0;
+	if (!req)
+		return NULL;
 
 	INIT_LIST_HEAD(&req->queue);
 	req->in_use = 0;
-- 
1.6.2


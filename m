Return-Path: <linux-kernel-owner+w=401wt.eu-S1161193AbXBGVks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161193AbXBGVks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161430AbXBGVks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:40:48 -0500
Received: from lx1.pxnet.com ([195.227.45.3]:60885 "EHLO lx1.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161193AbXBGVkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:40:47 -0500
Date: Wed, 7 Feb 2007 22:40:38 +0100
Message-Id: <200702072140.l17LecAh000466@lx1.pxnet.com>
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH] drivers/isdn/gigaset: reduce kernel message spam
To: Andrew Morton <akpm@osdl.org>, Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de
CC: Hansjoerg Lipp <hjlipp@web.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the number of kernel messages the Gigaset drivers produce in
case of an excessively long device response, from one per character
exceeding the limit to one per overlong message.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---

 isocdata.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20-rc6-mm3-orig/drivers/isdn/gigaset/isocdata.c	2007-02-01 01:23:54.000000000 +0100
+++ linux-2.6.20-rc6-mm3-work/drivers/isdn/gigaset/isocdata.c	2007-02-05 17:35:47.000000000 +0100
@@ -921,6 +921,8 @@ static void cmd_loop(unsigned char *src,
 			/* end of line */
 			gig_dbg(DEBUG_TRANSCMD, "%s: End of Command (%d Bytes)",
 				__func__, cbytes);
+			if (cbytes >= MAX_RESP_SIZE - 1)
+				dev_warn(cs->dev, "response too large\n");
 			cs->cbytes = cbytes;
 			gigaset_handle_modem_response(cs);
 			cbytes = 0;
@@ -929,8 +931,6 @@ static void cmd_loop(unsigned char *src,
 			/* advance in line buffer, checking for overflow */
 			if (cbytes < MAX_RESP_SIZE - 1)
 				cbytes++;
-			else
-				dev_warn(cs->dev, "response too large\n");
 		}
 	}
 

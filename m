Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYDWV1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYDWV1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYDWV13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:27:29 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:37736 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYDWV13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:27:29 -0400
Message-ID: <480FA9BC.7070205@tiscali.nl>
Date: Wed, 23 Apr 2008 23:27:24 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: hjlipp@web.de, tilman@imap.cc
CC: gigaset307x-common@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] gigaset: gigaset_isowbuf_getbytes() may return signed unnoticed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ifd->offset is unsigned. gigaset_isowbuf_getbytes() may return signed unnoticed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index 5255b5e..c97479b 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -1050,9 +1050,9 @@ static int submit_iso_write_urb(struct isow_urbctx_t *ucx)
 		}
 
 		/* retrieve block of data to send */
-		ifd->offset = gigaset_isowbuf_getbytes(ubc->isooutbuf,
-						       ifd->length);
-		if (ifd->offset < 0) {
+		rc = gigaset_isowbuf_getbytes(ubc->isooutbuf, ifd->length);
+		ifd->offset = rc;
+		if (rc < 0) {
 			if (ifd->offset == -EBUSY) {
 				gig_dbg(DEBUG_ISO,
 					"%s: buffer busy at frame %d",

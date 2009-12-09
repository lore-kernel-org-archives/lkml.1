Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZLIRRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZLIRRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZLIRRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:17:46 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:56035
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZLIRRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:17:46 -0500
Subject: [PATCH] synclink_gt use div_round_up macro
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 09 Dec 2009 12:17:55 -0600
Message-Id: <1260382676.11494.4.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DIV_ROUND_UP macro to simplify code.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/synclink_gt.c	2009-12-09 12:09:25.000000000 -0600
+++ b/drivers/char/synclink_gt.c	2009-12-09 12:10:00.000000000 -0600
@@ -4779,13 +4779,9 @@ static bool tx_load(struct slgt_info *in
 	unsigned short count;
 	unsigned int i;
 	struct slgt_desc *d;
-	unsigned int bufs_needed;
 
 	/* check required buffer space */
-	bufs_needed = (size/DMABUFSIZE);
-	if (size % DMABUFSIZE)
-		++bufs_needed;
-	if (bufs_needed > free_tbuf_count(info))
+	if (DIV_ROUND_UP(size, DMABUFSIZE) > free_tbuf_count(info))
 		return false;
 
 	DBGDATA(info, buf, size, "tx");




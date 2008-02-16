Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYBPQMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYBPQMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYBPQMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:12:36 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:54402 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYBPQMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:12:35 -0500
Message-ID: <47B70B6A.1070404@tiscali.nl>
Date: Sat, 16 Feb 2008 17:12:26 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: luca.risolia@studio.unibo.it
CC: linux-usb@vger.kernel.org, video4linux-list@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] drivers/media/video/sn9c102/sn9c102_core.c Fix Unlikely(x)
 == y
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below was not yet tested. If it's incorrect, please comment.
---
Fix Unlikely(x) == y

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index c40ba3a..66313b1 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -528,7 +528,7 @@ sn9c102_find_sof_header(struct sn9c102_device* cam, void* mem, size_t len)
 
 		/* Search for the SOF marker (fixed part) in the header */
 		for (j = 0, b=cam->sof.bytesread; j+b < sizeof(marker); j++) {
-			if (unlikely(i+j) == len)
+			if (unlikely(i+j == len))
 				return NULL;
 			if (*(m+i+j) == marker[cam->sof.bytesread]) {
 				cam->sof.header[cam->sof.bytesread] = *(m+i+j);

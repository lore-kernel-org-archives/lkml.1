Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbYDQSjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbYDQSjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYDQSjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:39:00 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:50918 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbYDQSi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:38:59 -0400
Message-ID: <48079941.3070209@tiscali.nl>
Date: Thu, 17 Apr 2008 20:38:57 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] OSS: dmabuf: fix negative DMAbuf_get_buffer_pointer() check
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Too late for OSS?
---
Since unsigned active_offs < 0 is even true when DMAbuf_get_buffer_pointer()
returns negative

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/sound/oss/dmabuf.c b/sound/oss/dmabuf.c
index eaf6997..1e90d76 100644
--- a/sound/oss/dmabuf.c
+++ b/sound/oss/dmabuf.c
@@ -795,9 +795,9 @@ static int find_output_space(int dev, char **buf, int *size)
 #ifdef BE_CONSERVATIVE
 	active_offs = dmap->byte_counter + dmap->qhead * dmap->fragment_size;
 #else
-	active_offs = DMAbuf_get_buffer_pointer(dev, dmap, DMODE_OUTPUT);
+	active_offs = max(DMAbuf_get_buffer_pointer(dev, dmap, DMODE_OUTPUT), 0);
 	/* Check for pointer wrapping situation */
-	if (active_offs < 0 || active_offs >= dmap->bytes_in_use)
+	if (active_offs >= dmap->bytes_in_use)
 		active_offs = 0;
 	active_offs += dmap->byte_counter;
 #endif

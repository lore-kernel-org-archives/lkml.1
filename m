Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbYDWT5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbYDWT5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 15:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYDWT4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 15:56:53 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:51951 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYDWT4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 15:56:52 -0400
Message-ID: <480F9481.2040303@tiscali.nl>
Date: Wed, 23 Apr 2008 21:56:49 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: mcgrof@gmail.com, linux-wireless@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] prism54: prism54_get_encode() test below 0 on unsigned index
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

previously in this function:

u32 index = (dwrq->flags & IW_ENCODE_INDEX) - 1;

index is unsigned, so if -1, the original test (below) didn't work.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index e5b3c28..5b375b2 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1186,7 +1186,7 @@ prism54_get_encode(struct net_device *ndev, struct iw_request_info *info,
 	rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYID, 0, NULL, &r);
 	devindex = r.u;
 	/* Now get the key, return it */
-	if ((index < 0) || (index > 3))
+	if (index == -1 || index > 3)
 		/* no index provided, use the current one */
 		index = devindex;
 	rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYX, index, NULL, &r);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbZBHOZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbZBHOZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZBHOZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:25:10 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:63555 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZBHOZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:25:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=uRK9gkyb+uIRwcwAcK+O2Vb06jXVDbDkJ/i1G1geLwk3h5BUdPQHAh2Xqjwcctxg/a
         tkLndLbDTuYovpma+h2aFaM83OBIv3qrUytm6/djDddzBpy7bwdQLEVNcnSI70QcOTxi
         RDq6t5RZkwxs6yk0Wg7bXddhrjEijzU7GW4No=
Message-ID: <498EEB42.1050509@gmail.com>
Date: Sun, 08 Feb 2009 15:25:06 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: airlied@linux.ie
CC: dri-devel@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm: count reaches -1, tested 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a postfix decrement count will reach -1 rather than 0,
subsequent tests fail.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/gpu/drm/via/via_dma.c b/drivers/gpu/drm/via/via_dma.c
index 7a339db..600315c 100644
--- a/drivers/gpu/drm/via/via_dma.c
+++ b/drivers/gpu/drm/via/via_dma.c
@@ -481,9 +481,9 @@ static int via_wait_idle(drm_via_private_t * dev_priv)
 {
 	int count = 10000000;
 
-	while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && count--);
+	while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && --count);
 
-	while (count-- && (VIA_READ(VIA_REG_STATUS) &
+	while (--count && (VIA_READ(VIA_REG_STATUS) &
 			   (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY |
 			    VIA_3D_ENG_BUSY))) ;
 	return count;
@@ -705,7 +705,7 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
 	switch (d_siz->func) {
 	case VIA_CMDBUF_SPACE:
 		while (((tmp_size = via_cmdbuf_space(dev_priv)) < d_siz->size)
-		       && count--) {
+		       && --count) {
 			if (!d_siz->wait) {
 				break;
 			}
@@ -717,7 +717,7 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
 		break;
 	case VIA_CMDBUF_LAG:
 		while (((tmp_size = via_cmdbuf_lag(dev_priv)) > d_siz->size)
-		       && count--) {
+		       && --count) {
 			if (!d_siz->wait) {
 				break;
 			}


Return-Path: <linux-kernel-owner+w=401wt.eu-S2993053AbXCIHW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993053AbXCIHW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993039AbXCIHW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:22:58 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:7251 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993053AbXCIHWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:22:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=pRoLBfAblx/HAhkHj5wOsDdekTdOI9UYhVvBdwKkDxAYUb5pOo9nXBu/5XE4AfR84HcB4zgfShpt5Vh4X6hDPiRytwNAId3yivTT2UlNRsOC/dqg1SN361KKN1twJ7Pfd9/m7DYTeAM06FmDx64EUmXzaRktGaTjYRe/50dRK7k=
Date: Thu, 8 Mar 2007 23:22:39 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, akpm@osdl.org
Cc: netdev@vger.kernel.org
Subject: [PATCH] drivers/char/synclink.c: check kmalloc() return value.
Message-Id: <20070308232239.8db0f42b.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function mgsl_alloc_intermediate_txbuffer_memory(), in file drivers/char/synclink.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 06784ad..24f99bc 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -4012,8 +4012,13 @@ static int mgsl_alloc_intermediate_txbuf
 	for ( i=0; i<info->num_tx_holding_buffers; ++i) {
 		info->tx_holding_buffers[i].buffer =
 			kmalloc(info->max_frame_size, GFP_KERNEL);
-		if ( info->tx_holding_buffers[i].buffer == NULL )
+		if (info->tx_holding_buffers[i].buffer == NULL) {
+			for (--i; i >= 0; i--) {
+				kfree(info->tx_holding_buffers[i].buffer);
+				info->tx_holding_buffers[i].buffer = NULL;
+			}
 			return -ENOMEM;
+		}
 	}
 
 	return 0;

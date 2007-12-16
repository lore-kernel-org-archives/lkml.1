Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbXLPSbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbXLPSbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 13:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXLPSb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 13:31:27 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:31347 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753735AbXLPSb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 13:31:26 -0500
Message-Id: <20071216181736.609241472@mvista.com>
User-Agent: quilt/0.46-1
Date: Sun, 16 Dec 2007 00:00:01 -0800
Subject: [PATCH 1/2] [RESEND] ps3: vuart: fix error path locking
Message-Id: <20071216181705.714358296@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, linuxppc-dev@ozlabs.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
Content-Disposition: inline; filename=ps3-vuart-locking-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This stray down would cause a permanent sleep which doesn't seem correct. 
The other uses of this semaphore appear fairly mutex like it's even initialized
with init_MUTEX() ..  So here a patch for removing this one down().

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/ps3/ps3-vuart.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.23/drivers/ps3/ps3-vuart.c
===================================================================
--- linux-2.6.23.orig/drivers/ps3/ps3-vuart.c
+++ linux-2.6.23/drivers/ps3/ps3-vuart.c
@@ -1072,7 +1072,6 @@ static int ps3_vuart_probe(struct ps3_sy
 	if (result) {
 		dev_dbg(&dev->core, "%s:%d: drv->probe failed\n",
 			__func__, __LINE__);
-		down(&vuart_bus_priv.probe_mutex);
 		goto fail_probe;
 	}
 

-- 

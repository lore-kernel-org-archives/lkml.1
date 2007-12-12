Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbXLMAnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbXLMAnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 19:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXLMAnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 19:43:33 -0500
Received: from homer.mvista.com ([63.81.120.158]:48756 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751862AbXLMAnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 19:43:32 -0500
Message-Id: <20071213003028.676998182@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Dec 2007 00:00:01 -0800
Subject: [PATCH 1/3] ps3: vuart: fix error path locking
Message-Id: <20071213003023.117964080@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, linuxppc-dev@ozlabs.org
Content-Disposition: inline; filename=ps3-vuart-locking-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This stray down would cause a permanent sleep which doesn't seem correct. 
The other uses of this semaphore appear fairly mutex like it's even initialized
with init_MUTEX() ..  So here a patch for removing this one down().

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

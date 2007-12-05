Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbXLFCa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbXLFCa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbXLFCal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:30:41 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:42031 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755838AbXLFCak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:30:40 -0500
Message-Id: <20071206021908.991465239@mvista.com>
References: <20071206021906.632232033@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 00:00:02 -0800
Subject: [PATCH 2/3] Amiga serial driver: port_write_mutex fixup
References: <20071206021857.826386004@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com
Content-Disposition: inline; filename=ser_a2232-semaphore-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The port_write_mutex was converted from a semaphore to a mutex, 
but there was still this ifdef'd init_MUTEX reference remaining.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/char/ser_a2232.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/drivers/char/ser_a2232.c
===================================================================
--- linux-2.6.23.orig/drivers/char/ser_a2232.c
+++ linux-2.6.23/drivers/char/ser_a2232.c
@@ -653,7 +653,7 @@ static void a2232_init_portstructs(void)
 		port->gs.closing_wait = 30 * HZ;
 		port->gs.rd = &a2232_real_driver;
 #ifdef NEW_WRITE_LOCKING
-		init_MUTEX(&(port->gs.port_write_mutex));
+		mutex_init(&(port->gs.port_write_mutex));
 #endif
 		init_waitqueue_head(&port->gs.open_wait);
 		init_waitqueue_head(&port->gs.close_wait);

-- 

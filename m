Return-Path: <linux-kernel-owner+w=401wt.eu-S933709AbXGWBMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709AbXGWBMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbXGWBML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:12:11 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41542 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756755AbXGWBMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:12:10 -0400
Date: Mon, 23 Jul 2007 03:11:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: jeremy@xensource.com, chrisw@sous-sol.org
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [2.6.23 patch] xenbus_xs.c: fix a use-after-free
Message-ID: <20070723011135.GU26212@stusta.de>
References: <20070723010204.GT26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070723010204.GT26212@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an obvious use-after-free spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/xen/xenbus/xenbus_xs.c.old	2007-07-23 03:04:20.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/xen/xenbus/xenbus_xs.c	2007-07-23 03:04:42.000000000 +0200
@@ -782,8 +782,8 @@ static int process_msg(void)
 		msg->u.watch.vec = split(body, msg->hdr.len,
 					 &msg->u.watch.vec_size);
 		if (IS_ERR(msg->u.watch.vec)) {
-			kfree(msg);
 			err = PTR_ERR(msg->u.watch.vec);
+			kfree(msg);
 			goto out;
 		}
 


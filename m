Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbYEOV0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbYEOV0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYEOV0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:26:30 -0400
Received: from smtp27.orange.fr ([80.12.242.96]:36322 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYEOV03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:26:29 -0400
X-ME-UUID: 20080515212624874.D56371C00093@mwinf2723.orange.fr
Subject: [PATCH 1/1] /drivers/net/r6040.c: bad use of round_jiffies() ???
From: "Christophe Jaillet" <christophe.jaillet@wanadoo.fr>
To: "cj" <christophe.jaillet@wanadoo.fr>,
       "linux" <linux-kernel@vger.kernel.org>,
       <florian.fainelli@telecomint.eu>, <netdev@vger.kernel.org>
Date: Thu, 15 May 2008 23:26:22 +0200
Content-Type: text/plain
X-Mailer: email v2.5.1 (CYGWIN_NT-5.0 1.5.25(0.156/4/2) i686 [http://email.cleancode.org])
X-Antivirus: avast! (VPS 080515-1, 15/05/2008), Outbound message
X-Antivirus-Status: Clean
Message-Id: <20080515212624.D56371C00093@mwinf2723.orange.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Hi, here is a patch against linux/drivers/net/r6040.c.

Compared to other places in the kernel, I think that this driver misuses
the function round_jiffies.


Note: this patch is based on 'linux-2.6.25.tar.bz2'

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

---

--- linux 2.6.25/drivers/net/r6040.c	2008-05-15 23:21:28.000000000 +0200
+++ linux 2.6.25/drivers/net/r6040.c.cj	2008-05-15 22:16:44.000000000 +0200
@@ -733,7 +733,7 @@ static void r6040_timer(unsigned long da
 	}
 
 	/* Timer active again */
-	mod_timer(&lp->timer, jiffies + round_jiffies(HZ));
+	mod_timer(&lp->timer, round_jiffies(jiffies + HZ));
 }
 
 /* Read/set MAC address routines */



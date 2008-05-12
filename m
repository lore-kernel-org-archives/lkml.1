Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbYELVgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbYELVgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbYELVgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:36:07 -0400
Received: from smtp21.orange.fr ([80.12.242.46]:31040 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbYELVgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:36:06 -0400
X-ME-UUID: 20080512213601403.626C91C0008F@mwinf2103.orange.fr
Subject: [PATCH 1/1] infiniband/hw/nes/: avoid unnecessary memset
From: "Christophe Jaillet" <christophe.jaillet@wanadoo.fr>
To: "cj" <christophe.jaillet@wanadoo.fr>,
       "linux" <linux-kernel@vger.kernel.org>, <flatif@neteffect.com>,
       <ngupta@neteffect.com>, <gstreiff@neteffect.com>,
       <general@lists.openfabrics.org>
Date: Mon, 12 May 2008 23:35:59 +0200
Content-Type: text/plain
X-Mailer: email v2.5.1 (CYGWIN_NT-5.0 1.5.25(0.156/4/2) i686 [http://email.cleancode.org])
X-Antivirus: avast! (VPS 080512-0, 12/05/2008), Outbound message
X-Antivirus-Status: Clean
Message-Id: <20080512213601.626C91C0008F@mwinf2103.orange.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Hi, here is a patch against linux/drivers/infiniband/hw/nes/nes_cm.c which :
	
1) Remove an explicit memset(.., 0, ...) to a variable allocated with
kzalloc (i.e. 'listener').


Note: this patch is based on 'linux-2.6.25.tar.bz2'

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

---

--- linux/drivers/infiniband/hw/nes/nes_cm.c	2008-04-17 04:49:44.000000000 +0200
+++ linux/drivers/infiniband/hw/nes/nes_cm.c.cj	2008-05-12 23:31:24.000000000 +0200
@@ -1587,7 +1587,6 @@ static struct nes_cm_listener *mini_cm_l
 			return NULL;
 		}
 
-		memset(listener, 0, sizeof(struct nes_cm_listener));
 		listener->loc_addr = htonl(cm_info->loc_addr);
 		listener->loc_port = htons(cm_info->loc_port);
 		listener->reused_node = 0;


